
// import 'package:intl/intl.dart';
// import 'package:blackfox/pages/activity_feed.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
//     as mdi;
// import '../models/user.dart';

// import '../pages/home.dart';




import 'package:esrgan_flutter2_ocean_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:esrgan_flutter2_ocean_app/widgets/scaler.dart';

//import '../widgets/progress.dart';
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');



class Post extends StatefulWidget {
  final String imageId;
  final String mediaUrl;
  final String ownerId;
  final Timestamp timestamp;
  final String userId;
  
  Post(
      {
           required this.imageId,
  required this.mediaUrl,
  required this.ownerId,
   required this.timestamp,
  required  this.userId
  
     });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      imageId: doc['imageId'],
      mediaUrl: doc['mediaUrl'],
      ownerId: doc['ownerId'],
      timestamp: doc['timestamp'],
      userId: doc['userId'],
    );
  }


  @override
  _PostState createState() => _PostState(
        ownerId: this.ownerId,
        timestamp: this.timestamp,
         imageId: this.imageId,
        userId:  this.userId,
        mediaUrl: this.mediaUrl,
      );
}

class _PostState extends State<Post> {
final String imageId;
  final String mediaUrl;
  final String ownerId;
  final Timestamp timestamp;
  final String userId;

  _PostState(
      {
   required this.imageId,
  required this.mediaUrl,
  required this.ownerId,
   required this.timestamp,
  required  this.userId
      });

    User? user = FirebaseAuth.instance.currentUser;

    


  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  
  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width:
                410.0, ////////////////////////////////////////////////////////////////////////
            height: 400.0,
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Colors.black38, Colors.black38],
            // )),

            child: Image.network(
              mediaUrl,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

    handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Do want to delete the photo?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    await deletePost();
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(user: user!, screenIndex: 0)));
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    // delete post itself
    postsRef
        .doc(widget.userId)
        .collection('userPosts')
        .doc(widget.imageId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    storageRef.child("post_$imageId.jpg").delete();
  }

  handleSaveImageToGallery(BuildContext parentContext){
       showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Export Image'),
          content: const Text('Do you want to export this image to your device?'),
          actions: <Widget>[
            TextButton(
              onPressed: () =>  Navigator.of(context).pop(),//Navigator.pop(context, 'Cancel'),
              
              child: const Text('No', style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: (){
                   //Navigator.of(context).push(Loadig)
                   

                   
                  //uploadImage(context);
                  //Navigator.pop(context, uploadImage(context));
              },
              child: const Text('Yes'),
            ),
          ],
        ));
  }

 Widget btnSaveImageToGallery(){
    return Container(
        margin: EdgeInsets.only(top: 12),
        child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF31a8ff))),
                onPressed: ()=>
                    handleSaveImageToGallery(context)            
                ,//getImage,
                icon: FaIcon(FontAwesomeIcons.fileExport, color: Colors.white),
                label: Text("Export Image",
                    style: TextStyle(
                      color: Colors.white,
                        ))));
 }
 
  Widget btnDeleteImage(){
    return Container(
        margin: EdgeInsets.only(top: 12),
        child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFFcc0000))),
                onPressed: ()=>
                    handleDeletePost(context),//getImage,
                icon: FaIcon(FontAwesomeIcons.trashAlt, color: Colors.white),
                label: Text("Delete Image",
                    style: TextStyle(
                      color: Colors.white,
                        ))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(
          color: Colors.grey[600],
        ),
        buildPostImage(),
        Divider(
          color: Colors.grey[600],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                
                Container(child: 
                Column(
                    children: [
                                    
        btnSaveImageToGallery(),
        btnDeleteImage(),
                    ],
                ),)
        ],)
        
      ],
    );
  }
}
