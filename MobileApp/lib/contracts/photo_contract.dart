import 'dart:io';

import '../models/photo.dart';
import '../models/photoUpload.dart';

abstract class PhotoContract {
  Future<Photo> getUserProfilePicture(int userId);
  Future<List<Photo>> getAllPhotos();
  Future<Photo> getPhoto(int photoId);
  Future<bool> deletePhoto(int photoId);
  Future<List<Photo>> getPhotosofAnUser(int userId);
  Future<bool> uploadPhoto(PhotoToUpload photo);
  Future<File> compressImage(File image, String targetPath);
}