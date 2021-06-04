// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
{{#uses_firebase}}
import 'package:firebase_core/firebase_core.dart';{{/uses_firebase}}

import '../utils/helpers.dart';

Future configureApp() async {
  {{#uses_firebase}}
  // TODO: Add Firebase credentials for used environments
  // That is for development, staging and production for Android, iOS and web
  await safeRun(() => Firebase.initializeApp());{{/uses_firebase}}

  // TODO: Add your own code that is going to be run before the actual app
}

