abstract class JsonSerializable {
  JsonSerializable.fromJson(Map<String, dynamic> json);
  Map<String, Object?> toJson();
}
