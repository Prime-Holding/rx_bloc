class FullService {
  final MyType2 myName2;
  final MyType1 myName;

  FullService(
    this.myName2, {
    this.myName,
  });

  void _callMeIThereYou() {
    print('$myName should not be called from external place');
  }

  void callMeSafely() {
    print('$myName2 should not be called from external place');
  }
}
