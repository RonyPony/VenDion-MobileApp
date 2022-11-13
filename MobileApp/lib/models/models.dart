class Model {
  int? makeID;
  String? makeName;
  int? modelID;
  String? modelName;

  Model({this.makeID, this.makeName, this.modelID, this.modelName});

  Model.fromJson(Map<String, dynamic> json) {
    makeID = json['Make_ID'];
    makeName = json['Make_Name'];
    modelID = json['Model_ID'];
    modelName = json['Model_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Make_ID'] = this.makeID;
    data['Make_Name'] = this.makeName;
    data['Model_ID'] = this.modelID;
    data['Model_Name'] = this.modelName;
    return data;
  }
}
