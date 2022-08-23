import 'package:flutter/cupertino.dart';
import 'package:phone_test/pages/main_page/main_page_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phone_test/pages/main_page/main_page_states.dart'
    as MainPageStates;

import '../../source/exceptions/Custom_Exceptions.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitState());

  final Uri mainPageUri =
      Uri.parse("https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175");
  final Uri phoneDetail =
      Uri.parse("https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5");

  void getDataFromServer() async {
    emit(MainPageInProgressState());

    try {
      http.Response response = await http.get(mainPageUri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        emit(MainPageWithDataState(
            getHotSalesFromJson(data), getBestSellersFromJson(data)));
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(MainPageNoConnectionState());
      return;
    }
  }

  void setNewCategory(int i) {
    emit(MainPageCategoryState(i));
    getDataFromServer();
  }
}

//заполнение данных по таблице HotSale
List<HotSale> getHotSalesFromJson(Map<String, dynamic> mainPageUriBody) {
  List<HotSale> hotSales = [];

  List<dynamic> hotSalesList = mainPageUriBody["home_store"];
  for (Map<String, dynamic> item in hotSalesList) {
    try {
      hotSales.add(HotSale(
          int.parse(item['id'].toString()),
          item['title'],
          (item['is_new'] == null ? false : item['is_new']),
          item['subtitle'],
          Image.network(item['picture']),
          item['is_buy']));
    } catch (e) {
      continue;
    }
  }

  return hotSales;
}

//заполнение по таблице BestSellers
List<BestSeller> getBestSellersFromJson(Map<String, dynamic> mainPageUriBody) {
  List<BestSeller> bestSellers = [];

  List<dynamic> bestSellersList = mainPageUriBody["best_seller"];

  for (Map<String, dynamic> item in bestSellersList) {
    bestSellers.add(BestSeller(
        int.parse(item['id'].toString()),
        item['is_favorites'],
        item['title'],
        double.parse(item['price_without_discount'].toString()),
        double.parse(item['discount_price'].toString()),
        Image.network(item['picture'])));
  }

  return bestSellers;
}
