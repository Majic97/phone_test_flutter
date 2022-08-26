import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_test/pages/cart_page/cart_page_state.dart';
import 'package:http/http.dart' as http;

class CartPageCubit extends Cubit<CartPageState> {
  CartPageCubit() : super(CartPageInitState()) {
    getCartData();
  }

  List<DeviceData> cartData = [];
  String delivery = '';
  late int id;

  final Uri cartPageUri =
      Uri.parse("https://run.mocky.io/v3/53539a72-3c5f-4f30-bbb1-6ca10d42c149");

  void getCartData() async {
    emit(CartPageInitState());

    try {
      http.Response response = await http.get(cartPageUri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        delivery = data["delivery"];
        id = int.parse(data["id"].toString());

        for (Map<String, dynamic> row in (data["basket"] as List<dynamic>)) {
          cartData.add(DeviceData(
              int.parse(row["id"].toString()),
              row["title"],
              double.parse(row["price"].toString()),
              Image.network(row["images"])));
        }

        emit(CartPageCartDataState(cartData));
        countNewTotalPrice();
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(CartPageNonConnectionState());
    }
  }

  void countNewTotalPrice() {
    double total = 0;

    for (DeviceData item in cartData) {
      total = total + item.count * item.price;
    }

    emit(CartPageTotalPriceState(total, delivery));
  }

  void increaseDeviceCount(int id) {
    if (cartData.any((e) => e.id == id)) {
      cartData[cartData.indexWhere((e) => e.id == id)].increaseCount();
    }
    countNewTotalPrice();
  }

  void reduceDeviceCount(int id) {
    if (cartData.any((e) => e.id == id)) {
      cartData[cartData.indexWhere((e) => e.id == id)].reduceCount();
    }
    countNewTotalPrice();
  }

  void removeDevice(int id) {
    cartData.removeWhere((e) => e.id == id);
    emit(CartPageCartDataState(cartData));
    countNewTotalPrice();
  }
}
