import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/register_car.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/vehicles_provider.dart';
import 'package:vendion/widgets/brandModelSelector.dart';

import '../models/brands.dart';
import '../models/models.dart';
import '../models/photoUpload.dart';
import '../providers/photo_provider.dart';
import '../widgets/customPicker.dart';
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
    "Airbags",
    "ABS",
    "Radar",
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
  TextEditingController contactNumber = TextEditingController();
  bool isTagSearching = false;

  List<String> filteredTags = [];

  List<String> selectedTags = [];
  List<String> _carBrandsName = ["Todas"];
  List<String> _carModelName = ["Todos"];
  var brands;
  int selectedbrandId = 0;
  String selectedBrandName = "";
  String selectedBrandModel = "";
  bool posting = false;
  List<PhotoToUpload> photoList = [];

  bool editMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBrands();
  }

  @override
  Widget build(BuildContext context) {
    var args;
    try {
       args = ModalRoute.of(context)!.settings.arguments! as int;

    } catch (e) {
      args=0;
    }
    final vehicleProvider =Provider.of<VehiclesProvider>(context, listen: false);
    Future<Vehicle> vehicleInfo = vehicleProvider.getVehicleInfo(args);
  editMode = args>0;
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
          child: editMode? FutureBuilder<Vehicle>(
        future: vehicleInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                LinearProgressIndicator(color: Colors.orange,backgroundColor: Colors.white,),
                Text("Sincronizando informacion del vehiculo")
              ],
            );
          }
          if (snapshot.hasError) {
            return Text("Error Loading info");
          }
          if (snapshot.connectionState == ConnectionState.done) {
              titleController.text = snapshot.data!.name!;
              selectedBrandName = snapshot.data!.brand!;
              yearController.text = snapshot.data!.year!;
              selectedTags = snapshot.data!.features!;
              // locationController.text = snapshot.data!.
            return Column(
              children: [
                _buildLabel("Titulo"),
                _splitter(.01),
                _buildTitle(),
                _splitter(.02),
                _buildLabel("Marca y Modelo"),
                _splitter(.01),
                _buildBrandModel(),
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
                _buildLabel("Numero de contacto"),
                _splitter(.01),
                _buildNumber(),
                _splitter(.02),
                _buildLabel("Descripcion"),
                _splitter(.01),
                _buildDesription(),
                _buildUploadPhotos(),
                _buildSellBtn(),
                _buildGoBackBtn()
              ],
            );
          }
          return Text("No info to load");
        },
      ): Column(
                  children: [
                    _buildLabel("Titulo"),
                    _splitter(.01),
                    _buildTitle(),
                    _splitter(.02),
                    _buildLabel("Marca y Modelo"),
                    _splitter(.01),
                    _buildBrandModel(),
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
                    _buildLabel("Numero de contacto"),
                    _splitter(.01),
                    _buildNumber(),
                    _splitter(.02),
                    _buildLabel("Descripcion"),
                    _splitter(.01),
                    _buildDesription(),
                    _buildUploadPhotos(),
                    _buildSellBtn(),
                    _buildGoBackBtn()
                  ],
                )
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
                      controller: locationController,
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
        GestureDetector(
          onTap: () async {
            selectNewPic();
          },
          child: Column(
            children: [
              photoList.length > 0
                  ? Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photoList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                photoList.removeAt(index);
                              });
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color(0xffff5b00))),
                                      child: Image.file(
                                          File(photoList[index].image!))),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Text("Click arriba para agregar fotos"),
              photoList.length == 0
                  ? Icon(
                      Icons.cloud_upload,
                      size: 85,
                      color: Color(0xffff5b00),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                          onTap: () {
                            if (photoList.length <= 9) {
                              selectNewPic();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Hey, solo puedes agregar 10 fotos por cada publicacion, puedes enviar fotos extra por chat."),
                              ));
                            }
                          },
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 70,
                            color: Color(0xffff5b00),
                          )),
                    )
            ],
          ),
        ),
      ],
    );
  }

  _buildGoBackBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
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
        onTap: () async {
          if (checkFieldsValidations()) {
            final vehicleProvider =
                Provider.of<VehiclesProvider>(context, listen: false);
            final authProvider =
                Provider.of<AuthenticationProvider>(context, listen: false);
            final photoProvider =
                Provider.of<PhotoProvider>(context, listen: false);
            UserResponse currentUser = await authProvider.getCurrentUser();
            RegisterCar vehicle = RegisterCar(
                brand: selectedBrandName,
                contactPhoneNumber: contactNumber.text,
                createdBy: currentUser.id,
                isOffer: false,
                model: selectedBrandModel,
                vim: "",
                modificationDate: DateTime.now().toString(),
                condition: isNew ? "Nuevo" : "Usado",
                description: descriptionController.text,
                features: selectedTags,
                isEnabled: true,
                name: titleController.text,
                price: int.parse(priceController.text),
                registerDate: DateTime.now().toString(),
                year: yearController.text,
                location: locationController.text,
                isPublished: true);
            setState(() {
              posting = true;
            });

            int productId = await vehicleProvider.sellVehicle(vehicle);
            int productPresentationPicId = 0;
            if (productId > 0) {
              for (PhotoToUpload photo in photoList) {
                photo.productId = productId;
                int picId = await photoProvider.uploadPhoto(photo);
                if (productPresentationPicId == 0) {
                  productPresentationPicId = picId;
                }
              }
bool setted = false;

              if(productPresentationPicId>0){
                setted = await photoProvider
                  .setProductMainPicture(productPresentationPicId);
              }else{
                setted=true;
              }

              if (setted) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 20),
                    backgroundColor: Colors.green,
                    content: Text("Vehiculo publicado correctamente"),
                  ));
                  posting = false;
                  Navigator.pop(context);
                });
              }
            } else {
              setState(() {
                posting = false;
              });
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 10),
                // backgroundColor: Color(0xffff5b00).withOpacity(.5),
                content: Text(
                    "Ups, no pudimos publicar este vehiculo, intenta mas tarde"),
              ));
              //TODO what to do if fails???
            }
          }
        },
        enable: !posting,
        loadingText: "Publicando...",
        text: "Vendelo",
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

  Future<List<Brand>> getBrands() async {
    final vehicleProvider =
        Provider.of<VehiclesProvider>(context, listen: false);
    List<Brand> response = await vehicleProvider.getBrands();
    _carBrandsName.clear();
    for (Brand brand in response) {
      _carBrandsName.add(brand.makeName!);
    }
    return response;
  }

  _buildBrandModel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomPicker(
              placeHolder: "Marca:",
              options: _carBrandsName,
              onChange: (int x) async {
                selectedbrandId = x;
                selectedBrandName = _carBrandsName[x];
                print("Selected ${_carBrandsName[x]}");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () async {
                // _carModelName
                final vehicleProvider =
                    Provider.of<VehiclesProvider>(context, listen: false);
                if (selectedBrandName != "" && selectedBrandName != "Todas") {
                  List<Model> x =
                      await vehicleProvider.getModels(selectedBrandName);
                  if (x.length > 0) {
                    _carModelName.clear();
                    for (Model modelo in x) {
                      _carModelName.add(modelo.modelName!);
                    }

                    if (_carModelName.length == 1) {
                      selectedBrandModel = _carBrandsName.first;
                    }
                  }
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.sync_alt,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffff5b00),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          // SizedBox(
          //   width: 10,
          // ),

          Expanded(
            child: CustomPicker(
              placeHolder: "Modelo:",
              options: _carModelName,
              onChange: (int x) async {
                selectedbrandId = x;
                selectedBrandModel = _carModelName[x];
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNumber() {
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
                        controller: contactNumber,
                        // cursorHeight: 30,
                        keyboardType: TextInputType.phone,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Agrega el numero",
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

  Future<void> selectNewPic() async {
    // final XFile? image =
    //     await _picker.pickImage(
    //         source: ImageSource.gallery);
    try {
      FocusScope.of(context).unfocus();
      final userProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      UserResponse currentUser = await userProvider.getCurrentUser();
      ImagePicker imagePicker = ImagePicker();
      final imageFile = await imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 25);
      // File imagen = File(imageFile!.path);
      // String fileExt = getFileExtension(imagen.path);
      // String fileRoute = getFileRoute(imagen.path);
      // File compressed =await
      //     photoProvider.compressImage(
      //         imagen, fileRoute+"2"+fileExt);
      PhotoToUpload photoToUpload = PhotoToUpload();
      photoToUpload.image = imageFile!.path;
      photoToUpload.productId = 0;
      setState(() {
        photoList.add(photoToUpload);
      });
      // bool uploaded = await photoProvider.uploadPhoto(photoToUpload);
      // if (uploaded) {
      //   CupertinoAlertDialog(
      //       title: Text("Completado"),
      //       content:
      //           Text("Se ha completado la carga de la imagen 📷"),
      //       actions: [
      //         CupertinoDialogAction(
      //           child: Text("OK"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         )
      //       ]);
      //   // CoolAlert.show(
      //   //     context: context,
      //   //     animType: CoolAlertAnimType
      //   //         .slideInDown,
      //   //     backgroundColor: Colors.white,
      //   //     loopAnimation: false,
      //   //     type: CoolAlertType.success,
      //   //     title: "Completado",
      //   //     text:
      //   //         "Se ha completado la carga de la imagen 📷");
      // }
      setState(() {});
    } catch (e) {
      CupertinoAlertDialog(
          title: Text("Ups!"),
          content: Text(e.toString()),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
      // CoolAlert.show(
      //     context: context,
      //     animType: CoolAlertAnimType.slideInDown,
      //     backgroundColor: Colors.white,
      //     loopAnimation: false,
      //     type: CoolAlertType.error,
      //     title: "Ups!",
      //     text: e.toString());
      setState(() {});
    } finally {
      setState(() {});
    }
  }

  bool checkFieldsValidations() {
    if (priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        // backgroundColor: Color(0xffff5b00).withOpacity(.5),
        content: Text("El precio que estableciste no es valido, corrigelo"),
      ));
      return false;
    }
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        // backgroundColor: Color(0xffff5b00).withOpacity(.5),
        content: Text("El titulo que estableciste no es valido, corrigelo"),
      ));
      return false;
    }

    if (selectedBrandName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        // backgroundColor: Color(0xffff5b00).withOpacity(.5),
        content: Text("Selecciona una marca valida"),
      ));
      return false;
    }

    if (selectedBrandModel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        // backgroundColor: Color(0xffff5b00).withOpacity(.5),
        content: Text("Selecciona un modelo valido"),
      ));
      return false;
    }

    if (yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        // backgroundColor: Color(0xffff5b00).withOpacity(.5),
        content: Text("El ano del vehiculo es necesario."),
      ));
      return false;
    }

    return true;
  }
}
