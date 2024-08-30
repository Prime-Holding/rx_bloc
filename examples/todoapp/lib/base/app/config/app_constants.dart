// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: lines_longer_than_80_chars

// Here lie all your app constants

/// Vapid Key is required in order to for FCM to run on web properly
/// https://github.com/FirebaseExtended/flutterfire/blob/4c9b5d28de9eeb5ce76c856fbd0c7b3ec8615e45/docs/messaging/usage.mdx#web-tokens
library;

export 'is_in_test_mode_io_not_available.dart'
    if (dart.library.io) 'is_in_test_mode_io_available.dart'
    if (dart.library.html) 'is_in_test_mode_io_not_available.dart';

const String webVapidKey = '';
const String translationsKey = 'translations';
const String permissionsKey = 'permissions';
const String queryAllTodos = 'getAllTodos';
