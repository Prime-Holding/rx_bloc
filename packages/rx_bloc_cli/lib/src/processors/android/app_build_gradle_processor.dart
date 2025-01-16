import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing android/app/build.gradle file
class AppBuildGradleProcessor extends StringProcessor {
  /// Android app build gradle processor constructor
  AppBuildGradleProcessor(super.args);

  String get _tabSpace => '    ';

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _modifyValues(buffer);
    _addKeyPropertiesConfig(buffer);
    _adjustBuildTypesAndSigningConfigs(buffer);
    _adjustCompileOptionsConfigs(buffer);
    _buildDependenciesList(buffer);

    if (!args.socialLoginsEnabled) {
      // The social login entries are per flavor and are already generated.
      // if social login is not enabled, remove the entries.
      _removeSocialLogins(buffer);
    }

    if (args.patrolTestsEnabled) {
      _applyPatrolToDefaultConfig(buffer);
      _applyTestOptions(buffer);
    }

    return buffer.toString();
  }

  /// region Private methods

  void _modifyValues(
    StringBuffer buffer, {
    int compileSDK = kAndroidCompileSDKVersion,
    int targetSDK = kAndroidTargetSDKVersion,
    int minSDK = kAndroidMinSDKVersion,
  }) {
    void _replaceVal(String content, String replacement) {
      final start = buffer.nthIndexOf(content);
      if (start < 0) return;
      final end = start + content.length;
      buffer.replaceRange(start, end, replacement);
    }

    void _replaceQuotedVal(
      String content,
      String replacement, {
      int start = 0,
    }) {
      final sIndex = buffer.nthIndexOf('"',
              start: buffer.nthIndexOf(content, start: start)) +
          1;
      if (sIndex < 0) return;
      final eIndex = buffer.nthIndexOf('"', start: sIndex);
      buffer.replaceRange(sIndex, eIndex, replacement);
    }

    _replaceVal('flutter.compileSdkVersion', '$compileSDK');
    _replaceVal('flutter.targetSdkVersion', '$targetSDK');
    _replaceVal('flutter.minSdkVersion', '$minSDK');

    _replaceQuotedVal('namespace', packageId);
    _replaceQuotedVal(
      'applicationId',
      packageId,
      start: buffer.nthIndexOf('defaultConfig'),
    );
  }

  void _adjustBuildTypesAndSigningConfigs(StringBuffer buffer) {
    final sIndex = buffer.nthIndexOf('buildTypes') - 4;
    if (sIndex < 0) return;
    final eIndex = buffer.nthIndexOf('}', n: 2, start: sIndex) + 1;

    const content = '''
    signingConfigs {
        if (System.getenv("ANDROID_KEYSTORE_PATH")) {
            release {
                storeFile file(System.getenv("ANDROID_KEYSTORE_PATH"))
                keyAlias System.getenv("ANDROID_KEYSTORE_ALIAS")
                keyPassword System.getenv("ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD")
                storePassword System.getenv("ANDROID_KEYSTORE_PASSWORD")
            }
        } else {
            release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
                storePassword keystoreProperties['storePassword']
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        debug {
            signingConfig signingConfigs.debug
        }
    }
    ''';

    buffer.replaceRange(sIndex, eIndex, content);
  }

  void _adjustCompileOptionsConfigs(StringBuffer buffer) {
    final sIndex = buffer.nthIndexOf('compileOptions') - 4;
    if (sIndex < 0) return;
    final startIndex = buffer.nthIndexOf('}', n: 1, start: sIndex);


    var content = '';

    if (!args.pushNotificationsEnabled) {
      //this can be removed if we stop using local_notifications
      content = '''

        coreLibraryDesugaringEnabled true
    }
    ''';
    }

    if(content.isEmpty) return;

    buffer.replaceRange(startIndex, startIndex + 1 , content);
  }

  void _addKeyPropertiesConfig(StringBuffer buffer) {
    const beforePattern = 'def localProperties = new Properties()';

    const content = '''
    
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

''';

    if (!buffer.toString().contains(beforePattern)) {
      buffer.insertBefore(
        'namespace =',
        content.replaceAll('\n', '\n$_tabSpace'),
      );
    } else {
      buffer.insertBefore(beforePattern, content);
    }
  }

  void _buildDependenciesList(StringBuffer buffer) {
    final sIndex = buffer.nthIndexOf('dependencies');
    var content = 'dependencies {\n';
    if (args.patrolTestsEnabled) {
      content +=
      '${_tabSpace}androidTestUtil "androidx.test:orchestrator:1.4.2"\n';
    }

    if (args.pushNotificationsEnabled) {
      content +=
      '${_tabSpace}coreLibraryDesugaring ' +
          '"com.android.tools:desugar_jdk_libs:1.2.2"\n';
    }
    content += '}';

    if (sIndex < 0) {
      // Append the dependencies section at the end of the buffer
      buffer.write('\n$content\n');
    } else {
      final eIndex = buffer.nthIndexOf('}', start: sIndex) + 1;
      buffer.replaceRange(sIndex, eIndex, content);
    }
  }

  void _applyPatrolToDefaultConfig(StringBuffer buffer) {
    var (sIndex, eIndex) =
        buffer.getGradleSectionLastLineRange('defaultConfig');
    if (sIndex < 0) return;
    final content = '''
    \n$_tabSpace${_tabSpace}testInstrumentationRunner "pl.leancode.patrol.PatrolJUnitRunner"
    ${_tabSpace}testInstrumentationRunnerArguments clearPackageData: "true"
    ''';
    buffer.insertAt(sIndex, content);

    (sIndex, eIndex) = buffer.getGradleSectionLastLineRange('defaultConfig');
    if (sIndex < 0) return;
    buffer.replaceRange(sIndex, eIndex, '');
  }

  void _applyTestOptions(StringBuffer buffer) {
    final content = '''
    testOptions {
      execution "ANDROIDX_TEST_ORCHESTRATOR"
    }\n
    ''';

    buffer
      ..insertBefore('defaultConfig', content)
      ..replaceRange(buffer.nthIndexOf('testOptions') - 4,
          buffer.nthIndexOf('testOptions'), '');
  }

  void _removeSocialLogins(StringBuffer buffer) {
    var sIndex = -1;
    var eIndex = -1;
    do {
      sIndex = buffer.nthIndexOf('resValue "string", "facebook_app_id"');
      if (sIndex >= 0) {
        eIndex = buffer.nthIndexOf('}', start: sIndex);
        sIndex = buffer.toString().lastIndexOf('\n', sIndex);
        buffer.replaceRange(sIndex, eIndex, '\n$_tabSpace$_tabSpace');
      }
    } while (sIndex >= 0);
  }

  /// endregion
}
