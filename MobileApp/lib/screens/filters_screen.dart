import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:vendion/models/brands.dart';

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
  late Future<List<Brands>> brands;
  int selectedbrandId = 0;
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
    return FutureBuilder<List<Brands>>(
      future: brands,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Color(0xffff5b00),);
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPicker(
                placeHolder: "Marca:",
                options: _carBrandsName,
                onChange: (int x) async {
                  if (kDebugMode) {
                    selectedbrandId = x;
                    //print("Selected ${brands[x]}");
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              CustomPicker(
                placeHolder: "Modelo:",
                options: _carModelName,
                onChange: (int x) async {
                  if (kDebugMode) {
                    selectedbrandId = x;

                    // print("Selected ${brands[x]}");
                  }
                },
              )
            ],
          );
        }
        return Text("Error");
      },
    );
  }

  Future<List<Brands>> getBrands() async {
    List<Brands> marcas = [];
    try {
      var response = await Dio().get(
          'https://private-anon-d54d1424fc-carsapi1.apiary-mock.com/manufacturers');
      print(response);
      var list = response.data;
      marcas = list
          .map<Brands>((brand) => Brands(
              name: brand["name"],
              avgHorsepower: brand["avg_horsepower"],
              avgPrice: brand["avg_price"],
              imgUrl: brand["img_url"],
              maxCarId: brand["max_car_id"],
              numModels: brand["num_models"]))
          .toList();
      print(marcas);
      return marcas;
    } catch (e) {
      print(e);
      return marcas;
    }
    // _carBrandsName
  }

  _buildLocationField() {
    TextEditingController _controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: CustomTextBox(
        controller: _controller,
        onChange: (){

        },
        text: 'Ubicacion',
        svg: Icon(Icons.location_on_rounded,color: Color(0xffff5b00) ,),
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
          children:[
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
        onTap: (){

        },
        child: SizedBox(
      width: 174,
      child: Material(
          color: Color(0xffff5b00),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 15, ),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
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
