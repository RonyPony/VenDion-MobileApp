import 'package:vendion/models/serverResponse.dart';

import '../models/client_user.dart';
import '../models/new_password_request.dart';
import '../models/user_response.dart';

abstract class AuthContract{
  Future<int> amountOfTimesUserHasLoggedIn();

  Future<UserResponse> getCurrentLoggedUser();

  Future<dynamic> logInUser(ClientUser user, bool remember);

  Future<dynamic> searchUserByEmail(String? email);
  Future changePassWord(NewPasswordRequest changePasswordRequest, int idUser);

  Future<ServerResponse> register(ClientUser user);

  Future signOutUser();

  Future<int> getUserAge(UserResponse user);

  Future resendConfirmationEmail(String? customerId);

  Future<bool> hasUserAlreadyLoggedIn();

  Future<bool> updateUserInfo(UserResponse user);

  void saveTempUser(ClientUser user);

  Future<ClientUser> getTempUser();
}