import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

void main() {
  group('test realtime_communication_type enum', () {
    test('should return name when toString is invoked', () {
      expect(
        RealtimeCommunicationType.values.every(
          (e) => e.toString() == e.name,
        ),
        isTrue,
      );
    });

    test('should only parse supported options', () {
      expect(RealtimeCommunicationType.supportedOptions.length, equals(2));

      expect(RealtimeCommunicationType.parse('none'),
          equals(RealtimeCommunicationType.none));
      expect(RealtimeCommunicationType.parse('sse'),
          equals(RealtimeCommunicationType.sse));

      expect(() => RealtimeCommunicationType.parse('grpc'),
          throwsUnsupportedError);
      expect(() => RealtimeCommunicationType.parse('value'),
          throwsUnsupportedError);
    });
  });
}
