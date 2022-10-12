class RegisterCar {
  int? createdBy;
  bool? isEnabled;
  bool? isPublished;
  bool? isOffer;
  List<String>? features;
  int? price;
  String? contactPhoneNumber;
  String? name;
  String? description;
  String? registerDate;
  String? modificationDate;
  String? brand;
  String? model;
  String? year;
  String? vim;
  String? condition;

  RegisterCar(
      {this.createdBy,
      this.isEnabled,
      this.isPublished,
      this.isOffer,
      this.features,
      this.price,
      this.contactPhoneNumber,
      this.name,
      this.description,
      this.registerDate,
      this.modificationDate,
      this.brand,
      this.model,
      this.year,
      this.vim,
      this.condition});

  RegisterCar.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    isEnabled = json['isEnabled'];
    isPublished = json['isPublished'];
    isOffer = json['isOffer'];
    features = json['features'].cast<String>();
    price = json['price'];
    contactPhoneNumber = json['contactPhoneNumber'];
    name = json['name'];
    description = json['description'];
    registerDate = json['registerDate'];
    modificationDate = json['modificationDate'];
    brand = json['brand'];
    model = json['model'];
    year = json['year'];
    vim = json['vim'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['isEnabled'] = this.isEnabled;
    data['isPublished'] = this.isPublished;
    data['isOffer'] = this.isOffer;
    data['features'] = this.features;
    data['price'] = this.price;
    data['contactPhoneNumber'] = this.contactPhoneNumber;
    data['name'] = this.name;
    data['description'] = this.description;
    data['registerDate'] = this.registerDate;
    data['modificationDate'] = this.modificationDate;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['year'] = this.year;
    data['vim'] = this.vim;
    data['condition'] = this.condition;
    return data;
  }
}
