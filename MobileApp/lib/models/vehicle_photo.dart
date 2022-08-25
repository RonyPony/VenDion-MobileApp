class VehiclePhoto {
  int? id;
  String? name;
  String? image;
  bool? isProductPicture;
  int? productId;
  String? createdAt;

  VehiclePhoto(
      {this.id,
      this.name,
      this.image,
      this.isProductPicture,
      this.productId,
      this.createdAt});

  VehiclePhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isProductPicture = json['isProductPicture'];
    productId = json['productId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['isProductPicture'] = this.isProductPicture;
    data['productId'] = this.productId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
