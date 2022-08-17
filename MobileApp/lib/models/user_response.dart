class UserResponse {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? birthDate;
  int? id;
  int? vendorId;
  String? profilePictureUrl;
  bool? rememberLogin;
  bool? isAuthenticated;
  bool? hasError;
  String? errorInfo;

  UserResponse(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.birthDate,
      this.vendorId,
      this.rememberLogin,
      this.isAuthenticated,
      this.hasError,
      this.errorInfo,
      this.profilePictureUrl});

  UserResponse.fromJson(Map<String?, dynamic> json) {
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    email = json['email'];
    vendorId = json['vendorId'];
    phone = json['phone'];
    birthDate = json['birthday'];
    id = json['customerId'];
    rememberLogin = json['rememberLogin'];
    profilePictureUrl = json['pictureUrl'];
    isAuthenticated = json['isAuthenticated'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['birthday'] = this.birthDate;
    data['customerId'] = this.id;
    data['pictureUrl'] = this.profilePictureUrl;
    data['vendorId'] = this.vendorId;
    data['rememberLogin'] = this.rememberLogin;
    data['isAuthenticated'] = this.isAuthenticated;
    return data;
  }
}
