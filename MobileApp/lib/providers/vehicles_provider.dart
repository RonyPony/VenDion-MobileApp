import 'package:flutter/material.dart';
import 'package:vendion/contracts/vehicles_contract.dart';

import '../models/vehicles.dart';

class VehiclesProvider with ChangeNotifier {
  VehiclesContract _vehiclesContract;
  VehiclesProvider(this._vehiclesContract);

  Future<List<Vehicle>> getAllAvailableVehicles() async {
    final result = await _vehiclesContract.getAllVehicles();
    return result;
  }
}