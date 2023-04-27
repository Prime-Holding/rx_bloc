class OnlyPrivateRepository {
  final MyType2 myName2;
  final MyType1 myName;

  OnlyPrivateRepository(this.myName2, this.myName);

  void _callMeIThereYou() {
    print('$myName should not be called from external place');
  }

  void _callMeIThereYou2() {
    print('$myName2 should not be called from external place');
  }
}
