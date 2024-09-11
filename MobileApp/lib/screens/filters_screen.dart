import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/brands.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/widgets/brandModelSelector.dart';

import '../models/models.dart';
import '../models/serverResponse.dart';
import '../widgets/customPicker.dart';
import '../widgets/customRangeSelector.dart';
import '../widgets/textBox_widget.dart';

class FiltersScreen extends StatefulWidget {
  static String routeName = "/filtersScreen";

  @override
  State<FiltersScreen> createState() => _StateFilterScreen();
}

class _StateFilterScreen extends State<FiltersScreen> {
  int _conditions = 0;

  String PickerData = "ronel";

  List<String> _carBrandsName = ["Todas"];
  List<String> _carModelName = ["Todos"];
  var brands;
  int selectedbrandId = 0;
  String selectedBrandName = "";
  String selectedBrandModel = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brands = getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffff5b00),
        title: Text("Filtros de busqueda"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarConditions(),
            _buildBrandModelSelectors(context),
            _buildLocationField(),
            _buildPriceRange(),
            _buildApplyButton()
          ],
        ),
      ),
    );
  }

  _buildCarConditions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setCondition(0);
          },
          child: Container(
            width: 119,
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Todos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffff5b00),
                      fontSize: 20,
                      fontFamily: "Lato",
                      fontWeight: _conditions == 0
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: _conditions == 0 ? 3 : 0,
                  child: Material(
                    color: Color(0xffff5b00),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setCondition(1);
          },
          child: Container(
            width: 119,
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Nuevos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffff5b00),
                      fontSize: 20,
                      fontFamily: "Lato",
                      fontWeight: _conditions == 1
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: _conditions == 1 ? 3 : 0,
                  child: Material(
                    color: Color(0xffff5b00),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setCondition(2);
          },
          child: Container(
            width: 119,
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Usados",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffff5b00),
                      fontSize: 20,
                      fontFamily: "Lato",
                      fontWeight: _conditions == 2
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: _conditions == 2 ? 3 : 0,
                  child: Material(
                    color: Color(0xffff5b00),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setCondition(int i) {
    setState(() {
      _conditions = i;
    });
  }

  _buildBrandModelSelectors(BuildContext ct) {
    return FutureBuilder<List<Brand>>(
      future: brands,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: Color(0xffff5b00),
            backgroundColor: Colors.white,
          );
        }
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          snapshot.data!.forEach(
            (element) {
              _carBrandsName.add(element.name!);
            },
          );
          return BrandModelSelector(
              selectedBrand: selectedBrandName,
              selectedModel: selectedBrandModel,
              brands: _carBrandsName,
              models: _carModelName);
          // return Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomPicker(
          //       placeHolder: "Marca:",
          //       options: _carBrandsName,
          //       onChange: (int x) async {
          //         if (kDebugMode) {
          //           selectedbrandId = x;
          //           selectedBrandName = _carBrandsName[x];
          //           print("Selected ${_carBrandsName[x]}");
          //         }
          //       },
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8),
          //       child: GestureDetector(
          //         onTap: () async {
          //           // _carModelName
          //           if (selectedBrandName!="" && selectedBrandName != "Todas") {
          //             List<Model> x = await getModels(selectedBrandName);
          //             _carModelName.clear();
          //             for (Model modelo in x) {
          //               _carModelName.add(modelo.modelName!);
          //             }
          //             setState(() {});
          //           }
          //         },
          //         child: Container(
          //           padding: EdgeInsets.all(5),
          //           child: Icon(Icons.sync_alt,color: Colors.white,),
          //           decoration: BoxDecoration(
          //             color: Color(0xffff5b00),
          //             borderRadius: BorderRadius.circular(10)
          //           ),
          //         ),
          //       ),
          //     ),
          //     // SizedBox(
          //     //   width: 10,
          //     // ),
          //     CustomPicker(
          //       placeHolder: "Modelo:",
          //       options: _carModelName,
          //       onChange: (int x) async {
          //         if (kDebugMode) {
          //           selectedbrandId = x;

          //           // print("Selected ${brands[x]}");
          //         }
          //       },
          //     )
          //   ],
          // );
        }
        return Text("Error");
      },
    );
  }

  Future<List<Brand>> getBrands() async {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    List<Brand> response = await vehicleProvider.getBrands();
    _carBrandsName.clear();
    for (Brand brand in response) {
      _carBrandsName.add(brand.name!);
    }
    return response;
  }

  Future<List<Model>> getModels(String makeName) async {
    List<Model> models = [];
    try {
      var response = await Dio().get(
          'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/$makeName?format=json');
      print(response);
      for (Map<String, dynamic> data in response.data["Results"]) {
        print(data);
        Model newModel = Model.fromJson(data);
        models.add(newModel);
      }
      //  marcas = response.data["Results"].map((model) => Brand.fromJson(model)).toList();

      print(models);
      return models;
    } catch (e) {
      print(e);
      return models;
    }
    // _carBrandsName
  }

  _buildLocationField() {
    TextEditingController _controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: CustomTextBox(
        controller: _controller,
        onChange: () {},
        text: 'Ubicacion',
        svg: Icon(
          Icons.location_on_rounded,
          color: Color(0xffff5b00),
        ),
      ),
    );
  }

  _buildPriceRange() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        width: 324,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Price Range",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            CustomRangeSelect(
              min: 0,
              max: 60000,
              onChange: (RangeValues valores) {
                if (kDebugMode) {
                  print(valores);
                  // print("$minimunAgeToMatch - $maximunAgeToMatch");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: 174,
          child: Material(
            color: Color(0xffff5b00),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 15,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Apply Filters",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
