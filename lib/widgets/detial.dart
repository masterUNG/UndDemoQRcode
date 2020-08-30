import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ungdemoqrcode/models/image_model.dart';
import 'package:ungdemoqrcode/utility/my_constant.dart';

class Detail extends StatefulWidget {
  final ImageModel imageModel;
  Detail({Key key, this.imageModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  ImageModel imageModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageModel = widget.imageModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageModel.nameImage),
      ),
      body: Column(
        children: [
          buildImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(imageModel.detail),
          ),
        ],
      ),
    );
  }

  Row buildImage(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: CachedNetworkImage(
              errorWidget: (context, url, error) =>
                  Image.asset('images/question.png'),
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: '${MyConstant().domain}${imageModel.pathImage}'),
        ),
      ],
    );
  }
}
