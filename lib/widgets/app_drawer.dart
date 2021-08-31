import 'package:esrgan_flutter2_ocean_app/authentication/authentication.dart';
import 'package:esrgan_flutter2_ocean_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppDawer extends StatelessWidget {
  const CustomAppDawer({ Key? key,  required User user }) : 
      _user = user;

  final User _user;

  
      Route _routeToSignInScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
            position: animation.drive(tween),
            child: child,
        );
        },
    );
    }


  @override
  Widget build(BuildContext context) {
    return Drawer(
            child: Container(
                color: Color(0xFF1f2430),
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        SafeArea(child: Container(
                            margin: EdgeInsets.symmetric(vertical: 36),
                            child: Column(
                                children: [
                                    ClipOval(
                                        child: Material(
                                        color: Colors
                                            .blue, //CustomColors.firebaseGrey.withOpacity(0.3),
                                        child: Image.network(
                                            _user.photoURL!,
                                            fit: BoxFit.fitHeight,
                                            ),
                                        ),
                                    ),
                                    SizedBox(height: 8),
                                    
                                    Text(
                                        _user.displayName!,
                                        style: TextStyle(
                                            color: Colors.white, //CustomColors.firebaseYellow,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                            ),
                                        ),
  SizedBox(height: 4),
                                              Text(
                                        _user.email!,
                                        style: TextStyle(
                                            color: Colors.grey[300], //CustomColors.firebaseYellow,
                                            fontSize: 16,
                                            ),
                                        ),
                                    ],
                                )
                            ),
                        ),
                        Divider(color: Colors.grey),
                        Expanded(child: Container(
                            child: Column(
                                //mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                                                        Container(
      child: new Material(
        child: new InkWell(
          onTap: (){print("tapped");},
          child: new Container(
              
            child: ListTile(
                leading: Icon(
                    Icons.book,
                    color: Colors.white,
                ),
                title: Text("Help", style: TextStyle(color: Colors.white),),
                onTap: () {
                },
            ),
          ),
        ),
        color: Colors.transparent,
      ),
//   color: Color(0xFF1f2430),
    ),
                                        Container(
      child: new Material(
        child: new InkWell(
          onTap: (){print("tapped");},
          child: new Container(
              
            child: ListTile(
                leading: Icon(
                    Icons.bike_scooter,
                    color: Colors.white,
                ),
                title: Text("About", style: TextStyle(color: Colors.white),),
                onTap: () {
                },
            ),
          ),
        ),
        color: Colors.transparent,
      ),
//   color: Color(0xFF1f2430),
    ),
  

  Container(
      child: Material(
        child: InkWell(

          child: Container(
            child: ListTile(
                leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                ),
                title: Text("Log out", style: TextStyle(color: Colors.white),),
                onTap: () async{
                                await Authentication.signOut(context: context);
            Navigator.of(context)
                .pushReplacement(_routeToSignInScreen());
                },
            ),
          ),
        ),
        color: Colors.transparent,
      ),),
                    

//   color: Color(0xFF1f2430),

                                        

                                     
                                
                                ])
                        ))
                    ],
                ),
            )
        );
  }
}

