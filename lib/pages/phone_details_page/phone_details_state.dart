import 'package:flutter/cupertino.dart';

class PhoneDetailsState {
  final int id;
  final String cpu;
  final String camera;
  List<int> capacity = [];
  List<Image> images = [];
  List<String> colors = [];
  final bool isFavorite;
  final double price;
  final double rating;
  final String sd;
  final String ssd;
  final String title;

  PhoneDetailsState(
      {required this.id,
      required this.cpu,
      required this.camera,
      required this.isFavorite,
      required this.price,
      required this.rating,
      required this.sd,
      required this.ssd,
      required this.title,
      required this.capacity,
      required this.images,
      required this.colors});
}
