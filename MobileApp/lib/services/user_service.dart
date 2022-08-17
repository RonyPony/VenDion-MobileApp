
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:vendion/contracts/user_contract.dart';

import '../helpers/network_util.dart';
import '../models/change_password_request.dart';
import '../models/user_response.dart';


class UserService implements UserContract {
  @override
  Future<bool> existsEmail(String? email) async {
    final client = NetworkUtil.getClient();

    final response = await client.get('customers/search?query=email:$email');

    // final users = new UsersResponse.fromJsonList(response.data['customers']);

    // if (response.statusCode! < 400) {
    //   return users.items.length > 0;
    // }

    throw PlatformException(
        code: "${response.statusCode}", message: "existsEmailError");
  }

  @override
  Future<bool> existsPhoneNumber(String? phoneNumber) async {
    final client = NetworkUtil.getClient();

    final response = await client
        .get('contact-confirmation/$phoneNumber/check-phone-duplicated');

    if (response.statusCode! < 400) {
      return response.data['IsDuplicated'];
    }

    throw PlatformException(
        code: "${response.statusCode}", message: "existsPhoneNumber");
  }

  Future<bool> updateUserProfileImage(
      FormData data, UserResponse user) async {
    String? errorMessage = '';
    try {
      final client = NetworkUtil.getTokenClient();

      final response =
          await client.patch('clients/${user.id}/avatar', data: data);
      if (response.statusCode! < 400) {
        return true;
      }

      errorMessage = _getErrorMessage(response.data);

      throw PlatformException(
          code: "${response.statusCode}",
          message: "ErrorChangingProfilePicture");
    } catch (e) {
      errorMessage = errorMessage!.isEmpty ? e.toString() : errorMessage;
      throw Exception(errorMessage);
    }
  }

  
  String? _getErrorMessage(Map<String?, dynamic> jsonModel) {
    if (jsonModel['Message'] != null) {
      return jsonModel['Message'];
    } else if (jsonModel['message'] != null) {
      return jsonModel['message'];
    } else {
      // ignore: unused_local_variable
      var title = jsonModel['title'];
      // ignore: unused_local_variable
      var status = jsonModel['status'];
      Map errors = jsonModel['errors'];

      var messages = errors.values
          .where((element) => element.toString().isNotEmpty)
          .toList();
      var result = messages[0].elementAt(0);
      return result;
    }
  }

  @override
  Future<String?> sendVerificationCode(String? email) async {
    try {
      final client = NetworkUtil.getClient();

      final response = await client.post('clients/verification-code',
          data: json.encode(email));
      if (response.statusCode! < 400) {
        return response.data.toString();
      }
      throw PlatformException(
          code: "${response.statusCode}", message: "invalidEmail");
    } catch (e) {
      throw Exception('errorDuringSendingVerificationCode');
    }
  }

  @override
  Future<bool> changeForgottenPassword(ChangePasswordRequest request) async {
    try {
      final client = NetworkUtil.getClient();
      final data = request.toJson();
      final response =
          await client.post('clients/change-forgotten-password', data: data);
      if (response.statusCode! < 400) {
        return true;
      }
      throw PlatformException(
          code: "${response.statusCode}", message: "invalidNewPassword");
    } catch (e) {
      throw Exception('errorDuringChangingPassword');
    }
  }
  
  
  

}
