class PhotoToUpload {
  String? image;
  int? productId;
  PhotoToUpload({this.image, this.productId});

  PhotoToUpload.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['productId'] = this.productId;
    return data;
  }
}
