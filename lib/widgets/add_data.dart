import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ungdemoqrcode/utility/my_constant.dart';
import 'package:ungdemoqrcode/utility/normal_dialog.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  double lat, lng;
  File file;
  String name, detail;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat ==>> $lat, lng ==>> $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();

    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImage(),
            buildName(),
            buildDetail(),
            lat == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : buildMap(context),
            buildRaisedButton(),
          ],
        ),
      ),
    );
  }

  Container buildRaisedButton() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        onPressed: () {
          if (file == null) {
            normalDialog(
                context, 'Please Choose Image by Click Camera or Gallery');
          } else if (name == null ||
              name.isEmpty ||
              detail == null ||
              detail.isEmpty) {
            normalDialog(context, 'Have Space Please Fill Every Blank');
          } else {
            uploadImageToServer();
          }
        },
        icon: Icon(Icons.save),
        label: Text('Save Data'),
      ),
    );
  }

  Container buildMap(BuildContext context) {
    // lat = 13.673431;
    // lng = 100.606520;

    LatLng centerMap = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: centerMap,
      zoom: 16,
    );

    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: setMarker(),
      ),
    );
  }

  Set<Marker> setMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('User'),
        position: LatLng(lat, lng),
        infoWindow:
            InfoWindow(title: 'Your Here', snippet: 'lat = $lat, lng = $lng'),
      ),
    ].toSet();
  }

  Container buildName() => Container(
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(labelText: 'Name Image'),
        ),
      );

  Container buildDetail() => Container(
        width: 250,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          decoration: InputDecoration(labelText: 'Detail Image'),
        ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    var result = await ImagePicker().getImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );

    setState(() {
      file = File(result.path);
    });
  }

  Row buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 250,
          child:
              file == null ? Image.asset('images/image.png') : Image.file(file),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> uploadImageToServer() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'image$i.jpg';

    String urlAPIsaveFile = '${MyConstant().domain}/wee/saveFile.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      await Dio().post(urlAPIsaveFile, data: formData).then((value) {
        print('Upload Image Success');
        insertDataToMySQL(nameFile);
      });
    } catch (e) {}
  }

  Future<Null> insertDataToMySQL(String nameFile) async {
    String pathImage = '/wee/Image/$nameFile';

    String urlAPI =
        '${MyConstant().domain}/wee/addData.php?isAdd=true&NameImage=$name&PathImage=$pathImage&Detail=$detail&Lat=$lat&Lng=$lng';

    await Dio().get(urlAPI).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Please Try Again Upload False');
      }
    });
  }
}
