class DashboardService {
  //Add repository dependencies as needed
  DashboardService();

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Some specific async state from DashboardService';
  }
}
