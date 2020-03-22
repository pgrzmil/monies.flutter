abstract class BaseModel {
  final String id;
  final String userId;

  BaseModel(this.id, this.userId);
  String toJsonString();
  Map<String, dynamic> toJsonMap();
}
