
import '../models/change_password_request.dart';
import '../models/user_response.dart';

abstract class UserContract {
  Future<bool> existsEmail(String? email);

  Future<bool> existsPhoneNumber(String? phoneNumber);
  Future<String?> sendVerificationCode(String? email);
  // Future<bool?>updateProfilePicture(FormData data, UserResponse user);
  Future<bool> changeForgottenPassword(ChangePasswordRequest request);
}