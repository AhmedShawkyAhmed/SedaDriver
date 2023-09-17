class RegisterImageModel {
  int? id;
  String? filename;
  String? filetype;
  String? type;
  int? createById;
  String? createByType;
  int? createdAt;
  String? createdAtStr;

  RegisterImageModel(
      {this.id,
      this.filename,
      this.filetype,
      this.type,
      this.createById,
      this.createByType,
      this.createdAt,
      this.createdAtStr});

  RegisterImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    filetype = json['filetype'];
    type = json['type'];
    createById = json['createBy_id'];
    createByType = json['createBy_type'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
  }

  static List<RegisterImageModel> fromJsonList(List<dynamic> json) {
    final result = <RegisterImageModel>[];
    for (int i = 0; i < json.length; i++) {
      result.add(RegisterImageModel.fromJson(json[i]));
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['filetype'] = filetype;
    data['type'] = type;
    data['createBy_id'] = createById;
    data['createBy_type'] = createByType;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    return data;
  }
}
