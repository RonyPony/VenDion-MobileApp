import 'package:vendion/models/vehicle_photo.dart';

import '../models/vehicles.dart';

abstract class VehiclesContract {
  Future<List<Vehicle>> getAllVehicles();
  Future<VehiclePhoto> getVehiclePhoto(int id);
}