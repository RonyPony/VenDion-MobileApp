import 'package:flutter/material.dart';
import 'package:vendion/contracts/vehicles_contract.dart';
import 'package:vendion/models/favorites.dart';
import 'package:vendion/models/register_car.dart';
import 'package:vendion/models/vehicle_photo.dart';

import '../models/brands.dart';
import '../models/models.dart';
import '../models/vehicles.dart';

class VehiclesProvider with ChangeNotifier {
  VehiclesContract _vehiclesContract;
  VehiclesProvider(this._vehiclesContract);

  Future<List<Vehicle>> getAllAvailableVehicles(int userId) async {
    final result = await _vehiclesContract.getAllVehicles(userId);
    return result;
  }

  Future<List<Vehicle>> getVehiclesByUser(int userId) async {
    final result = await _vehiclesContract.getVehiclesByUser(userId);
    return result;
  }

  Future<Vehicle> getVehicleInfo(int vehicleId) async {
    final result = await _vehiclesContract.getVehicleInfo(vehicleId);
    return result;
  }

  Future<List<FavoriteVehicle>> getAllFavoriteVehicles(int userId) async {
    final result = await _vehiclesContract.getAllFavoriteVehicles(userId);
    return result;
  }

  Future<List<Vehicle>> getAllOfferVehicle() async {
    final result = await _vehiclesContract.getAllOfferVehicles();
    return result;
  }

  Future<VehiclePhoto> getVechiclePhoto(int id) async {
    final result = await _vehiclesContract.getVehiclePhoto(id);
    return result;
  }

  Future<List<VehiclePhoto>> getVechicleGallery(int id) async {
    final result = await _vehiclesContract.getVehicleGallery(id);
    return result;
  }

  Future<bool> addToFavorite(int carId,int userId) async {
    final result = await _vehiclesContract.addToFavorites(carId,userId);
    return result;
  }

  Future<bool> removeFromFavorite(int carId, int userId) async {
    final result = await _vehiclesContract.removeFromFavorites(carId, userId);
    return result;
  }

  Future<bool> isFavorite(int carId, int userId) async {
    final result = await _vehiclesContract.isFavorite(carId, userId);
    return result;
  }

  Future<int> sellVehicle(RegisterCar vehicle) async {
    final response = await _vehiclesContract.sellVehicle(vehicle);
    return response;
  }
  Future<List<Brand>> getBrands() async {
    final response  = await _vehiclesContract.getBrands();
    return response;
  }

  Future<List<Model>> getModels(String brandName) async {
    final response = await _vehiclesContract.getModels(brandName);
    return response;
  }
}
