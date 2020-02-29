abstract class BaseModel {
  final String id;

  BaseModel(this.id);
  String toJsonString();
  Map<String, dynamic> toJsonMap();
}
