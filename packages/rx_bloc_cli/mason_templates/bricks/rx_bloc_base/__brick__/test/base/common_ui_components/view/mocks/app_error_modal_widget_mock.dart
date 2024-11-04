import 'package:mockito/annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'app_error_modal_widget_mock.mocks.dart';

@GenerateMocks([RxBlocTypeBase])
RxBlocTypeBase appErrorModalWidgetMockFactory() {
  final blocMock = MockRxBlocTypeBase();

  return blocMock;
}
