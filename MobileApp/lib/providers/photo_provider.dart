
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/photo.dart';
import '../models/photoUpload.dart';
import '../services/photo_service.dart';

class PhotoProvider with ChangeNotifier {
  final PhotoService _service;
  PhotoProvider(this._service);

  Future<Photo> getVehiclePicture(int vehicleId) async {
    var response = await _service.getVehiclePicture(vehicleId);
    return response;
  }

  Future<List<Photo>> getAllPhotos() async {
    var response = await _service.getAllPhotos();
    return response;
  }

  Future<Photo> getPhoto(int photoId) async {
    var response = await _service.getPhoto(photoId);
    return response;
  }

  Future<bool> deletePhoto(int photoId) async {
    var response = await _service.deletePhoto(photoId);
    return response;
  }

  Future<List<Photo>> getPhotosofAnUser(int userId) async {
    var response = await _service.getPhotosofAnUser(userId);
    return response;
  }

  Future<int> uploadPhoto(PhotoToUpload photo) async {
    var response = await _service.uploadPhoto(photo);
    return response;
  }
  Future<bool> setProductMainPicture(int photoId) async {
    final response = await _service.setProductMainPicture(photoId);
    return response;
  }

  Future<File> compressImage(File image, String targetPath) async {
    var response = await _service.compressImage(image, targetPath);
    return response;
  }
}
