import 'package:project_name/base/models/count.dart';

abstract class CountDataSource{
  Future<Count> getCurrent();
  Future<Count> increment();
  Future<Count> decrement();
}