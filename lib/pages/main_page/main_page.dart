import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_test/UserAppData.dart';
import 'package:phone_test/pages/main_page/main_page_cubit.dart';
import 'package:phone_test/pages/main_page/main_page_states.dart';
import 'package:phone_test/source/custom_class/Pair.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../source/colors.dart';
import '../../source/filters_data.dart';

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
          backgroundColor: backgroundColor,
          appBar: const PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: appBarWidget()),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SelectCategoryTitleWidget(),
                    categoriesListWidget()
                  ],
                ),
              ),
              const SliverAppBar(
                backgroundColor: backgroundColor,
                flexibleSpace: SearchWidgetAndQRButtonWidget(),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: getBlocOfHotSalesWidget(),
              ),
              const SliverAppBar(
                flexibleSpace: getBestSellersTitleWidget(),
                pinned: true,
              ),
              getBlocOfBestSellersWidget()
            ],
          ),
          bottomNavigationBar: const BottomNavigationBarAndFilterBlocWidget()
          // BottomFilterWidget()
          // const bottomAppBarWidget()
          ),
    );
  }

  BlocBuilder<MainPageCubit, MainPageState> getBlocOfBestSellersWidget() {
    return BlocBuilder<MainPageCubit, MainPageState>(
        buildWhen: (previous, current) {
      if (current is MainPageInitState ||
          current is MainPageInProgressState ||
          current is MainPageNoConnectionState ||
          current is MainPageWithDataState) return true;
      return false;
    }, builder: (context, state) {
      if (state is MainPageWithDataState) {
        return SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return getBestSellersGridItemWidget(state.bestSeller, index);
            }, childCount: state.bestSeller.length),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 0.8,
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 11,
              mainAxisSpacing: 12,
            ));
      } else {
        return SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.all(5),
                child: const Center(child: CircularProgressIndicator())));
      }
    });
  }

  BlocBuilder<MainPageCubit, MainPageState> getBlocOfHotSalesWidget() {
    return BlocBuilder<MainPageCubit, MainPageState>(
      buildWhen: (previous, current) {
        if (current is MainPageInitState ||
            current is MainPageInProgressState ||
            current is MainPageNoConnectionState ||
            current is MainPageWithDataState) return true;
        return false;
      },
      builder: (context, state) {
        if (state is MainPageWithDataState && state.hotSales.isNotEmpty) {
          return getHotSalesWidget(state.hotSales);
        }
        return Container();
      },
    );
  }

  Container getBestSellersGridItemWidget(
      List<BestSeller> _bestSellers, int index) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      image: _bestSellers[index].image.image,
                      fit: BoxFit.fill)),
              child: Align(
                alignment: Alignment.topRight,
                child: LikeButtonOfBestSellerItemWidget(
                  index: index,
                ),
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
                        getPriceFromDouble(_bestSellers[index].discountPrice),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 6),
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 21, top: 1, bottom: 15),
            alignment: Alignment.bottomLeft,
            child: Text(
              _bestSellers[index].title,
              style: const TextStyle(fontSize: 12, color: darklBue),
            ),
          ),
        ]));
  }

  Padding getHotSalesWidget(List<HotSale> _hotSales) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: const Text(
                      "Hot sales",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    alignment: Alignment.centerLeft),
                const Text(
                  "see more",
                  style: TextStyle(color: customOrange, fontSize: 15),
                )
              ],
            ),
          ),
          CarouselSlider.builder(
              itemCount: _hotSales.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      getHotSalesPictureWidget(
                          context,
                          _hotSales[itemIndex].id,
                          _hotSales[itemIndex].isNew,
                          _hotSales[itemIndex].title,
                          _hotSales[itemIndex].subtitle,
                          _hotSales[itemIndex].image,
                          _hotSales[itemIndex].isBuy),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 2.0,
                initialPage: 2,
              ))
          // getHotSalesPictureWidget(context)
        ],
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getNewOrangeSign(isNew),
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

  Container getNewOrangeSign(bool isNew) {
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

  AppBar mainPageAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(children: [
          const Expanded(
              child: Center(
            child: Text(
              "Zihuanatneji,Gro",
              style: TextStyle(
                  color: darklBue, fontSize: 15, fontWeight: FontWeight.w700),
            ),
          )),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Iconsax.filter,
              size: 13.0,
              color: darklBue,
            ),
          )
        ]),
      ),
    );
  }
}

class BottomNavigationBarAndFilterBlocWidget extends StatelessWidget {
  const BottomNavigationBarAndFilterBlocWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainPageState>(
      buildWhen: (previous, current) {
        if (current is MainPageEmitFilterState || current is MainPageInitState)
          return true;
        return false;
      },
      builder: (context, state) {
        if (state is MainPageEmitFilterState) {
          if (state.emitFilter == true) return const BottomFilterWidget();
        }
        return const bottomAppBarWidget();
      },
    );
  }
}

