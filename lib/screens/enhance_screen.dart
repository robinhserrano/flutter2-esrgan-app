import 'dart:io';
import 'package:esrgan_flutter2_ocean_app/authentication/authentication.dart';
import 'package:esrgan_flutter2_ocean_app/screens/image_view.dart';
import 'package:esrgan_flutter2_ocean_app/screens/loading_enhance_screen.dart';
import 'package:esrgan_flutter2_ocean_app/screens/login_screen.dart';
import 'package:esrgan_flutter2_ocean_app/widgets/app_drawer.dart';
import 'package:esrgan_flutter2_ocean_app/widgets/appbar_title.dart';
import 'package:esrgan_flutter2_ocean_app/widgets/scaler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class EnhanceScreen extends StatefulWidget {
    const EnhanceScreen({Key? key, required User user})
        : _user = user,
        super(key: key);

    final User _user;

    @override
    _EnhanceScreenState createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    late User _user;
    File? selectedImage;
    File? upscaledImage;
    var imgSize;
    String? message = "";
    bool isEnhancing = false; 
    bool isEnhanced = false; 
    bool _isSigningOut = false;
    String imgFileSize = "";
    String imgResolution = "";

    @override
    void initState() {
    _user = widget._user;
    super.initState();
    }

    String getFileSize(int fileSize){
        double kb = fileSize/1000;
        if(kb>1000){
            return (kb/=1000).toStringAsFixed(2) + " mb";
        }
        else{
            return kb.toStringAsFixed(2) + " kb";
        }
    }

    String getImageResolution(String imgSize){
        var imgRes = imgSize.split(" ");
        var height = imgRes[1].split(",");
        var width = imgRes[2];
        
        return height[0] + "x"+ width;
    }

    getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    imgSize = ImageSizeGetter.getSize(FileInput(selectedImage!));

    var fileSize = await selectedImage!.length();

    imgFileSize = getFileSize(fileSize);
    imgResolution = getImageResolution(imgSize.toString());
    setState(() {});
    }

    getImageFromCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    selectedImage = File(pickedImage!.path);
    imgSize = ImageSizeGetter.getSize(FileInput(selectedImage!));

    var fileSize = await selectedImage!.length();
    
    imgFileSize = getFileSize(fileSize);
    imgResolution = getImageResolution(imgSize.toString());
    setState(() {});
    }



    void displayResponseImage(String outputFile) {
    print("Updating Image");
    outputFile = 'http://35.223.166.50:8080/download/' + outputFile;
    setState(() {
        upscaledImage = Image(image: NetworkImage(outputFile)) as File?;
    });
    }



    selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
        return SimpleDialog(
            title: Text("Choose image by:"),
            children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera", style: TextStyle(color: Colors.blue),), 
                onPressed: () async {
                    await getImageFromCamera();
                    Navigator.pop(context);
                    }),
            SimpleDialogOption(
                child: Text("Image from Gallery",style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                    await getImageFromGallery();
                    Navigator.pop(context);
                    }),
            SimpleDialogOption(
                child: Text("Cancel",style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
            )
            ],
        );
        },
    );
    }

    @override
    Widget build(BuildContext context) {
        ScreenScaler scaler = new ScreenScaler()..init(context);

        Widget imageBox = Container(    
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: scaler.getHeight(40),
        width: double.infinity,
        decoration: BoxDecoration(
            color:Colors.black, //.grey[400],
            border: Border.all(
                color: Colors.black87//Colors.grey,


            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: ListView(children: [
                Column(children: [
                    Center(
                    child: Container( child: selectedImage == null
                ?  Image.asset("assets/images/please_select_Image_0.gif",  width: scaler.getWidth(80), height: scaler.getHeight(40), fit: BoxFit.fitHeight)
                    :
                    Image.file(selectedImage!, width: scaler.getWidth(80), height: scaler.getHeight(35), fit: BoxFit.fitHeight, ),),
                    ),

                Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          Text("Image Resolution: "+imgResolution, style: TextStyle(color: Colors.white)),
                          Text("File Size: "+imgFileSize, style: TextStyle(color: Colors.white)),
                          
                      ],
                  ),
                )
                ],)
            ],)
            );

    Widget btnSelectImage = 
    Container(
        margin: EdgeInsets.only(top: 12),
        child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF31a8ff))),
                onPressed: (){selectImage(context);},//getImage,
                icon: Icon(Icons.upload_file, color: Colors.white),
                label: Text("Select Image",
                    style: TextStyle(
                        color: Colors.white,
                        ))));

    Widget btnEnhanceImage = Container(
        margin: EdgeInsets.only(top: 8),
        child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(selectedImage !=null? Colors.blue: Colors.blue[200])),
                                
                onPressed: ()=>
    selectedImage !=null? 
                    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text('Enhance Image'),
            content: const Text('Do you want to enhance this selected image?'),
            actions: <Widget>[
            TextButton(
                onPressed: () =>  Navigator.of(context).pop(),//Navigator.pop(context, 'Cancel'),
                
                child: const Text('No', style: TextStyle(color: Colors.red),),
            ),
            TextButton(
                onPressed: (){

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoadingEnhanceScreen(user: widget._user, selectedImage: selectedImage!,)));
    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ImageView(image: selectedImage!, orgImage: selectedImage!, user: widget._user,)));
                    
                },
                child: const Text('Yes'),
            ),
            ],
        )) :  null,
                            
                
                icon: Icon(Icons.upload_file, color: Colors.white),
                label: Text("Enhance Image",
                    style: TextStyle(
                        color: Colors.white,
                        ))),
    );

    Widget btnTrash = Container(
        child: Container(),
    );


        Widget body = Center(
            child: isEnhancing ? 
            Container(child: Text("HAHAHAHAAHAHAH"),) :
                Container(
            // decoration: new BoxDecoration(
            //     gradient: new LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //     //   colors: [
            //     //       //Color.fromARGB(255, 135, 221, 255),
            //     //     Color.fromARGB(35,55,103,255),
            //     //     Color.fromARGB(255, 135, 221, 255)
                    
            //     //   ],
            //     )),
                child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                    imageBox,
                    btnSelectImage,
                    btnEnhanceImage
            ],
            ),
                )
        );


        return Scaffold(
        key: _scaffoldKey,
        appBar: customAppBar,
        body: body,
        endDrawer: CustomAppDawer(user: widget._user)
    );
    }
}



                 