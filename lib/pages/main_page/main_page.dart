import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_test/pages/main_page/main_page_cubit.dart';
import 'package:phone_test/pages/main_page/main_page_states.dart';
import 'package:phone_test/source/custom_class/Pair.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../source/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainPageCubit(),
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: mainPageAppBar()),
          body: Column(
            children: [
              const SelectCategoryTitleWidget(),
              categoriesListWidget(),
              const SearchWidgetAndQRButtonWidget(),
              BlocBuilder<MainPageCubit, MainPageState>(
                buildWhen: (previous, current) {
                  if (current is MainPageInitState ||
                      current is MainPageInProgressState ||
                      current is MainPageNoConnectionState ||
                      current is MainPageWithDataState) return true;
                  return false;
                },
                builder: (context, state) {
                  if (state is MainPageInitState ||
                      state is MainPageInProgressState)
                    return const CircularProgressIndicator();
                  if (state is MainPageNoConnectionState)
                    return const Icon(
                        Icons.signal_wifi_connected_no_internet_4_rounded);
                  return getHotSalesAndBestSellersWidget(
                      context, (state as MainPageWithDataState));
                },
              )
            ],
          )),
    );
  }

  Widget getHotSalesAndBestSellersWidget(
      BuildContext context, MainPageWithDataState state) {
    var _hotSales = state.hotSales;
    var _bestSellers = state.bestSeller;

    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
        //   child: Column(
        //     children: <Widget>[
        //       Row(
        //         children: <Widget>[
        //           Expanded(
        //             child: Container(
        //                 child: const Text(
        //                   "Hot sales",
        //                   style: TextStyle(
        //                       fontSize: 25, fontWeight: FontWeight.w700),
        //                 ),
        //                 alignment: Alignment.centerLeft),
        //           ),
        //           const Text(
        //             "see more",
        //             style: TextStyle(color: customOrange, fontSize: 15),
        //           )
        //         ],
        //       ),
        //       CarouselSlider.builder(
        //           itemCount: state.hotSales.length,
        //           itemBuilder: (BuildContext context, int itemIndex,
        //                   int pageViewIndex) =>
        //               getHotSalesPictureWidget(
        //                   context,
        //                   _hotSales[itemIndex].id,
        //                   _hotSales[itemIndex].isNew,
        //                   _hotSales[itemIndex].title,
        //                   _hotSales[itemIndex].subtitle,
        //                   _hotSales[itemIndex].image,
        //                   _hotSales[itemIndex].isBuy),
        //           options: CarouselOptions(
        //             autoPlay: false,
        //             enlargeCenterPage: true,
        //             viewportFraction: 1,
        //             aspectRatio: 2.0,
        //             initialPage: 2,
        //           ))
        //       // getHotSalesPictureWidget(context)
        //     ],
        //   ),
        // ),
        Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 27, top: 15, bottom: 20),
          child: Row(children: <Widget>[
            const Text(
              "Best sellers",
              style: TextStyle(
                  fontSize: 25, color: darklBue, fontWeight: FontWeight.w800),
            ),
            Expanded(child: Container()),
            const Text(
              "see more",
              style: TextStyle(fontSize: 15, color: customOrange),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 0.8,
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 11,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _bestSellers[index].image.image,
                                fit: BoxFit.cover)),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: MaterialButton(
                              height: 30,
                              minWidth: 30,
                              color: customOrange,
                              onPressed: () {},
                              child: const Icon(
                                Iconsax.heart,
                                color: Colors.white,
                                size: 16,
                              ),
                              shape: const CircleBorder()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 21, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "\$" +
                                  getPriceFromDouble(
                                      _bestSellers[index].discountPrice),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "\$" +
                                  getPriceFromDouble(
                                      _bestSellers[index].priceWithoutDiscount),
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 10),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]));
            },
          ),
        )
      ],
    );
  }

  Container getHotSalesPictureWidget(BuildContext context, int id, bool isNew,
      String title, String subTitle, Image picture, bool isBuy) {
    return Container(
        height: 180.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(image: picture.image, fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 20),
          alignment: Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              getNewOrengSign(isNew),
              Expanded(child: Container()),
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subTitle,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )
                ],
              ),
              Expanded(child: Container()),
              getBuyNowButton(isBuy),
            ],
          ),
        ));
  }

  Container getBuyNowButton(bool isBuy) {
    if (isBuy) {
      return Container(
        height: 20,
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              fixedSize: MaterialStateProperty.all(const Size(85, 20))),
          child: const Text(
            "Buy now!",
            style: TextStyle(
                fontSize: 11, color: darklBue, fontWeight: FontWeight.w900),
          ),
          onPressed: () {},
        ),
      );
    } else {
      return Container(
        height: 20,
        width: 85,
        alignment: Alignment.centerLeft,
      );
    }
  }

  String getPriceFromDouble(double value) {
    if ((value - value.roundToDouble()) == 0) {
      return NumberFormat.currency(customPattern: "##,##0.00", decimalDigits: 0)
          .format(value);
    } else {
      return NumberFormat.currency(customPattern: "##,##0.00", decimalDigits: 2)
          .format(value);
    }
  }

  Container getNewOrengSign(bool isNew) {
    if (isNew) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: const <Widget>[
              Icon(
                Icons.circle,
                size: 30,
                color: customOrange,
              ),
              Text(
                "New",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              )
            ],
          ));
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        height: 30,
        width: 30,
      );
    }
  }

  SizedBox categoriesListWidget() {
    return SizedBox(
      height: 110.0,
      child: BlocBuilder<MainPageCubit, MainPageState>(
          buildWhen: (previous, current) {
        return (current is MainPageInitState ||
                current is MainPageCategoryState)
            ? true
            : false;
      }, builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryIcons.length,
          itemBuilder: (context, index) {
            late int _category = 0;
            if (state is MainPageCategoryState) _category = (state).category;
            return getCategoryCircleWidget(
                index, (_category == index), context);
          },
        );
      }),
    );
  }

  List<Pair<IconData, String>> categoryIcons = [
    Pair(Iconsax.mobile, "Phones"),
    Pair(Icons.computer, "Computers"),
    Pair(Iconsax.heart, "Health"),
    Pair(Iconsax.book, "Books"),
    Pair(Iconsax.monitor, "TV"),
    Pair(Icons.headphones, "Headphones")
  ];

  Padding getCategoryCircleWidget(
      int index, bool isSelected, BuildContext context) {
    final Color buttonColor;
    final Color iconColor;

    if (isSelected) {
      buttonColor = customOrange;
      iconColor = Colors.white;
    } else {
      buttonColor = Colors.white;
      iconColor = const Color(0x4D010035);
    }

    return Padding(
      padding:
          const EdgeInsets.only(left: 18.0, top: 10.0, bottom: 10, right: 5.0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              height: 65,
              width: 65,
              child: MaterialButton(
                elevation: 1,
                onPressed: () {
                  context.read<MainPageCubit>().setNewCategory(index);
                },
                color: buttonColor,
                child: Icon(
                  categoryIcons[index].first,
                  size: 20.0,
                  color: iconColor,
                ),
                shape: const CircleBorder(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: 20,
            child: Text(
              categoryIcons[index].second,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: darklBue),
            ),
          )
        ],
      ),
    );
  }

  AppBar mainPageAppBar() {
    return AppBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(children: const [
          Expanded(
              child: Center(
            child: Text(
              "Zihuanatneji,Gro",
              style: TextStyle(
                  color: darklBue, fontSize: 15, fontWeight: FontWeight.w700),
            ),
          )),
          Icon(
            Iconsax.filter,
            size: 13.0,
            color: darklBue,
          )
        ]),
      ),
    );
  }
}

class SearchWidgetAndQRButtonWidget extends StatelessWidget {
  const SearchWidgetAndQRButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 32, right: 26, top: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          const Expanded(child: SearchWidget()),
          MaterialButton(
              height: 30,
              minWidth: 30,
              color: customOrange,
              onPressed: () {},
              child: const Icon(
                Icons.qr_code,
                color: Colors.white,
                size: 16,
              ),
              shape: const CircleBorder())
        ],
      ),
    );
  }
}

class SelectCategoryTitleWidget extends StatelessWidget {
  const SelectCategoryTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0, right: 33),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              "Select category",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            "view all",
            style: TextStyle(color: customOrange),
          )
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 50, color: Colors.black.withOpacity(0.08))
      ]),
      child: const TextField(
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: customOrange,
                size: 20.0,
              ),
              hintText: "Search",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(50.0))))),
    );
  }
}
