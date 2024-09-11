import 'package:vendion/models/favorites.dart';
import 'package:vendion/models/models.dart';
import 'package:vendion/models/register_car.dart';
import 'package:vendion/models/serverResponse.dart';
import 'package:vendion/models/vehicle_photo.dart';

import '../models/brands.dart';
import '../models/vehicles.dart';

abstract class VehiclesContract {
  Future<List<Vehicle>> getAllVehicles(int userId);
  Future<Vehicle> getVehicleInfo(int vehicleId);
  Future<List<FavoriteVehicle>> getAllFavoriteVehicles(int userId);
  Future<List<Vehicle>> getAllOfferVehicles();
  Future<VehiclePhoto> getVehiclePhoto(int id);
  Future<List<VehiclePhoto>> getVehicleGallery(int id);
  Future<bool> isFavorite(int carId, int userId);
  Future<bool> addToFavorites(int carId, int userId);
  Future<bool> removeFromFavorites(int carId, int userId);
  Future<int> sellVehicle(RegisterCar vehicle);
  Future<List<Brand>> getBrands();
  Future<List<Model>> getModels(int brandName);
  Future<List<Vehicle>> getVehiclesByUser(int userId);
}
