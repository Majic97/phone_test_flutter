import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:phone_test/pages/phone_details_page/phone_details_state.dart';
import 'package:phone_test/source/colors.dart';
import 'package:http/http.dart' as http;

import '../../source/custom_class/Pair.dart';

class PhoneDetailsPage extends StatefulWidget {
  const PhoneDetailsPage({Key? key}) : super(key: key);

  @override
  State<PhoneDetailsPage> createState() => _PhoneDetailsPageState();
}

class _PhoneDetailsPageState extends State<PhoneDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const AppBarTitleWidget(),
        ),
        body: StreamBuilder<Widget>(
          stream: getPhoneDetailsMainWidget(
              "https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5"),
          builder: (context, snapshot) {
            if (snapshot.hasData) return snapshot.data!;
            return Text("Snapshot problem");
          },
        ));
  }

  Stream<Widget> getPhoneDetailsMainWidget(String uri) async* {
    late PhoneDetailsState _state;

    yield Container(
      padding: const EdgeInsets.all(8.0),
      child: const Center(child: CircularProgressIndicator()),
    );

    try {
      http.Response _response = await http.get(Uri.parse(uri));
      Map<String, dynamic> _data = {};

      if (_response.statusCode == 200) {
        _data = jsonDecode(_response.body);
      } else {
        throw Exception();
      }

      _state = PhoneDetailsState(
          id: int.parse(_data["id"].toString()),
          cpu: _data["CPU"],
          camera: _data["camera"],
          capacity: (_data["capacity"] as List<dynamic>)
              .map((e) => int.parse(e.toString()))
              .toList(),
          colors: (_data["color"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          images: (_data["images"] as List<dynamic>)
              .map((e) => Image.network(e.toString()))
              .toList(),
          isFavorite: _data["isFavorites"],
          price: double.parse(_data["price"].toString()),
          rating: double.parse(_data["rating"].toString()),
          sd: _data["sd"],
          ssd: _data["ssd"],
          title: _data["title"]);

      yield PhoneDetailsMainWidget(_state);
    } catch (e) {
      yield Center(
        child: Icon(
          Icons.signal_wifi_bad_outlined,
          color: Colors.black,
          size: 30,
        ),
      );
    }
  }
}

class AppBarTitleWidget extends StatelessWidget {
  const AppBarTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                      color: darklBue,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 30,
                  width: 30,
                  child: const Center(child: Icon(Icons.navigate_before)),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                      color: customOrange,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 30,
                  width: 30,
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 16,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/cart');
                },
              )
            ],
          ),
          const Text(
            "Product Details",
            style: TextStyle(
                fontFamily: "MarkPro",
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class PhoneDetailsMainWidget extends StatefulWidget {
  final PhoneDetailsState _state;

  const PhoneDetailsMainWidget(this._state, {Key? key}) : super(key: key);

  @override
  State<PhoneDetailsMainWidget> createState() =>
      _PhoneDetailsMainWidgetState(_state);
}

class _PhoneDetailsMainWidgetState extends State<PhoneDetailsMainWidget> {
  final PhoneDetailsState _state;

  _PhoneDetailsMainWidgetState(this._state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CarouselImageWidget(state: _state),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 8)
              ]),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 27.0, right: 27.0, top: 20, bottom: 5),
            child: Column(children: [
              BottomTitleWidget(state: _state),
              ProductDetailsWidget(_state),
              AddToCartWidget(state: _state)
            ]),
          ),
        )
      ],
    );
  }
}

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({
    Key? key,
    required PhoneDetailsState state,
  })  : _state = state,
        super(key: key);

  final PhoneDetailsState _state;

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  bool isAdded = false;
  var widgetTextStyle = const TextStyle(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    late Color _buttonColor;
    late Row _widgetTitle;

    if (isAdded) {
      _buttonColor = Colors.green[600]!;
      _widgetTitle = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Added",
            style: widgetTextStyle,
          )
        ],
      );
    } else {
      _buttonColor = customOrange;
      _widgetTitle = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              ["Add to Cart", "\$" + getPriceFromDouble(widget._state.price)]
                  .map((e) => Text(
                        e,
                        style: widgetTextStyle,
                      ))
                  .toList());
    }

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
        decoration: BoxDecoration(
            color: _buttonColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: _widgetTitle,
      ),
      onTap: () {
        setState(() {
          isAdded = !isAdded;
        });
      },
    );
  }
}

class CarouselImageWidget extends StatelessWidget {
  const CarouselImageWidget({
    Key? key,
    required PhoneDetailsState state,
  })  : _state = state,
        super(key: key);

  final PhoneDetailsState _state;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: _state.images.length,
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 8,
                      color: Colors.white,
                    )),
                child: _state.images[itemIndex]),
          );
        },
        options: CarouselOptions(
          height: 300,
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 0.75,
          initialPage: 1,
        ));
  }
}

class BottomTitleWidget extends StatelessWidget {
  const BottomTitleWidget({
    Key? key,
    required PhoneDetailsState state,
  })  : _state = state,
        super(key: key);

  final PhoneDetailsState _state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _state.title,
                style: const TextStyle(
                    color: darklBue, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const BottomTitleStarsWidget()
            ],
          ),
          const TitleLikeIconWidget(),
        ],
      ),
    );
  }
}

class BottomTitleStarsWidget extends StatefulWidget {
  const BottomTitleStarsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomTitleStarsWidget> createState() => _BottomTitleStarsWidgetState();
}

