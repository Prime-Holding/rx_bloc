import 'package:shelf/shelf.dart';

import '../services/country_codes_service.dart';
import '../utils/api_controller.dart';

class CountryCodesController extends ApiController {
  CountryCodesController(this._countryCodesService);

  final CountryCodesService _countryCodesService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/country-codes',
      _countryCodesHandler,
    );
  }

  Future<Response> _countryCodesHandler(Request request) async {
    final countryCodes = await _countryCodesService.getAllCountryCodes();
    return responseBuilder.buildOK(data: {
      'countryCodes': countryCodes,
    });
  }
}
