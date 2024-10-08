import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import '../integration_test/main/base/test_constants.dart';

Future<int> main(List<String> arguments) async {
  final runner = CommandRunner<int>(
      'run_integration_tests', 'Integration test helper tool')
    ..addCommand(ExecuteCommand());

  final exitCode = await runner.run(arguments).catchError((error) {
    if (error is UsageException) {
      runner.printUsage();
      exit(64); // Exit code 64 indicates a usage error.
    }
    throw error;
  });

  return exitCode ?? -1;
}

class ExecuteCommand extends Command<int> {
  @override
  String get description => 'Run the integration tests';

  @override
  String get name => 'execute';

  @override
  FutureOr<int>? run() async {
    final testSets = {
      'all': 'all',
      'regression tests': regressionTest,
      'negative tests': negativeTest,
      'positive tests': positiveTest
    };

    final environments = ['development', 'sit', 'uat', 'production'];
    final languages = ['bg', 'en'];

    stdout.write('Fetching device list...');
    final devices = await _getDeviceList();
    stdout.writeln('done.');

    final testSetIndex = _prompt('Select a test set:',
        options: testSets.keys, defaultOptionIndex: 0);

    final environmentIndex = _prompt('Select an environment:',
        options: environments, defaultOptionIndex: 1);

    final languageIndex = _prompt('Select a language:',
        options: languages, defaultOptionIndex: 0);

    final deviceIndex = _prompt('Select a device:', options: devices);
    final selectedDevice = devices[deviceIndex];

    final arguments = _buildCommandArguments(
      flavor: environments[environmentIndex].toLowerCase(),
      language: languages[languageIndex],
      device: selectedDevice.substring(
          selectedDevice.lastIndexOf('(') + 1, selectedDevice.lastIndexOf(')')),
      tags: testSets.values.elementAt(testSetIndex),
    );

    final process = await Process.start('dart', arguments);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);
    return await process.exitCode;
  }

  int _prompt(String prompt,
      {required Iterable<String> options, int? defaultOptionIndex}) {
    assert(defaultOptionIndex == null ||
        (defaultOptionIndex >= 0 && defaultOptionIndex < options.length));

    print(prompt);

    do {
      options.forEachIndexed((index, value) {
        bool isDefault = index == defaultOptionIndex;
        print('\t(${index + 1}) $value${isDefault ? ' (default)' : ''}');
      });

      final input = stdin.readLineSync();

      if (input?.trim() == '' && defaultOptionIndex != null) {
        return defaultOptionIndex;
      }

      final selectedIndex = int.tryParse(input ?? '');

      if (selectedIndex != null) {
        if (selectedIndex > 0 && selectedIndex <= options.length) {
          // Adjust to zero-based indexing.
          return selectedIndex - 1;
        }
      }
    } while (true);
  }

  Future<List<String>> _getDeviceList() async {
    final result = Process.runSync(
      'dart',
      ['pub', 'global', 'run', 'patrol_cli:main', 'devices'],
    );

    if (result.exitCode == 0) {
      return LineSplitter.split(result.stdout as String)
          .map((device) => device.trim())
          .where((line) => line.isNotEmpty)
          .where((line) => line.contains('(') && line.contains(')'))
          .toList();
    }

    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  List<String> _buildCommandArguments({
    required String flavor,
    required String language,
    required String device,
    required String tags,
  }) {
    final arguments = <String>[
      'pub',
      'global',
      'run',
      'patrol_cli:main',
      'test',
      '--no-uninstall',
      '--no-label',
      '--flavor=$flavor',
      '--dart-define=flavor="$flavor"',
      '--dart-define=language="$language"',
      '--device=$device',
      '--debug',
    ];

    if (tags == 'all') {
      // Patrol runs all tests if the --target option is omitted.
      return arguments;
    }

    arguments.add('--tags=$tags');

    return arguments;
  }
}
