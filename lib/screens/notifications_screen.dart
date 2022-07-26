import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  static String routeName = "/NotificationsScreen";

  @override
  State<NotificationsScreen> createState() => _StateNotificationsScreen();
}

class _StateNotificationsScreen extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:100,
        elevation: 0,
        backgroundColor: Color(0xffff5b00),
        title: Text("Notifications"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEmpty(),
            // _buildAnoti(),
            // _buildAnoti(),
          ],
        ),
      ),
    );
  }

  _buildAnoti() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        
        child: Stack(children: [
          
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffff5b00).withOpacity(.6)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: Icon(
                      Icons.circle_notifications_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuevo Vehiculo en Venta",
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                      Text("Honda Civic 2007 ha sido publicado en ...",
                          style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 320, top: 0),
            child: CircleAvatar(
              child: Icon(Icons.close_rounded,color: Colors.red,),
              backgroundColor: Colors.amberAccent.withOpacity(1),
            ),
          ),
        ]),
      ),
    );
  }
  
  _buildEmpty() {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,size: 200,color: Colors.black.withOpacity(.2),),            
            ],
          ),
        ),
        Text("Todavia no has recibido ninguna notificacion",style: TextStyle(color: Colors.black.withOpacity(.2),fontSize: 15,fontWeight: FontWeight.w900),),
      ],
    );
  }
}
