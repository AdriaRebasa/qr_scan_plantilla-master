import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ScanModel {
    int? id;
    String? tipus;
    String valor;

    ScanModel({
        this.id,
        this.tipus,
        required this.valor,
    }){
      if(valor.contains('http')){
        tipus = 'http';
      } else {
        tipus = 'geo';
      }
    }

    LatLng getLatLng(){
      final latLng = valor.substring(4).split(',');
      final lat = double.parse(latLng[0]);
      final lng = double.parse(latLng[1]);
      return LatLng(lat, lng);
    }

    factory ScanModel.fromRawJson(String str) => ScanModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
    };
}