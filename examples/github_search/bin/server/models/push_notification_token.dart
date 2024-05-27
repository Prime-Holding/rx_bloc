// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

class PushNotificationToken {
  PushNotificationToken(this.token);

  final String token;

  Map<String, Object?> toJson() => {
        'pushToken': token,
      };
}
