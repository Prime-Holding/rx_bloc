class ProfileService {
  //Add repository dependencies as needed
  ProfileService();

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Some specific async state from ProfileService';
  }
}