export 'connectivity_repository_stub.dart'
    if (dart.library.js) 'connectivity_repository_web.dart'
    if (dart.library.io) 'connectivity_repository_native.dart';
