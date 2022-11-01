// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';

import '../../utils/helpers.dart';

/// Configures application tools and packages before running the app. Services
/// such as Firebase or background handlers can be defined here.
Future configureApp() async {
  // TODO: Add Firebase credentials for used environments
  // That is for development, staging and production for Android, iOS and Web
  await safeRun(() => Firebase.initializeApp());
}
