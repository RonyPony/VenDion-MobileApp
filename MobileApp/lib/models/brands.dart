class Brands {
  int? numModels;
  String? imgUrl;
  int? maxCarId;
  int? id;
  String? name;
  double? avgHorsepower;
  double? avgPrice;

  Brands(
      {this.numModels,
      this.imgUrl,
      this.maxCarId,
      this.id,
      this.name,
      this.avgHorsepower,
      this.avgPrice});

  Brands.fromJson(Map<String, dynamic> json) {
    numModels = json['num_models'];
    imgUrl = json['img_url'];
    maxCarId = json['max_car_id'];
    id = json['id'];
    name = json['name'];
    avgHorsepower = json['avg_horsepower'];
    avgPrice = json['avg_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_models'] = this.numModels;
    data['img_url'] = this.imgUrl;
    data['max_car_id'] = this.maxCarId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['avg_horsepower'] = this.avgHorsepower;
    data['avg_price'] = this.avgPrice;
    return data;
  }
}