class appBarWidget extends StatelessWidget {
  const appBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Stack(alignment: Alignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.location_on_outlined,
                color: customOrange,
                size: 13,
              ),
            ),
            const Text(
              "Zihuanatneji,Gro",
              style: TextStyle(
                  color: darklBue, fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Transform.rotate(
                angle: -3.14 / 2,
                child: const Icon(Icons.navigate_before,
                    color: Colors.grey, size: 16))
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: MaterialButton(
            minWidth: 15,
            onPressed: () {
              context.read<MainPageCubit>().emitFilter();
            },
            color: backgroundColor,
            elevation: 0,
            child: const Icon(
              Iconsax.filter,
              size: 13.0,
              color: darklBue,
            ),
          ),
        )
      ]),
    );
  }
}

class BottomFilterWidget extends StatelessWidget {
  const BottomFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
            )
          ]),
      child: Container(
        padding:
            const EdgeInsets.only(left: 46, right: 20, top: 24, bottom: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleOfFilterWidget(),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButtonTemplateWidget(
                        title: "Brand", items: mainPageFilterMap["Brand"]!),
                    DropdownButtonTemplateWidget(
                        title: "Price", items: mainPageFilterMap["Price"]!),
                    DropdownButtonTemplateWidget(
                        title: "Size", items: mainPageFilterMap["Size"]!),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

class TitleOfFilterWidget extends StatelessWidget {
  const TitleOfFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      const Text(
        "Filter options",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: darklBue),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.read<MainPageCubit>().emitFilter();
            },
            child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: darklBue),
                child: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 18,
                )),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: customOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
              onPressed: () {
                context.read<MainPageCubit>().emitFilter();
              },
              child: const Text(
                "Done",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ))
        ],
      ),
    ]);
  }
}

class DropdownButtonTemplateWidget extends StatefulWidget {
  final String title;
  late List<String> items;

  DropdownButtonTemplateWidget(
      {Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  State<DropdownButtonTemplateWidget> createState() =>
      _DropdownButtonTemplateWidgetState(title: title, items: items);
}

class _DropdownButtonTemplateWidgetState
    extends State<DropdownButtonTemplateWidget> {
  final String title;
  final List<String> items;
  late String currentValue;

  _DropdownButtonTemplateWidgetState(
      {required this.title, required this.items}) {
    if (UserAppData.appData.filterProperties[title] == null) {
      currentValue = items.first;
      UserAppData.appData.filterProperties[title] = title;
    } else {
      currentValue = UserAppData.appData.filterProperties[title]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(bottom: 5, top: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: const TextStyle(
                  color: darklBue, fontSize: 18, fontWeight: FontWeight.w700),
            )),
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          height: 37,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: const Color(0xFFDCDCDC),
                width: 1,
              )),
          child: DropdownButton(
              underline: Container(),
              alignment: Alignment.centerLeft,
              isExpanded: true,
              menuMaxHeight: 160,
              isDense: true,
              value: currentValue,
              style: const TextStyle(
                  fontFamily: "MarkPro", fontSize: 18, color: darklBue),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  UserAppData.appData.filterProperties
                      .update(title, (value) => newValue!);
                  currentValue = newValue!;
                  print(currentValue);
                  print(newValue);
                  print(currentValue);
                });
              }),
        ),
      ],
    );
  }
}

class bottomAppBarWidget extends StatelessWidget {
  const bottomAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
          color: darklBue, borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 55),
        // height: 80,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 7,
                    ),
                  ),
                  Text(
                    "Explorer",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 19,
              ),
              const Icon(
                Iconsax.heart,
                color: Colors.white,
                size: 19,
              ),
              const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 19,
              ),
            ]),
      ),
    );
  }
}

class LikeButtonOfBestSellerItemWidget extends StatefulWidget {
  final int index;

  const LikeButtonOfBestSellerItemWidget({Key? key, required this.index})
      : super(key: key);

  @override
  State<LikeButtonOfBestSellerItemWidget> createState() =>
      _LikeButtonOfBestSellerItemWidgetState(index);
}

class _LikeButtonOfBestSellerItemWidgetState
    extends State<LikeButtonOfBestSellerItemWidget> {
  final int index;

  Icon icon = const Icon(
    Iconsax.heart,
    color: customOrange,
    size: 16,
  );

  _LikeButtonOfBestSellerItemWidgetState(this.index);

  @override
  Widget build(BuildContext context) {
    if (UserAppData.appData.likedGoods.indexOf(index) >= 0) {
      icon = const Icon(
        Iconsax.heart5,
        color: customOrange,
        size: 16,
      );
    } else {
      icon = const Icon(
        Iconsax.heart,
        color: customOrange,
        size: 16,
      );
    }
    return MaterialButton(
        height: 30,
        minWidth: 30,
        color: Colors.white,
        onPressed: () {
          setState(() {
            if (UserAppData.appData.likedGoods.any((e) => e == index)) {
              UserAppData.appData.likedGoods.remove(index);
            } else {
              UserAppData.appData.likedGoods.add(index);
            }
          });
        },
        child: Stack(children: [
          const Icon(
            Iconsax.heart2,
            color: customOrange,
            size: 16,
          ),
          icon,
        ]),
        shape: const CircleBorder());
  }
}

class getBestSellersTitleWidget extends StatelessWidget {
  const getBestSellersTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 27, top: 15),
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
