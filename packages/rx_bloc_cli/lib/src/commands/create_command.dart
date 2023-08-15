import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../extensions/arg_parser_extensions.dart';
import '../extensions/arg_results_extensions.dart';
import '../models/bundle_generator.dart';
import '../models/command_arguments.dart';
import '../models/generator_arguments.dart';
import '../models/generator_arguments_provider.dart';
import '../models/readers/interactive_arguments_reader.dart';
import '../models/readers/non_interactive_arguments_reader.dart';
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
        _bundleGenerator = BundleGenerator(bundle ?? rxBlocBaseBundle),
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addCommandArguments(CommandArguments.values);
  }

  final Logger _logger;
  final BundleGenerator _bundleGenerator;
  final Future<MasonGenerator> Function(MasonBundle) _generator;

  /// region Command requirements

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new project in the specified directory.';

  @override
  Future<int> run() async {
    final arguments = _readGeneratorArguments();
    await _generateViaMasonBundle(arguments);
    await _postGen(arguments.outputDirectory);
    return ExitCode.success.code;
  }

  /// endregion

  /// region Code generation

  GeneratorArguments _readGeneratorArguments() {
    final parsedArgumentResults = argResults!;
    final outputDirectory = parsedArgumentResults.outputDirectory;
    final reader = parsedArgumentResults.interactiveConfigurationEnabled
        ? InteractiveArgumentsReader(_logger)
        : NonInteractiveArgumentsReader(parsedArgumentResults);

    final generatorArgumentsProvider =
        GeneratorArgumentsProvider(outputDirectory, reader, _logger);

    try {
      return generatorArgumentsProvider.readGeneratorArguments();
    } catch (e) {
      throw UsageException(e.toString(), usage);
    }
  }

  Future<void> _generateViaMasonBundle(GeneratorArguments arguments) async {
    final bundle = _bundleGenerator.generate(arguments);

    _logger.info('');
    final fileGenerationProgress = _logger.progress('Bootstrapping');
    final generator = await _generator(bundle);
    var generatedFiles = await generator.generate(
      DirectoryGeneratorTarget(arguments.outputDirectory),
      vars: {
        'project_name': arguments.projectName,
        'domain_name': arguments.organisationDomain,
        'organization_name': arguments.organisationName,
        'uses_firebase': arguments.usesFirebase,
        'analytics': arguments.analyticsEnabled,
        'push_notifications': arguments.pushNotificationsEnabled,
        'enable_feature_counter': arguments.counterEnabled,
        'enable_feature_deeplinks': arguments.deepLinkEnabled,
        'enable_feature_widget_toolkit': arguments.widgetToolkitEnabled,
        'enable_login': arguments.loginEnabled,
        'enable_social_logins': arguments.socialLoginsEnabled,
        'enable_change_language': arguments.changeLanguageEnabled,
        'enable_dev_menu': arguments.devMenuEnabled,
        'enable_feature_otp': arguments.otpEnabled,
        'enable_patrol': arguments.patrolTestsEnabled,
        'has_authentication': arguments.authenticationEnabled,
        'realtime_communication': arguments.realtimeCommunicationEnabled,
        'enable_pin_code': arguments.pinCodeEnabled,
      },
    );

    // Manually create gitignore.
    GitIgnoreCreator.generate(arguments.outputDirectory.path);

    final fileCount = generatedFiles.length + 1;

    fileGenerationProgress.complete('Bootstrapping done');

    await _writeOutputLog(fileCount, arguments);
  }

  Future<void> _postGen(Directory outputDirectory) async {
    var progress = _logger.progress('dart pub get');

    final dartGet = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: outputDirectory.path,
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
      workingDirectory: outputDirectory.path,
    );

    _progressFinish(buildRunner, progress);

    progress = _logger.progress(
      'dart format .',
    );

    final format = await Process.run(
      'dart',
      ['format', '.'],
      workingDirectory: outputDirectory.path,
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

  /// endregion

  /// region Output logging

  /// Writes an output log with the status of the file generation
  Future<void> _writeOutputLog(
      int fileCount, GeneratorArguments arguments) async {
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
  void _successMessageLog(int fileCount, GeneratorArguments arguments) {
    if (fileCount < 1) return;

    _delayedLog('Generated project with package name: '
        // ignore: lines_longer_than_80_chars
        '${lightCyan.wrap('${arguments.organisation}.${arguments.projectName}')}');

    _usingLog('Firebase Analytics', arguments.analyticsEnabled);
    _usingLog('Firebase Push Notifications', true);
    _usingLog('Feature Counter Showcase', arguments.counterEnabled);
    _usingLog('Feature Deep links Showcase', arguments.deepLinkEnabled);
    _usingLog(
      'Feature Widget Toolkit Showcase',
      arguments.widgetToolkitEnabled,
    );
    _usingLog('Feature Login', arguments.loginEnabled);
    _usingLog('Social Logins [Apple, Google, Facebook]',
        arguments.socialLoginsEnabled);
    _usingLog('Enable Change Language', arguments.changeLanguageEnabled);
    _usingLog('Dev Menu', arguments.devMenuEnabled);
    _usingLog('OTP Feature', arguments.otpEnabled);
    _usingLog('Patrol integration tests', arguments.patrolTestsEnabled);
    _usingLog('Realtime communication', arguments.realtimeCommunicationEnabled);
    _usingLog('Pin Code', arguments.pinCodeEnabled);
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
