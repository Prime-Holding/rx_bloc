class RoseService {
  //Add repository dependencies as needed
  RoseService();

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Some specific async state from RoseService';
  }
}
