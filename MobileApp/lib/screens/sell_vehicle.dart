import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/register_car.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/vehicles_provider.dart';

import '../widgets/drawer.dart';
import '../widgets/main_button_widget.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';

class SellScreen extends StatefulWidget {
  static String routeName = "/sellScreen";

  @override
  State<SellScreen> createState() => _buildState();
}

class _buildState extends State<SellScreen> {
  int? _condition = 0;
  List<String> tags = [
    "Alarm",
    "Bluetooth",
    "Cruise Control",
    "Front Parking Sensor",
    "Digital Dashboard",
    "Leather seats",
  ];

  TextEditingController titleController = TextEditingController();
  bool isNew = true;
  TextEditingController yearController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController featuresController = TextEditingController();

  bool isTagSearching = false;

  List<String> filteredTags = [];

  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: GeneralDrawer(),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * .1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NotificationsScreen.routeName);
                },
                child: SvgPicture.asset("assets/notification-active.svg")),
          )
        ],
        title: const Text(
          "VenDion",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffff5b00),
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLabel("Titulo"),
            _splitter(.01),
            _buildTitle(),
            _splitter(.02),
            _buildConditionAndYear(),
            _splitter(.02),
            _buildLabel("Features"),
            _buildSelectedTags(),
            _splitter(.01),
            _buildSearch(),
            _buildTags(),
            _splitter(.01),
            _buildLocationAndPrice(),
            _splitter(.02),
            _buildLabel("Descripcion"),
            _splitter(.01),
            _buildDesription(),
            _buildUploadPhotos(),
            _buildSellBtn(),
            _buildGoBackBtn()
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: titleController,
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Agrega el titulo",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                  // Text(
                  //   "Enter title",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildLabel(String s) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 28),
      child: Row(
        children: [
          Text(
            s,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _buildConditionAndYear() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              _buildLabel("Condicion"),
              _buildCondition(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [_buildLabel("Año"), _buildYearField()],
          ),
        )
      ],
    );
  }

  _splitter(double base) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * base,
    );
  }

  _buildCondition() {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Radio(
              value: 1,
              activeColor: Color(0xffff5b00),
              groupValue: _condition,
              onChanged: (int? value) {
                _condition = value;
                isNew = true;
                print(_condition);
                setState(() {});
              },
            ),
            Text("Nuevo"),
            SizedBox(
              width: 0,
            ),
            Radio(
              value: 0,
              activeColor: Color(0xffff5b00),
              groupValue: _condition,
              onChanged: (int? value) {
                _condition = value;
                isNew = false;
                print(_condition);
                setState(() {});
              },
            ),
            Text("Usado"),
          ],
        ));
  }

  _buildYearField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      keyboardType: TextInputType.number,
                      controller: yearController,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "Agrega el Año",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                  // Text(
                  //   "Enter year",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: featuresController,
                        autofillHints: tags,
                        autocorrect: true,
                        onChanged: (val) {
                          isTagSearching = true;
                          filteredTags = tags
                              .where((element) => element
                                  .toLowerCase()
                                  .contains(val.toLowerCase()))
                              .toList();
                          print(tags.where((element) => element
                              .toLowerCase()
                              .contains(val.toLowerCase())));
                          setState(() {});
                        },
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Buscar",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                  // Text(
                  //   "Enter title",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildTags() {
    if (isTagSearching && filteredTags.length <= 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            

            if (!selectedTags.contains(featuresController.text)) {
              selectedTags.add(featuresController.text);
              featuresController.text = "";
              isTagSearching = false;
              setState(() {});
            }else{
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                        title: Text("Ya fue seleccionado"),
                        content: Text(
                            "Este Feature ya esta agregado, selecciona otro"),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Entendido"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]);
                  },
                  barrierDismissible: true);
            }
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Color(0xffff5b00),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "Agregar " + featuresController.text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: !isTagSearching
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!selectedTags.contains(tags[index])) {
                      selectedTags.add(tags[index]);
                      print(tags[index]);
                      setState(() {});
                    } else {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                                title: Text("Ya fue seleccionado"),
                                content: Text(
                                    "Este Feature ya esta agregado, selecciona otro"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Entendido"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]);
                          },
                          barrierDismissible: true);
                    }
                  },
                  child: Chip(
                    label: Text(tags[index]),
                    backgroundColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        tags.remove(tags[index]);
                      });
                    },
                    avatar: Icon(
                      Icons.local_offer,
                      color: Color(0xffff5b00),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredTags.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!selectedTags.contains(filteredTags[index])) {
                      selectedTags.add(filteredTags[index]);
                      print(filteredTags[index]);
                      setState(() {});
                    }else{
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                                title: Text("Ya fue seleccionado"),
                                content: Text(
                                    "Este Feature ya esta agregado, selecciona otro"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Entendido"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]);
                          },
                          barrierDismissible: true);
                    }
                  },
                  child: Chip(
                    label: Text(filteredTags[index]),
                    backgroundColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        tags.remove(filteredTags[index]);
                      });
                    },
                    avatar: Icon(
                      Icons.local_offer,
                      color: Color(0xffff5b00),
                    ),
                  ),
                );
              },
            ),
    );
    // return Column(
    //   children: [
    //     Column(
    //       children: [
    //         Row(
    //           children: [
    //             _aTag("Alarm"),
    //              _aTag("Cruise Control")
    //              ],
    //         ),
    //         Row()
    //       ],
    //     ),
    //     Column(
    //       children: [
    //         Row(
    //           children: [
    //             _aTag("Bluetooth"),
    //             _aTag("Front parkinf sensor"),
    //           ],
    //         ),
    //         Row()
    //       ],
    //     )
    //   ],
    // );
  }

  _aTag(String s) {
    bool selected = true;

    return Chip(
        backgroundColor: Colors.white,
        onDeleted: () {
          print("rrr");
        },
        avatar: Icon(
          Icons.local_offer,
          color: Color(0xffff5b00),
        ),
        // Container(
        //   height: 15,
        //   width: 15,

        //   decoration: BoxDecoration(
        //       color: !selected?Colors.white:Color(0xffff5b00),
        //       borderRadius: BorderRadius.circular(2),
        //       border: Border.all(width: 2)),
        // ),
        label: Text(s));
  }

  _buildLocationAndPrice() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              _buildLabel("Ubicacion"),
              _buildLocationField(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [_buildLabel("Precio"), _buildPriceField()],
          ),
        )
      ],
    );
  }

  _buildLocationField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "Locacion",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                  // Text(
                  //   "Enter year",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildPriceField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "US:800",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildDesription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          
                          hintText:
                              "Agrega la descripcion del vehiculo, incluye detalles generales y condiciones especificas del estado actual del vehiculo.",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildUploadPhotos() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Text(
                "Upload images/Video",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Icon(
          Icons.cloud_upload,
          size: 85,
          color: Color(0xffff5b00),
        ),
      ],
    );
  }

  _buildGoBackBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomBtn(
        mainBtn: false,
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
        enable: true,
        text: "Regresar",
      ),
    );
  }

  _buildSellBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomBtn(
        mainBtn: true,
        onTap: () {
          final vehicleProvider =
              Provider.of<VehiclesProvider>(context, listen: false);
          RegisterCar vehicle = RegisterCar(
            brand: "",
            contactPhoneNumber: "",
            createdBy: 0,
            isOffer: false,
            model: "",
            vim: "",
            modificationDate: DateTime.now().toString(),
            condition: isNew?"Nuevo":"Usado",
            description: descriptionController.text,
            features: selectedTags,
            isEnabled: true,
            name: titleController.text,
            price: int.parse(priceController.text),
            registerDate: DateTime.now().toString(),
            year: yearController.text,
            isPublished: true
          );
          var response = vehicleProvider.sellVehicle(vehicle);
        },
        enable: true,
        text: "Vendelo !!",
      ),
    );
  }

  Widget _buildSelectedTags() {
    if (selectedTags.length >= 1) {
      return Container(
        padding: EdgeInsets.only(left: 10),
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedTags.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                selectedTags.remove(selectedTags[index]);
                setState(() {});
              },
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffff5b00),
                      ),
                      child: Text(
                        selectedTags[index],
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
