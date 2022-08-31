import 'package:vendion/models/vehicle_photo.dart';

import '../models/vehicles.dart';

abstract class VehiclesContract {
  Future<List<Vehicle>> getAllVehicles();
  Future<List<Vehicle>> getAllOfferVehicles();
  Future<VehiclePhoto> getVehiclePhoto(int id);
  Future<List<VehiclePhoto>>getVehicleGallery(int id);
}