import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'image_view.dart';

class LoadingEnhanceScreen extends StatefulWidget {
      const LoadingEnhanceScreen({Key? key, required User user, required File selectedImage})
      : _user = user, _selectedImage = selectedImage;

  final User _user;
  final File _selectedImage;

  @override
  _LoadingEnhanceScreenState createState() => _LoadingEnhanceScreenState();
}

class _LoadingEnhanceScreenState extends State<LoadingEnhanceScreen> {
    File? upscaledImage;
    String? message = "";
    bool isEnhancing = false; 
    bool isEnhanced = false; 
    String serverUrl = "http://162.243.173.48:8080";

    uploadImage(BuildContext context) async {
        setState(() => isEnhancing = true);

        final request = http.MultipartRequest(
            "POST", Uri.parse("$serverUrl/upload"));

        final headers = {"Content-type": "multipart/form-data"};

        request.files.add(http.MultipartFile('image',
            widget._selectedImage.readAsBytes().asStream(), widget._selectedImage.lengthSync(),
            filename: widget._user.uid+"_input_image"));

        request.headers.addAll(headers);
        final response = await request.send();
        http.Response res = await http.Response.fromStream(response);
        final resJson = jsonDecode(res.body);
        message = resJson['result'];
        upscaledImage = await _fileFromImageUrl(message!);

        setState(() => isEnhanced = true);
        if(isEnhanced) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ImageView(image: upscaledImage!, orgImage: widget._selectedImage, user: widget._user,)),
            );
        }
    }

    Future<File> _fileFromImageUrl(String imageUrl) async {
    Uri url = Uri.parse('$serverUrl/download/' + imageUrl);

    final response = await http.get(url);

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
    }

    @override
    void initState() {
    uploadImage(this.context);
    super.initState();
    }

    @override
    Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
        child: SpinKitCubeGrid(
                color: Colors.blue,
                size: 80.0,
            )),
        );
    }
}

