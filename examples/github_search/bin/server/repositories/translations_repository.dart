// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

class TranslationsRepository {
  Map<String, dynamic> getTranslations() => _demoTranslations;

  final Map<String, dynamic> _demoTranslations = jsonDecode('''
    {
       "en":{
          "_ok":"Okay",
          "login___logIn" : "Login via email"
       },
       "bg":{
          "_ok":"ok",
          "login___logIn" : "Вход с имейл"
       }
    }
    ''');
}
