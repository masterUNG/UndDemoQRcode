import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungdemoqrcode/models/image_model.dart';
import 'package:ungdemoqrcode/utility/my_constant.dart';
import 'package:ungdemoqrcode/widgets/add_data.dart';
import 'package:ungdemoqrcode/widgets/detial.dart';

class AboutImage extends StatefulWidget {
  @override
  _AboutImageState createState() => _AboutImageState();
}

class _AboutImageState extends State<AboutImage> {
  List<ImageModel> imageModels = List();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        print('On The Top');
        readAllData();
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('On The Button');
        readAllData();
      }
    });

    readAllData();
  }

  Future<Null> readAllData() async {
    if (imageModels.length != 0) {
      imageModels.clear();
    }

    String urlAPI = '${MyConstant().domain}/wee/getAllData.php';
    Response response = await Dio().get(urlAPI);
    var result = json.decode(response.data);
    for (var json in result) {
      ImageModel model = ImageModel.fromJson(json);
      setState(() {
        imageModels.add(model);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddData(),
          ),
        ).then((value) => readAllData()),
        child: Icon(Icons.add_photo_alternate),
      ),
      appBar: AppBar(
        title: Text('List All Data'),
      ),
      body: imageModels.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      controller: scrollController,
      itemCount: imageModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detail(
                imageModel: imageModels[index],
              ),
            )),
        child: Row(
          children: [
            buildImage(index),
            buildText(index),
          ],
        ),
      ),
    );
  }

  Widget buildText(int index) => Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTextName(index),
            buildTextDetail(index),
          ],
        ),
      );

  Text buildTextName(int index) {
    return Text(
      imageModels[index].nameImage,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text buildTextDetail(int index) {
    String string = imageModels[index].detail;
    if (string.length >= 70) {
      string = string.substring(1, 50);
      string = '$string ...';
    }
    return Text(string);
  }

  Container buildImage(int index) => Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(8),
        child: CachedNetworkImage(
          imageUrl: '${MyConstant().domain}${imageModels[index].pathImage}',
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Image.asset('images/question.png'),
        ),
      );
}
