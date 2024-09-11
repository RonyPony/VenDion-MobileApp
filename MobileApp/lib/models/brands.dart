class Brand {
  int? id;
  String? name;
  String? logoUrl;
  bool? isEnabled;

  Brand({this.id, this.name, this.isEnabled, this.logoUrl});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isEnabled = json['isEnabled'];
    logoUrl = json['logoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isEnabled'] = this.isEnabled;
    data['logoUrl'] = this.logoUrl;
    return data;
  }
}
