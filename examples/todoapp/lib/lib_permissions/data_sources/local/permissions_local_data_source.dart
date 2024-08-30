import 'dart:convert';

import '../../../app_extensions.dart';
import '../../../base/data_sources/local/shared_preferences_instance.dart';

class PermissionsLocalDataSource {
  final SharedPreferencesInstance sharedPreferences;

  PermissionsLocalDataSource({required this.sharedPreferences});

  Future<bool> savePermissions(Map<String, bool> permissions) async {
    return await sharedPreferences.setString(
      permissionsKey,
      json.encode(permissions),
    );
  }

  Future<Map<String, bool>> getPermissions() async {
    final jsonString = await sharedPreferences.getString(permissionsKey);
    if (jsonString != null) {
      final Map<String, dynamic> decodedMap = json.decode(jsonString);
      // make map of string, bool
      final Map<String, bool> permissions =
          decodedMap.map((key, value) => MapEntry(key, value as bool));

      return permissions;
    } else {
      return {};
    }
  }
}
