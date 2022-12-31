class UserToRegister {
  String? name;
  String? lastName;
  String? email;
  String? password;
  String? phone;

  UserToRegister(
      {this.name, this.lastName, this.email, this.password, this.phone});

  UserToRegister.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    return data;
  }
}
