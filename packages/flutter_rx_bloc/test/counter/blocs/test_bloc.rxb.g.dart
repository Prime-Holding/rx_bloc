// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'test_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class TestBlocType extends RxBlocTypeBase {
  TestBlocEvents get events;
  TestBlocStates get states;
}

/// [$Test] extended by the [TestBloc]
/// {@nodoc}
abstract class $TestBloc extends RxBlocBase
    implements TestBlocEvents, TestBlocStates, TestBlocType {
  final _compositeSubscription = CompositeSubscription();

  @override
  TestBlocEvents get events => this;

  @override
  TestBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
