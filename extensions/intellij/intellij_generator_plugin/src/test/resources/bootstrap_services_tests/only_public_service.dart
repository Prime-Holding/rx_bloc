class OnlyPublicService {
  final MyType2 myName2;
  final MyType1 myName;

  OnlyPublicService({
     this.myName2,
     this.myName,
  });

  void callMeSafely() {
    print('$myName should not be called from external place');
  }

  void callMeSafely2() {
    print('$myName2 should not be called from external place');
  }
}
