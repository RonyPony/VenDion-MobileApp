class Photo {
  int? id;
  String? name;
  String? image;
  int? vehicleId;
  String? createdAt;

  Photo({this.id, this.name, this.image, this.vehicleId, this.createdAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    vehicleId = json['vehicleId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['vehicleId'] = this.vehicleId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
