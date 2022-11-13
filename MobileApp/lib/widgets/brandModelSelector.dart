import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/models.dart';
import 'customPicker.dart';

class BrandModelSelector extends StatefulWidget {
  const BrandModelSelector({super.key, required this.brands, required this.models, required this.selectedBrand, required this.selectedModel});
  final List<String>brands;
  final List<String>models;
  final String selectedBrand;
  final String selectedModel;
  @override
  State<BrandModelSelector> createState() => _BrandModelSelectorState();
}

class _BrandModelSelectorState extends State<BrandModelSelector> {
  int selectedbrandId = 0;
  
  String selectedBrandName="";

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: CustomPicker(
                  placeHolder: "Marca:",
                  options: widget.brands,
                  onChange: (int x) async {
                    if (kDebugMode) {
                      selectedbrandId = x;
                      selectedBrandName = widget.brands[x];
                      print("Selected ${widget.brands[x]}");
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () async {
                    // _carModelName
                    if (selectedBrandName!="" && selectedBrandName != "Todas") {
                      List<Model> x = await getModels(selectedBrandName);
                      widget.models.clear();
                      for (Model modelo in x) {
                        widget.models.add(modelo.modelName!);
                      }
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.sync_alt,color: Colors.white,),
                    decoration: BoxDecoration(
                      color: Color(0xffff5b00),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Container(
                width: 150,
                child: CustomPicker(
                  placeHolder: "Modelo:",
                  options: widget.models,
                  onChange: (int x) async {
                    if (kDebugMode) {
                      selectedbrandId = x;

                      // print("Selected ${brands[x]}");
                    }
                  },
                ),
              )
            ],
          );
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
}