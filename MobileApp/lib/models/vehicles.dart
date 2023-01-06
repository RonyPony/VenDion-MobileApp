class Vehicle {
  int? id;
  int? createdBy;
  bool? isEnabled;
  bool? isPublished;
  String? features;
  int? price;
  String? contactPhoneNumber;
  String? name;
  bool? isOffer;
  String? description;
  String? registerDate;
  String? modificationDate;
  String? brand;
  String? model;
  String? year;
  String? vim;
  String? condition;
  bool? isFavorite;
  String? location;

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
      this.isOffer,
      this.modificationDate,
      this.brand,
      this.model,
      this.year,
      this.isFavorite,
      this.vim,
      this.location,
      this.condition});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    isEnabled = json['isEnabled'];
    isPublished = json['isPublished'];
    features = json['features'];//.cast<String>();
    price = json['price'];
    contactPhoneNumber = json['contactPhoneNumber'];
    name = json['name'];
    description = json['description'];
    registerDate = json['registerDate'];
    isOffer =json['isOffer'];
    modificationDate = json['modificationDate'];
    brand = json['brand'];
    model = json['model'];
    year = json['year'];
    vim = json['vim'];
    location=json['location'];
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
    data['isOffer'] = this.isOffer;
    data['model'] = this.model;
    data['year'] = this.year;
    data['vim'] = this.vim;
    data['location']=this.location;
    data['condition'] = this.condition;
    return data;
  }
}
