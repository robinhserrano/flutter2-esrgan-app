import 'package:esrgan_flutter2_ocean_app/screens/gallery_screen.dart';
import 'package:esrgan_flutter2_ocean_app/widgets/CustomBottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/screens/enhance_screen.dart';
import '/screens/gallery_screen.dart';
import '/screens/profile_screen.dart';
import '/authentication/authentication.dart';
import '/widgets/scaler.dart';

class HomeScreen extends StatefulWidget {
    const HomeScreen({Key? key, required User user, required int screenIndex})
        : _user = user, _screenIndex = screenIndex,
        super(key: key);    

    final User _user;
    final int _screenIndex;

    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final filename = 'file.txt';
    final orgfilename = 'file.txt';
    late User _user;
    int _currentIndex = 0;
    
    
    
    PageController? _pageController;

    @override
    void initState() {
        _user = widget._user;
        createUserInFireStore();
        _pageController = PageController();
        super.initState();
    }
    @override
    void dispose() {
        _pageController!.dispose();
        super.dispose();
    }

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) {
        return buildAuthScreen();
    }

    Scaffold buildAuthScreen() {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
             controller: _pageController,

                     onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
        children: <Widget>[
            EnhanceScreen(user: _user,),
            Gallery(user: _user,),
        ],
       

        physics: NeverScrollableScrollPhysics(),
        ),

              bottomNavigationBar: CustomBottomNavigation(
                animationDuration: Duration(milliseconds: 350),
                selectedItemOverlayColor:
                    Colors.blue,
                backgroundColor: Color(0xFF2e445c),
                selectedIndex: _currentIndex,
                onItemSelected: (index) {
                  setState(() => _currentIndex = index);
                  _pageController!.jumpToPage(index);
                },
                items: <CustomBottomNavigationBarItem>[
                  CustomBottomNavigationBarItem(
                      title: "Enhance",
                      icon: Icon(Icons.warning, size: 22),
                      activeIcon: Icon(Icons.home, size: 22),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey),
                  CustomBottomNavigationBarItem(
                      title: "Gallery",
                      icon: Icon(Icons.home, size: 22),
                      activeIcon: Icon(Icons.photo_album, size: 22),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey),
                ],
              ),
    );
    }

    createUserInFireStore() async {
    DocumentSnapshot doc = await usersRef.doc(_user.uid).get();
    if (!doc.exists) {
        usersRef.doc(_user.uid).set({
        "id": _user.uid,
        "photoUrl": _user.photoURL,
        "email": _user.email,
        "displayName": _user.displayName,
        });
    }
    }
}