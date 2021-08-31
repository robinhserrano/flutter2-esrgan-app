import 'package:flutter/material.dart';


PreferredSizeWidget customAppBar = PreferredSize(
    child: AppBar(
        automaticallyImplyLeading: false,
        leading: 
             Container(
                 margin: EdgeInsets.only(left: 5),
                 padding: EdgeInsets.all(2),
                 child:
                    Image.asset(
                    "assets/images/esrganFlutterLogo.png",
                    fit: BoxFit.cover,
                    height: 75
                )
             ),

        // title: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //         Icon(Icons.menu, size: 38,),
        //     ]),
        //backgroundColor: Colors.blue[600],
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                        Color(0xFF2F455C),
                        Color(0xFF2F455C)
                        // Color(0xFF1f2430),
                        //  Color(0xFF1f2430),
                        //Color(0xFF21D0B2),
                       // Color(0xFF1DCDFE),
                        // Color(0xFF21D0B2),
                        // Color(0xFF34F5C5),
                        // Color(0xFF1DCDFE)
                    ])          
                )
            )      
        ), 
    preferredSize: Size.fromHeight(60.0)
    );

    