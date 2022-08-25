import 'package:flutter/material.dart';
import 'package:vendion/contracts/vehicles_contract.dart';
import 'package:vendion/models/vehicle_photo.dart';

import '../models/vehicles.dart';

class VehiclesProvider with ChangeNotifier {
  VehiclesContract _vehiclesContract;
  VehiclesProvider(this._vehiclesContract);

  Future<List<Vehicle>> getAllAvailableVehicles() async {
    final result = await _vehiclesContract.getAllVehicles();
    return result;
  }

  Future<VehiclePhoto> getVechiclePhoto(int id) async {
    final result = await _vehiclesContract.getVehiclePhoto(id);
    return result;
  }
}