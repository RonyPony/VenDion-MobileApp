import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vendion/contracts/vehicles_contract.dart';
import 'package:vendion/models/vehicles.dart';

import '../helpers/network_util.dart';

class VehicleService implements VehiclesContract {
  final client = NetworkUtil.getClient();
  @override
  Future<List<Vehicle>> getAllVehicles() async {
   Response? response;
   List<Vehicle>? dataResponse;
    try {
      response = await client.get('api/vehicle');
      if (response.statusCode==200) {
        dataResponse = List<Vehicle>.from(response.data.map((model) => Vehicle.fromJson(model)));
        
        return dataResponse!;
      }else{
        if (response.statusCode==404) {
          return dataResponse!;
        }else{
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if(e.response!.statusCode==400){
        return dataResponse!;
      }else{
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }
  
}