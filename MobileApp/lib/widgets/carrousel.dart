import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/vehicle_photo.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/providers/vehicles_provider.dart';

class Carrousel extends StatelessWidget {
  ScrollController controller = ScrollController();
  List<Vehicle> list = [];

  Carrousel(List<Vehicle> info) {
    list = info;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          _buildCarrousell(context),
        ],
      ),
    );
  }

  _buildAphoto(bool isSpetial, String descri, Image photo) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        child: Stack(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(20), child: photo),
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: descri.length > 44
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            descri,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            descri,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
            ),
            isSpetial
                ? Padding(
                    padding: const EdgeInsets.only(top: 25, right: 0),
                    child: Transform.rotate(
                      angle: -0.80,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffff5b00),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Oferta",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            isSpetial
                ? Transform.rotate(
                    angle: -0.80,
                    child: const Icon(
                      Icons.star_rate_rounded,
                      size: 35,
                      color: Color(0xffff5b00),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  _buildCarrousell(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.height * .3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final photoProvider =
                  Provider.of<VehiclesProvider>(context, listen: false);
              Future<VehiclePhoto> vehiclePhoto =
                  photoProvider.getVechiclePhoto(list[index].id!);
              return FutureBuilder<VehiclePhoto>(
                future: vehiclePhoto,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: CircularProgressIndicator(
                        color: Color(0xffff5b00),
                      ),
                    ));
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return _buildAphoto(true, list[index].description!,
                        Image.memory(base64Decode(snapshot.data!.image!)));
                  }

                  return Text(
                      "Ups, something happened trying to get the offers");
                },
              );
            },
          ),
        ),
        // _buildAphoto(true, "Tesla model x la para de paras grasa only grasa"),
        // _buildAphoto(false, "Excelente vehiculo"),
        // _buildAphoto(true, "Nuevesito"),
      ],
    );
  }
}
