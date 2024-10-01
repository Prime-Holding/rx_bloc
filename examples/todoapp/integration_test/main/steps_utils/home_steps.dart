import '../configuration/build_app.dart';
import '../pages/home_page.dart';

class HomeSteps {
  static Future<void> navigateToStatisticsPage(
      PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);
    await homePage.tapBtnStatistics();
  }

  static Future<void> navigateToTodoListPage(PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);
    await homePage.tapBtnTodoList();
  }
}
