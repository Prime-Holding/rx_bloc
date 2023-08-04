import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../extensions/arg_parser_extensions.dart';
import '../extensions/arg_results_extensions.dart';
import '../models/command_arguments.dart';
import '../models/command_arguments_reader.dart';
import '../models/create_command_arguments_provider.dart';
import '../models/project_generation_arguments.dart';
import '../templates/feature_counter_bundle.dart';
import '../templates/feature_deeplink_bundle.dart';
import '../templates/feature_login_bundle.dart';
import '../templates/feature_otp_bundle.dart';
import '../templates/feature_widget_toolkit_bundle.dart';
import '../templates/lib_auth_bundle.dart';
import '../templates/lib_change_language_bundle.dart';
import '../templates/lib_dev_menu_bundle.dart';
import '../templates/lib_permissions_bundle.dart';
import '../templates/lib_realtime_communication_bundle.dart';
import '../templates/lib_router_bundle.dart';
import '../templates/lib_social_logins_bundle.dart';
import '../templates/patrol_integration_tests_bundle.dart';
import '../templates/rx_bloc_base_bundle.dart';
import '../utils/git_ignore_creator.dart';

part '../models/create_command_bundle_provider.dart';

/// CreateCommand is a custom command that helps you create a new project.
class CreateCommand extends Command<int> {
  /// Allows you to customize the creation of the project by providing
  /// additional parameters to the cli command. It accesses the default template
  /// if none is provided. You can however provide your own mason bundle to
  /// generate the project from.
  CreateCommand({
    Logger? logger,
    MasonBundle? bundle,
    Future<MasonGenerator> Function(MasonBundle)? generator,
  })  : _logger = logger ?? Logger(),
        _bundle = bundle ?? rxBlocBaseBundle,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addCommandArguments(CommandArguments.values);
  }

  final Logger _logger;
  final MasonBundle _bundle;
  final Future<MasonGenerator> Function(MasonBundle) _generator;

  /// region Command requirements

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new project in the specified directory.';

  @override
  Future<int> run() async {
    final arguments = _readCommandArguments();
    await _generateViaMasonBundle(arguments);
    await _postGen(arguments);
    return ExitCode.success.code;
  }

  /// endregion

  /// region Code generation

  ProjectGenerationArguments _readCommandArguments() {
    final arguments = argResults!;
    final interactive = arguments.interactiveConfigurationEnabled;
    final reader =
        interactive ? LoggerReader(_logger) : ArgResultsReader(arguments);
    final provider = ProjectGenerationArgumentsProvider(
      arguments.outputDirectory,
      _logger,
      reader,
    );

    try {
      return provider.readProjectGenerationArguments();
    } catch (e) {
      if (e is! Exception) rethrow;

      throw UsageException(
        '', // TODO: ADD
        usage,
      );
    }
  }

  Future<void> _postGen(ProjectGenerationArguments arguments) async {
    var progress = _logger.progress('dart pub get');

    final dartGet = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: arguments.outputDirectory.path,
    );

    _progressFinish(dartGet, progress);

    progress = _logger.progress(
      'dart run build_runner build',
    );

    final buildRunner = await Process.run(
      'dart',
      [
        'run',
        'build_runner',
        'build',
      ],
      workingDirectory: arguments.outputDirectory.path,
    );

    _progressFinish(buildRunner, progress);

    progress = _logger.progress(
      'dart format .',
    );

    final format = await Process.run(
      'dart',
      ['format', '.'],
      workingDirectory: arguments.outputDirectory.path,
    );

    _progressFinish(format, progress);
  }

  void _progressFinish(ProcessResult result, Progress progress) {
    if (result.stderr.toString().trim().isNotEmpty) {
      progress.fail(result.stderr.toString());
    } else {
      progress.complete();
    }
  }

  Future<void> _generateViaMasonBundle(
      ProjectGenerationArguments arguments) async {
    final bundles = _CreateCommandBundleProvider(arguments).generate();

    for (final bundle in bundles) {
      _bundle.files.addAll(bundle.files);
    }

    // Remove files when they are not needed by the specified features.
    if (!arguments.enableAnalytics) {
      _bundle.files.removeWhere((file) =>
          file.path ==
          'lib/base/data_sources/remote/interceptors/analytics_interceptor.dart');
    }

    _logger.info('');
    final fileGenerationProgress = _logger.progress('Bootstrapping');
    final generator = await _generator(_bundle);
    var generatedFiles = await generator.generate(
      DirectoryGeneratorTarget(arguments.outputDirectory),
      vars: {
        'project_name': arguments.projectName,
        'domain_name': arguments.organisationDomain,
        'organization_name': arguments.organisationName,
        'uses_firebase': arguments.usesFirebase,
        'analytics': arguments.enableAnalytics,
        'push_notifications': arguments.usesPushNotifications,
        'enable_feature_counter': arguments.enableCounter,
        'enable_feature_deeplinks': arguments.enableDeeplink,
        'enable_feature_widget_toolkit': arguments.enableWidgetToolkit,
        'enable_login': arguments.enableLogin,
        'enable_social_logins': arguments.enableSocialLogins,
        'enable_change_language': arguments.enableChangeLanguage,
        'enable_dev_menu': arguments.enableDevMenu,
        'enable_feature_otp': arguments.enableOtp,
        'enable_patrol': arguments.enablePatrolTests,
        'has_authentication': arguments.hasAuthentication,
        'realtime_communication': arguments.realtimeCommunicationEnabled,
      },
    );

    // Manually create gitignore.
    GitIgnoreCreator.generate(arguments.outputDirectory.path);

    final fileCount = generatedFiles.length + 1;

    fileGenerationProgress.complete('Bootstrapping done');

    await _writeOutputLog(fileCount, arguments);
  }

  /// endregion

  /// region Output logging

  /// Writes an output log with the status of the file generation
  Future<void> _writeOutputLog(
      int fileCount, ProjectGenerationArguments arguments) async {
    final filesGeneratedStr =
        fileCount == 0 ? 'No files generated.' : 'Generated $fileCount file(s)';

    _logger
      ..info('${lightGreen.wrap('✓')} $filesGeneratedStr')
      ..info('')
      ..delayed('');

    _successMessageLog(fileCount, arguments);

    _logger
      ..delayed('')
      ..flush(_logger.success);
  }

  /// Message shown in the output log upon successful generation
  void _successMessageLog(int fileCount, ProjectGenerationArguments arguments) {
    if (fileCount < 1) return;

    _delayedLog('Generated project with package name: '
        // ignore: lines_longer_than_80_chars
        '${lightCyan.wrap('${arguments.organisation}.${arguments.projectName}')}');

    _usingLog('Firebase Analytics', arguments.enableAnalytics);
    _usingLog('Firebase Push Notifications', true);
    _usingLog('Feature Counter Showcase', arguments.enableCounter);
    _usingLog('Feature Deep links Showcase', arguments.enableDeeplink);
    _usingLog(
      'Feature Widget Toolkit Showcase',
      arguments.enableWidgetToolkit,
    );
    _usingLog('Feature Login', arguments.enableLogin);
    _usingLog('Social Logins [Apple, Google, Facebook]',
        arguments.enableSocialLogins);
    _usingLog('Enable Change Language', arguments.enableChangeLanguage);
    _usingLog('Dev Menu', arguments.enableDevMenu);
    _usingLog('OTP Feature', arguments.enableOtp);
    _usingLog('Patrol integration tests', arguments.enablePatrolTests);
    _usingLog('Realtime communication', arguments.realtimeCommunicationEnabled);
  }

  /// Shows a delayed log with a success symbol in front of it
  void _delayedLog(String text, {bool success = true, bool newline = false}) {
    final symbol = success ? lightGreen.wrap('✓') : red.wrap('x');
    _logger.delayed('$symbol ${white.wrap(text)}');
    if (newline) _logger.delayed('');
  }

  /// Prints a (delayed) log for whether the specified item is being used or not
  void _usingLog(String item, bool enabled, {bool newline = false}) {
    final usingStr = enabled ? 'Using' : 'Not using';
    _delayedLog('$usingStr $item', success: enabled, newline: newline);
  }

  /// endregion
}
