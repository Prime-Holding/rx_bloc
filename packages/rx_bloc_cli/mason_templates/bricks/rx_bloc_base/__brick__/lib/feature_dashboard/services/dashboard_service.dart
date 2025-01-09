class DashboardService {
  //Add repository dependencies as needed
  DashboardService();

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Your dashboard provides a quick overview of key information and features, helping you stay organized and access essential tools at a glance.';
  }
}
