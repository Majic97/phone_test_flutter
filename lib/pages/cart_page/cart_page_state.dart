import 'package:flutter/cupertino.dart';

abstract class CartPageState {}

class CartPageInitState extends CartPageState {}

class CartPageIncreaseDeviceCountState extends CartPageState {
  final int id;

  CartPageIncreaseDeviceCountState(this.id);
}

class CartPageReduceDeviceCountState extends CartPageState {
  final int id;

  CartPageReduceDeviceCountState(this.id);
}

class CartPageNonConnectionState extends CartPageState {}

class CartPageCartDataState extends CartPageState {
  final List<DeviceData> data;

  CartPageCartDataState(this.data);
}

class CartPageTotalPriceState extends CartPageState {
  final double total;
  final String delivery;

  CartPageTotalPriceState(this.total, this.delivery);
}

class DeviceData {
  final int id;
  final Image image;
  final double price;
  final String title;
  int _count = 1;

  DeviceData(this.id, this.title, this.price, this.image);

  void increaseCount() {
    _count++;
  }

  void reduceCount() {
    if (_count > 1) _count--;
  }

  int get count => _count;
}
