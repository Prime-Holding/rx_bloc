import '../services/firebase_service.dart';

class FirebaseLogoutUseCase {
  FirebaseLogoutUseCase(FirebaseService service) : _service = service;

  final FirebaseService _service;

  Future<bool> execute() async {
    await _service.logOut();
    return true;
  }
}
