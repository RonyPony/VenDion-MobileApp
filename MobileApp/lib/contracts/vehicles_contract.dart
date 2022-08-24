import '../models/vehicles.dart';

abstract class VehiclesContract {
  Future<List<Vehicle>> getAllVehicles();
}