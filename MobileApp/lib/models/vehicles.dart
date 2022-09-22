class Vehicle {
  int? id;
  int? createdBy;
  bool? isEnabled;
  bool? isPublished;
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
  bool? isFavorite;

  Vehicle(
      {this.id,
      this.createdBy,
      this.isEnabled,
      this.isPublished,
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
      this.isFavorite,
      this.vim,
      this.condition});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    isEnabled = json['isEnabled'];
    isPublished = json['isPublished'];
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
    data['id'] = this.id;
    data['createdBy'] = this.createdBy;
    data['isEnabled'] = this.isEnabled;
    data['isPublished'] = this.isPublished;
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
