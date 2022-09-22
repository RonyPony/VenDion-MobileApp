import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:vendion/contracts/vehicles_contract.dart';
import 'package:vendion/models/favorites.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/models/vehicles.dart';

import '../helpers/network_util.dart';

class VehicleService implements VehiclesContract {
  final client = NetworkUtil.getClient();
  @override
  Future<List<Vehicle>> getAllVehicles(int userId) async {
    Response? response;
    List<Vehicle>? dataResponse;
    try {
      response = await client.get('api/vehicle');
      if (response.statusCode == 200) {
        dataResponse = List<Vehicle>.from(
            response.data.map((model) => Vehicle.fromJson(model)));
        // dataResponse.map((e) async => e.isFavorite = await isFavorite(e.id!, userId));
        // dataResponse.forEach((element)  {
        //   // bool isFav =await isFavorite(element.id!, userId);
        //   element.isFavorite=true;
        // });
        for (Vehicle vehi in dataResponse) {
          bool isFav =await isFavorite(vehi.id!, userId);
            vehi.isFavorite=isFav;
        }
        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }

  @override
  Future<VehiclePhoto> getVehiclePhoto(int id) async {
    Response? response;
    VehiclePhoto? dataResponse;
    try {
      response = await client.get('api/photos/byVehicle/' + id.toString());
      if (response.statusCode == 200) {
        dataResponse = VehiclePhoto.fromJson(response.data);

        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }

  //response = await client.get<List>('api/photos/gallery/'+id.toString());
  @override
  Future<List<VehiclePhoto>> getVehicleGallery(int id) async {
    Response? response;
    List<VehiclePhoto>? dataResponse;
    try {
      response = await client.get('api/photos/gallery/' + id.toString());
      if (response.statusCode == 200) {
        dataResponse = List<VehiclePhoto>.from(
            response.data.map((model) => VehiclePhoto.fromJson(model)));

        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }

  @override
  Future<List<Vehicle>> getAllOfferVehicles() async {
    Response? response;
    List<Vehicle>? dataResponse;
    try {
      response = await client.get('api/vehicle/offer');
      if (response.statusCode == 200) {
        dataResponse = List<Vehicle>.from(
            response.data.map((model) => Vehicle.fromJson(model)));

        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }

  @override
  Future<bool> addToFavorites(int carId, int userId) async {
    Response? response;
    bool dataResponse;
    try {
      response = await client.post('api/vehicle/addFavorite/' +
          carId.toString() +
          "/" +
          userId.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 404) {
          return false;
        } else {
          return false;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> isFavorite(int carId, int userId) async {
    Response? response;
    bool dataResponse;
    try {
      response =
          await client.get('api/vehicle/getFavorites/' + userId.toString());
      if (response.statusCode == 200) {
        List list = response.data;
        bool responseValue = false;
        list.forEach((element) {
          if (element["vehicleId"] == carId) {
            responseValue = true;
          }
        });
        return responseValue;
      } else {
        if (response.statusCode == 404) {
          return false;
        } else {
          return false;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  
  @override
  Future<bool> removeFromFavorites(int carId, int userId) async {
    Response? response;
    bool dataResponse;
    try {
      response = await client.post('api/vehicle/removeFavorite/' +
          carId.toString() +
          "/" +
          userId.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 404) {
          return false;
        } else {
          return false;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<FavoriteVehicle>> getAllFavoriteVehicles(int userId) async {
    Response? response;
    List<FavoriteVehicle>? dataResponse;
    try {
      response = await client.get('api/vehicle/getFavorites/'+userId.toString());
      if (response.statusCode == 200) {
        dataResponse = List<FavoriteVehicle>.from(
            response.data.map((model) => FavoriteVehicle.fromJson(model)));
        
        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }
  
  @override
  Future<Vehicle> getVehicleInfo(int vehicleId) async {
    Response? response;
    Vehicle? dataResponse;
    try {
      response = await client.get('api/vehicle/'+vehicleId.toString());
      if (response.statusCode == 200) {
        dataResponse = Vehicle.fromJson(response.data);
       
        return dataResponse;
      } else {
        if (response.statusCode == 404) {
          return dataResponse!;
        } else {
          return dataResponse!;
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return dataResponse!;
      } else {
        return dataResponse!;
      }
    } catch (e) {
      print(e);
      return dataResponse!;
    }
  }
}
