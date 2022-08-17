class ChangePasswordRequest {
  String? email;
  String? newPassword;
  String? confirmNewPassword;

  ChangePasswordRequest({
    this.email,
    this.newPassword,
    this.confirmNewPassword,
  });

  ChangePasswordRequest.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    newPassword = json['newPassword'];
    confirmNewPassword = json['confirmNewPassword'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['email'] = email;
    data['newPassword'] = newPassword;
    data['confirmNewPassword'] = confirmNewPassword;

    return data;
  }
}
