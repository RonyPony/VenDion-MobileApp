class Model {
  int? makeID;
  int? modelID;
  String? modelName;

  Model({this.makeID, this.modelID, this.modelName});

  Model.fromJson(Map<String, dynamic> json) {
    makeID = json['brandId'];
    modelID = json['id'];
    modelName = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.makeID;
    data['id'] = this.modelID;
    data['name'] = this.modelName;
    return data;
  }
}
