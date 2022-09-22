class FavoriteVehicle {
  int? id;
  int? vehicleId;
  int? userId;
  String? createdAt;

  FavoriteVehicle({this.id, this.vehicleId, this.userId, this.createdAt});

  FavoriteVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicleId'];
    userId = json['userId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleId'] = this.vehicleId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
