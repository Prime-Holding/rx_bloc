import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/templates/feature_counter_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_widget_toolkit_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_auth_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_permissions_bundle.dart';

import '../templates/feature_deeplink_bundle.dart';
import '../templates/lib_router_bundle.dart';
import '../templates/rx_bloc_base_bundle.dart';
import '../utils/git_ignore_creator.dart';

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
    argParser
      ..addOption(
        _projectNameString,
        help: 'The project name for this new Flutter project. This must be a '
            'valid dart package name. If no project name is supplied, '
            'the name of the directory is used as the project name.',
        mandatory: true,
      )
      ..addOption(
        _organisationString,
        help: 'The organisation name.',
        defaultsTo: 'com.example',
      )
      ..addOption(
        _counterString,
        help: 'The counter showcase feature',
        defaultsTo: 'false',
      )
      ..addOption(
        _widgetToolkitString,
        help: 'The widget toolkit showcase feature',
        defaultsTo: 'false',
      )
      ..addOption(
        _deepLinkString,
        help: 'The deeplink showcase feature',
        defaultsTo: 'false',
      )
      ..addOption(
        _analyticsString,
        help: 'Enables Firebase analytics for the project',
        allowed: ['true', 'false'],
        defaultsTo: 'false',
      )
      ..addOption(
        _facebookAuthString,
        help: 'Enables facebook authentication for the project',
        defaultsTo: 'true',
      );
  }

  /// region Fields

  final _projectNameString = 'project-name';
  final _organisationString = 'organisation';
  final _analyticsString = 'enable-analytics';
  final _counterString = 'enable-feature-counter';
  final _deepLinkString = 'enable-feature-deeplinks';
  final _widgetToolkitString = 'enable-feature-widget-toolkit';
  final _facebookAuthString = 'enable-feature-facebook-auth';

  /// bundles
  final _counterBundle = featureCounterBundle;
  final _deepLinkBundle = featureDeeplinkBundle;
  final _widgetToolkitBundle = featureWidgetToolkitBundle;
  final _libRouterBundle = libRouterBundle;
  final _permissionsBundle = libPermissionsBundle;
  final _libAuthBundle = libAuthBundle;
  final _libFacebookAuthBundle = libAuthFacebookBundle;

  final Logger _logger;
  final MasonBundle _bundle;
  final Future<MasonGenerator> Function(MasonBundle) _generator;

  /// Regex for package name
  final RegExp _packageNameRegExp = RegExp('[a-z_][a-z0-9_]*');

  /// Regex for organization name and domain
  final RegExp _orgNameDomainRegExp =
      RegExp('^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$');

  /// endregion

  /// region Command requirements

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new project in the specified directory.';

  @override
  Future<int> run() async {
    await _generateViaMasonBundle();
    await _postGen();
    return ExitCode.success.code;
  }

  /// endregion

  /// region Code generation

  Future<void> _postGen() async {
    final arguments = _validateAndParseArguments(argResults!);
    var progress = _logger.progress('dart pub get');

    final dartGet = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: arguments.outputDirectory.path,
    );

    _progressFinish(dartGet, progress);

    progress = _logger.progress(
      'dart run build_runner build --delete-conflicting-outputs',
    );

    final buildRunner = await Process.run(
      'dart',
      [
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
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

  Future<void> _generateViaMasonBundle() async {
    final arguments = _validateAndParseArguments(argResults!);

    final organizationName = arguments.organisation;
    final orgSeparatorIndex = organizationName.indexOf('.');
    final orgDomain = organizationName.substring(0, orgSeparatorIndex);
    final orgName = organizationName.substring(orgSeparatorIndex + 1);

    // Whether Firebase is used in the generated project.
    // Usually `true` because Firebase is used for push notifications.
    final usesFirebase = arguments.enableAnalytics || true;

    // Remove files when they are not needed by the specified features.
    if (!arguments.enableAnalytics) {
      _bundle.files.removeWhere((file) =>
          file.path ==
          'lib/base/data_sources/remote/interceptors/analytics_interceptor.dart');
    }
    // Add counter brick to _bundle when needed
    if (arguments.enableCounterFeature) {
      _bundle.files.addAll(_counterBundle.files);
    }

    // Add widget toolkit brick to _bundle when needed
    if (arguments.enableWidgetToolkitFeature) {
      _bundle.files.addAll(_widgetToolkitBundle.files);
    }

    // Add deep link brick to _bundle when needed
    if (arguments.enableDeeplinkFeature) {
      _bundle.files.addAll(_deepLinkBundle.files);
    }

    // Add facebook auth brick to _bundle when needed
    if (arguments.enableFacebookAuth) {
      _bundle.files.addAll(_libFacebookAuthBundle.files);
    }

    //Add lib_route to _bundle
    _bundle.files.addAll(_libRouterBundle.files);
    //Add lib_permissions to _bundle
    _bundle.files.addAll(_permissionsBundle.files);
    //Add lib_auth to _bundle
    _bundle.files.addAll(_libAuthBundle.files);

    _logger.info('');
    final fileGenerationProgress = _logger.progress('Bootstrapping');
    final generator = await _generator(_bundle);
    var generatedFiles = await generator.generate(
      DirectoryGeneratorTarget(arguments.outputDirectory),
      vars: {
        'project_name': arguments.projectName,
        'domain_name': orgDomain,
        'organization_name': orgName,
        'uses_firebase': usesFirebase,
        'analytics': arguments.enableAnalytics,
        'push_notifications': true,
        'enable_feature_counter': arguments.enableCounterFeature,
        'enable_feature_deeplinks': arguments.enableDeeplinkFeature,
        'enable_feature_widget_toolkit': arguments.enableWidgetToolkitFeature,
        'enable_facebook_auth': arguments.enableFacebookAuth,
      },
    );

    // Manually create gitignore.
    GitIgnoreCreator.generate(arguments.outputDirectory.path);

    final fileCount = generatedFiles.length + 1;

    fileGenerationProgress.complete('Bootstrapping done');

    await _writeOutputLog(fileCount, arguments);
  }

  /// endregion

  /// region Argument Parsing

  _CreateCommandArguments _validateAndParseArguments(ArgResults arguments) {
    return _CreateCommandArguments(
      projectName: _parseProjectName(arguments),
      organisation: _parseOrganisation(arguments),
      enableAnalytics: _parseEnableAnalytics(arguments),
      outputDirectory: _parseOutputDirectory(arguments),
      enableCounterFeature: _parseEnableCounter(arguments),
      enableDeeplinkFeature: _parseEnableDeeplinkFeature(arguments),
      enableWidgetToolkitFeature: _parseEnableWidgetToolkit(arguments),
      enableFacebookAuth: _parseFacebookAuth(arguments),
    );
  }

  /// Gets the project name.
  String _parseProjectName(ArgResults arguments) {
    final projectName = arguments[_projectNameString] as String;
    _validateProjectName(projectName);
    return projectName;
  }

  /// Returns the organization name with domain in front of it
  String _parseOrganisation(ArgResults arguments) {
    final value = (arguments[_organisationString] ?? '') as String;
    _validateOrganisation(value);
    return value;
  }

  /// Gets the directory used for the file generation
  Directory _parseOutputDirectory(ArgResults arguments) {
    final rest = arguments.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  /// Returns whether the project will be created with counter feature
  bool _parseEnableCounter(ArgResults arguments) {
    final counterEnabled = arguments[_counterString];
    return counterEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with widget toolkit feature
  bool _parseEnableWidgetToolkit(ArgResults arguments) {
    final widgetToolkitEnabled = arguments[_widgetToolkitString];
    return widgetToolkitEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will use analytics or not
  bool _parseEnableAnalytics(ArgResults arguments) {
    final analyticsEnabled = arguments[_analyticsString];
    return analyticsEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with counter feature
  bool _parseEnableDeeplinkFeature(ArgResults arguments) {
    final deeplinkEnabled = arguments[_deepLinkString];
    return deeplinkEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with facebook authentication
  bool _parseFacebookAuth(ArgResults arguments) {
    final facebookAuthEnabled = arguments[_facebookAuthString];
    return facebookAuthEnabled.toLowerCase() == 'true';
  }

  /// endregion

  /// region Validation

  void _validateProjectName(String name) {
    final isValidProjectName = _stringMatchesRegex(_packageNameRegExp, name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
  }

  void _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple output directories specified.', usage);
    }
  }

  void _validateOrganisation(String orgName) {
    if (orgName.trim().isEmpty) {
      throw UsageException('No organisation name specified.', usage);
    }

    if (!_stringMatchesRegex(_orgNameDomainRegExp, orgName)) {
      throw UsageException('Invalid organisation name.', usage);
    }
  }

  bool _stringMatchesRegex(RegExp regex, String name) {
    final match = regex.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  /// endregion

  /// region Output logging

  /// Writes an output log with the status of the file generation
  Future<void> _writeOutputLog(
      int fileCount, _CreateCommandArguments arguments) async {
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
  void _successMessageLog(int fileCount, _CreateCommandArguments arguments) {
    if (fileCount < 1) return;

    _delayedLog('Generated project with package name: '
        // ignore: lines_longer_than_80_chars
        '${lightCyan.wrap('${arguments.organisation}.${arguments.projectName}')}');

    _usingLog('Firebase Analytics', arguments.enableAnalytics);
    _usingLog('Firebase Push Notifications', true);
    _usingLog('Feature Counter Showcase', arguments.enableCounterFeature);
    _usingLog('Feature Deep links Showcase', arguments.enableDeeplinkFeature);
    _usingLog(
      'Feature Widget Toolkit Showcase',
      arguments.enableWidgetToolkitFeature,
    );
    _usingLog(
      'Add Facebook Authentication library to Login feature',
      arguments.enableFacebookAuth,
    );
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

class _CreateCommandArguments {
  _CreateCommandArguments({
    required this.projectName,
    required this.organisation,
    required this.enableAnalytics,
    required this.outputDirectory,
    required this.enableCounterFeature,
    required this.enableDeeplinkFeature,
    required this.enableWidgetToolkitFeature,
    required this.enableFacebookAuth,
  });

  final String projectName;
  final String organisation;
  final bool enableAnalytics;
  final Directory outputDirectory;
  final bool enableCounterFeature;
  final bool enableDeeplinkFeature;
  final bool enableWidgetToolkitFeature;
  final bool enableFacebookAuth;
}
