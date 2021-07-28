class PushNotificationToken {
  PushNotificationToken(this.token);

  final String token;

  Map<String, Object?> toJson() => {
    'pushToken': token,
  };
}
