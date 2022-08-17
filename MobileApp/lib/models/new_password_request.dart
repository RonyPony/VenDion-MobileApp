class NewPasswordRequest {
  String? oldPassword;
  String? newPassword;
  String? confirmNewPassword;

  NewPasswordRequest(
      {this.oldPassword, this.newPassword, this.confirmNewPassword});

  NewPasswordRequest.fromJson(Map<String?, dynamic> json) {
    oldPassword = json['oldPassword'] ?? "";
    newPassword = json['newPassword'] ?? "";
    confirmNewPassword = json['confirmNewPassword'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['confirmNewPassword'] = this.confirmNewPassword;

    return data;
  }
}
