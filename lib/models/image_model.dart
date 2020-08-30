class ImageModel {
  String id;
  String nameImage;
  String pathImage;
  String detail;
  String lat;
  String lng;

  ImageModel(
      {this.id,
      this.nameImage,
      this.pathImage,
      this.detail,
      this.lat,
      this.lng});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameImage = json['NameImage'];
    pathImage = json['PathImage'];
    detail = json['Detail'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['NameImage'] = this.nameImage;
    data['PathImage'] = this.pathImage;
    data['Detail'] = this.detail;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

