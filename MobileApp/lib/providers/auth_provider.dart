
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vendion/contracts/user_contract.dart';

import '../contracts/auth_contract.dart';
import '../models/change_password_request.dart';
import '../models/client_user.dart';
import '../models/new_password_request.dart';
import '../models/user_login_response.dart';
import '../models/user_response.dart';

class AuthenticationProvider with ChangeNotifier {
  AuthContract _authenticationService;
  UserContract _userService;
  bool isUserLoggedIn = false;
  UserResponse? loggedUser;
  int? userAge;
  String? nextRoute;

  AuthenticationProvider(this._authenticationService, this._userService);

  Future<bool> checkIfUserIsLoggingForTheFirstTime() async {
    final result = await _authenticationService.amountOfTimesUserHasLoggedIn();
    return result == 0;
  }

  Future<UserResponse> getCurrentUser() async {
    final res = await _authenticationService.getCurrentLoggedUser();
    loggedUser = res;
    return res;
  }

  Future<int> getUserAge(UserResponse user) async {
    final res = await _authenticationService.getUserAge(user);
    userAge = res;
    return res;
  }

  Future<UserResponse> authenticateUser(
      ClientUser user, bool rememberMe) async {

    UserResponse returnInfo = UserResponse();
    try {
      final UserLoginReponse res = await _authenticationService.logInUser(user, rememberMe);
      if (!res.hasError!) {
        // FlutterWoocommerce x = FlutterWoocommerce(
        //     url: serverurl, consumerKey: apikey, consumerSecret: secret);
        var userData =
            await _authenticationService.searchUserByEmail(res.email);
        // res.firstName = userData[0]["name"];
        // res.id = userData[0]["id"];
        // res.profilePictureUrl = userData[0]["avatar_urls"]["24"];
        // res.rememberLogin = rememberMe;
        returnInfo = UserResponse(
          email: userData.email,
          firstName: userData.name,
          isAuthenticated: true,
          rememberLogin: rememberMe,
        );
        loggedUser = returnInfo;
        isUserLoggedIn = true;
        notifyListeners();
        returnInfo.hasError=false;
        return returnInfo;
      } else {
        returnInfo =UserResponse(hasError: res.hasError,errorInfo: res.errorDetails);
        return returnInfo;
      }
    } catch (e) {
      loggedUser = null;
      isUserLoggedIn = false;
      returnInfo.hasError=true;
      returnInfo.errorInfo = e.toString();      
      notifyListeners();
      return returnInfo;
    }
  }

  bool skipLogin() {
    try {
      final res = UserResponse();
      loggedUser = res;
      isUserLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      loggedUser = null;
      isUserLoggedIn = false;
      notifyListeners();
      throw e;
    }
  }

  Future changePassword(
      NewPasswordRequest changePasswordRequest, int idUser) async {
    try {
      final res = await _authenticationService.changePassWord(
          changePasswordRequest, idUser);

      return res;
    } catch (e) {
      throw e;
    }
  }

  // Future<bool?> updateUserProfileImage(FormData data, UserResponse user) async {
  //   return await _userService.updateProfilePicture(data, user);
  // }

  Future signOutUser() async {
    await _authenticationService.signOutUser();
    isUserLoggedIn = false;
    nextRoute = null;
    notifyListeners();
  }

  Future<String?> register(ClientUser user) async {
    await validateUser(user);

    final registration = await _authenticationService.register(user);

    return registration;
  }

  Future validateUser(ClientUser user) async {
    if (user == null) {
      throw PlatformException(code: '400', message: "userCantBeNull");
    }

    final existsEmail = await _userService.existsEmail(user.email);
    if (existsEmail) {
      throw PlatformException(
          code: '400', message: "userWithEmailAlreadyExists");
    }

    final existsPhoneNumber =
        await _userService.existsPhoneNumber(user.phoneNumber);

    if (existsPhoneNumber) {
      throw PlatformException(
          code: '400', message: "userWithPhoneNumberAlreadyExists");
    }
  }

  Future resendConfirmationEmail(String? customerId) async {
    try {
      await _authenticationService.resendConfirmationEmail(customerId);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> hasUserAlreadyLoggedIn() async {
    try {
      return await _authenticationService.hasUserAlreadyLoggedIn();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> validateEmail(String? email) {
    return _userService.existsEmail(email);
  }

  Future<String?> sendVerificationCode(String? email) {
    return _userService.sendVerificationCode(email);
  }

 

  Future<bool> changeForgottenPassword(ChangePasswordRequest request) async {
    return await _userService.changeForgottenPassword(request);
  }

  Future<bool> updateUserInfo(UserResponse user) async {
    bool result = await _authenticationService.updateUserInfo(user);

    if (result) {
      final res = await _authenticationService.getCurrentLoggedUser();
      loggedUser = res;
      notifyListeners();
    }
    return result;
  }
}
