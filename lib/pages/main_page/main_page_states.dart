import 'package:flutter/cupertino.dart';

abstract class MainPageState {}

class MainPageInitState extends MainPageState {}

// состояние для загрузки
class MainPageInProgressState extends MainPageState {}

// состояние для ситуации, когда отсутсвует интернет соединение
class MainPageNoConnectionState extends MainPageState {}

// состояние с уже загруженными данными
class MainPageWithDataState extends MainPageState {
  List<HotSale> _hotSales = [];
  List<BestSeller> _bestSellers = [];

  MainPageWithDataState(this._hotSales, this._bestSellers);

  List<HotSale> get hotSales => _hotSales;
  List<BestSeller> get bestSeller => _bestSellers;
}

class MainPageCategoryState extends MainPageState {
  int category = 0;

  MainPageCategoryState(this.category);
}

class HotSale {
  final int id;
  final bool isNew;
  final String subtitle;
  final Image image;
  final bool isBuy;

  HotSale(this.id, this.isNew, this.subtitle, this.image, this.isBuy);
}

class BestSeller {
  final int id;
  final bool isFavorites;
  final String title;
  final double priceWithoutDiscount;
  final double discountPrice;
  final Image image;

  BestSeller(this.id, this.isFavorites, this.title, this.priceWithoutDiscount,
      this.discountPrice, this.image);
}
