class ClientUser {
  String? password;
  String? confirmPassword;
  String? name;
  String? lastName;
  String? email;
  String? phone;
  String? birthDate;
  String? countryName;
  String? city;
  String? address1;
  String? zipPostalCode;
  double? longitude;
  double? latitude;

  ClientUser({
    this.email,
    this.password,
    this.confirmPassword,
    this.name,
    this.lastName,
    this.countryName,
    this.city,
    this.address1,
    this.zipPostalCode,
    this.phone,
    this.longitude,
    this.latitude,
    this.birthDate,
  });

  ClientUser.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    name = json['name'];
    lastName = json['lastName'];
    countryName = json['countryName'];
    city = json['city'];
    address1 = json['address1'];
    zipPostalCode = json['zipPostalCode'];
    phone = json['phone'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    birthDate = json['dateOfBirth'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['name'] = name;
    data['lastName'] = lastName;
    data['countryName'] = countryName;
    data['city'] = city;
    data['address1'] = address1;
    data['zipPostalCode'] = zipPostalCode;
    data['phone'] = phone;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['dateOfBirth'] = birthDate;

    return data;
  }
}