class _BottomTitleStarsWidgetState extends State<BottomTitleStarsWidget> {
  int currentSelectedStarsCount = 0;
  int size = 10;

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> _starWidgets = [];
    for (int i = 0; i < 5; i++) {
      _starWidgets.add(GestureDetector(
        child: Icon(
          i <= currentSelectedStarsCount
              ? Icons.star
              : Icons.star_border_outlined,
          color: i <= currentSelectedStarsCount ? Colors.amber[400] : darklBue,
        ),
        onTap: () {
          setState(() {
            currentSelectedStarsCount = i;
          });
        },
      ));
    }

    return Row(children: _starWidgets);
  }
}

class TitleLikeIconWidget extends StatefulWidget {
  const TitleLikeIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TitleLikeIconWidget> createState() => _TitleLikeIconWidgetState();
}

class _TitleLikeIconWidgetState extends State<TitleLikeIconWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    late Color _iconColor;
    late Color _iconBackdroundColor;
    late IconData _icon;
    if (isLiked) {
      _iconColor = customOrange;
      _iconBackdroundColor = Colors.white;
      _icon = Iconsax.heart5;
    } else {
      _iconColor = Colors.white;
      _iconBackdroundColor = darklBue;
      _icon = Iconsax.heart;
    }

    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
            color: _iconBackdroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          height: 30,
          width: 30,
          child: Center(
              child: Icon(
            _icon,
            size: 15,
            color: _iconColor,
          ))),
      onTap: () {
        setState(() {
          isLiked = !isLiked;
        });
      },
    );
  }
}

class ProductDetailsWidget extends StatefulWidget {
  final PhoneDetailsState _state;

  const ProductDetailsWidget(this._state, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsWidget> createState() =>
      _ProductDetailsWidgetState(_state);
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final PhoneDetailsState _state;

  int selectedItem = 0;
  List<Pair<IconData, String>> detailsData = [];
  List<Color> colors = [];
  List<String> detailGroups = ["Shop", "Details", "Features"];

  _ProductDetailsWidgetState(this._state) {
    detailsData = [
      Pair(Iconsax.cpu, _state.cpu),
      Pair(Iconsax.camera, _state.camera),
      Pair(Icons.memory, _state.sd),
      Pair(Icons.sd_card, _state.ssd),
    ];

    colors = _state.colors
        .map((e) => Color(int.parse(e.replaceAll("#", "0xFF"))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShopDetailsFeaturesWidget(
            detailGroups: detailGroups, detailsData: detailsData),
        Column(children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select color and capacity",
                style: TextStyle(
                    color: darklBue, fontSize: 18, fontWeight: FontWeight.w600),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 13, bottom: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectColorWidget(colors: colors),
                SelectCapacityWidget(state: _state)
              ],
            ),
          )
        ]),
      ],
    );
  }
}

class ShopDetailsFeaturesWidget extends StatefulWidget {
  const ShopDetailsFeaturesWidget({
    Key? key,
    required this.detailGroups,
    required this.detailsData,
  }) : super(key: key);

  final List<String> detailGroups;
  final List<Pair<IconData, String>> detailsData;

  @override
  State<ShopDetailsFeaturesWidget> createState() =>
      _ShopDetailsFeaturesWidgetState();
}

class _ShopDetailsFeaturesWidgetState extends State<ShopDetailsFeaturesWidget> {
  int currentSection = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.detailGroups.map((e) {
              bool isCurrentSection =
                  widget.detailGroups.indexOf(e) == currentSection;
              return GestureDetector(
                child: Container(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: isCurrentSection ? customOrange : Colors.white,
                    width: 3.0,
                  ))),
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          isCurrentSection ? FontWeight.w600 : FontWeight.w200,
                      color: isCurrentSection ? darklBue : Colors.grey,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    currentSection = widget.detailGroups.indexOf(e);
                  });
                },
              );
            }).toList()),
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.detailsData
                .map((e) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          e.first,
                          size: 25,
                          color: Colors.grey[900 - currentSection * 200],
                        ),
                        const SizedBox(height: 5),
                        Text(e.second)
                      ],
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class SelectCapacityWidget extends StatefulWidget {
  const SelectCapacityWidget({
    Key? key,
    required PhoneDetailsState state,
  })  : _state = state,
        super(key: key);

  final PhoneDetailsState _state;

  @override
  State<SelectCapacityWidget> createState() => _SelectCapacityWidgetState();
}

class _SelectCapacityWidgetState extends State<SelectCapacityWidget> {
  int currentItem = 0;

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> _capacityWidgets = [];

    for (int itemCapcity in widget._state.capacity) {
      _capacityWidgets.add(GestureDetector(
        child: Container(
          alignment: Alignment.center,
          height: 26,
          width: 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: widget._state.capacity.indexOf(itemCapcity) == currentItem
                  ? customOrange
                  : Colors.white),
          child: Text(
            "$itemCapcity GB",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:
                    widget._state.capacity.indexOf(itemCapcity) == currentItem
                        ? Colors.white
                        : Colors.grey),
          ),
        ),
        onTap: () {
          setState(() {
            currentItem = widget._state.capacity.indexOf(itemCapcity);
          });
        },
      ));
    }

    return Row(children: _capacityWidgets);
  }
}

class SelectColorWidget extends StatefulWidget {
  const SelectColorWidget({
    Key? key,
    required this.colors,
  }) : super(key: key);

  final List<Color> colors;

  @override
  State<SelectColorWidget> createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  int currentColor = 0;

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> _colorWidgets = [];

    for (Color color in widget.colors) {
      _colorWidgets.add(GestureDetector(
        child: Stack(alignment: Alignment.center, children: [
          Icon(
            Icons.circle,
            color: color,
            size: 40,
          ),
          widget.colors.indexOf(color) == currentColor
              ? const Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.white,
                )
              : Container()
        ]),
        onTap: () {
          setState(() {
            currentColor = widget.colors.indexOf(color);
          });
        },
      ));
    }
    return Row(
      children: _colorWidgets,
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
