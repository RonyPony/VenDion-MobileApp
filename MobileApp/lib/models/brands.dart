class Brand {
  int? makeID;
  String? makeName;

  Brand({this.makeID, this.makeName});

  Brand.fromJson(Map<String, dynamic> json) {
    makeID = json['Make_ID'];
    makeName = json['Make_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Make_ID'] = this.makeID;
    data['Make_Name'] = this.makeName;
    return data;
  }
}
