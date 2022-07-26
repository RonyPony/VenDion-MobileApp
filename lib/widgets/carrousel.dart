import 'package:flutter/material.dart';

class Carrousel extends StatelessWidget {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          _buildCarrousell(),
          
        
        ],
      ),
    );
  }

  _buildAphoto(bool isSpetial, String descri) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        child: Stack(
          children: [
            Container(
                child: Image.asset(
              "assets/Tesla.png",
            )),
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: descri.length>44?SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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
              ): Row(
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
  
  
  
  _buildCarrousell() {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAphoto(true, "Tesla model x la para de paras grasa only grasa"),
          _buildAphoto(false, "Excelente vehiculo"),
          _buildAphoto(true, "Nuevesito"),
        ],
      ),
    );
  }
}
