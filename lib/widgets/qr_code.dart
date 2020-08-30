import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungdemoqrcode/models/food_model.dart';
import 'package:ungdemoqrcode/utility/my_constant.dart';
import 'package:ungdemoqrcode/utility/normal_dialog.dart';
import 'package:ungdemoqrcode/widgets/about_image.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  String resultQRcode = '';
  FoodModel model;

  Widget qrButton() {
    return RaisedButton(
      onPressed: () {
        print('You Click QRcode');
        qrThread();
      },
      child: Text('QR code'),
    );
  }

  Future<Null> qrThread() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        resultQRcode = result.rawContent;
        readDataFromAPI();
      });
      print('resultQRcode ===>> $resultQRcode');
    } catch (e) {
      print('Error QRcode ===>> ${e.toString()}');
    }
  }

  Future<Null> readDataFromAPI() async {
    String urlAPI =
        '${MyConstant().domain}/wee/getDataWhereId.php?isAdd=true&id=$resultQRcode';
    Response response = await Dio().get(urlAPI);
    print('response ===>> $response');

    if (response.toString() == 'null') {
      normalDialog(context, 'ไม่มี $resultQRcode นี่ใน ฐานข้อมูลของเรา');
    } else {
      var result = json.decode(response.data);
      print('result = $result');
      for (var json in result) {
        setState(() {
          model = FoodModel.fromJson(json);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read QR or BarCode'),
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutImage(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildText(),
              qrButton(),
              buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResult() => model == null
      ? Text('No Result')
      : Column(
          children: [
            Text('Category ==> ${model.category}'),
            Text('NameFood ==> ${model.nameFood}'),
            Text('Price ==> ${model.price} THB.'),
            Text('Detail ==> ${model.detail}'),
          ],
        );

  Text buildText() => Text('Result Readed ==> $resultQRcode');
}
