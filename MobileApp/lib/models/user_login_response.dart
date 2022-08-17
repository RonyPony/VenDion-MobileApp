
  
class UserLoginReponse {
  int? id;
  int? countryId;
  bool? isEnabled;
  bool? showNumber;
  String? phoneNumber;
  String? bornDate;
  bool? deletedAccount;
  String? name;
  String? lastName;
  String? bio;
  String? email;
  String? password;
  String? registerDate;
  String? lastLogin;
  bool? hasError;
  String? errorDetails;

  UserLoginReponse(
      {this.id,
      this.countryId,
      this.isEnabled,
      this.showNumber,
      this.phoneNumber,
      this.bornDate,
      this.deletedAccount,
      this.name,
      this.lastName,
      this.bio,
      this.email,
      this.password,
      this.registerDate,
      this.hasError,
      this.errorDetails,
      this.lastLogin});

  UserLoginReponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    isEnabled = json['isEnabled'];
    showNumber = json['showNumber'];
    phoneNumber = json['phoneNumber'];
    bornDate = json['bornDate'];
    deletedAccount = json['deletedAccount'];
    name = json['name'];
    lastName = json['lastName'];
    bio = json['bio'];
    email = json['email'];
    password = json['password'];
    registerDate = json['registerDate'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['isEnabled'] = this.isEnabled;
    data['showNumber'] = this.showNumber;
    data['phoneNumber'] = this.phoneNumber;
    data['bornDate'] = this.bornDate;
    data['deletedAccount'] = this.deletedAccount;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['bio'] = this.bio;
    data['email'] = this.email;
    data['password'] = this.password;
    data['registerDate'] = this.registerDate;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
