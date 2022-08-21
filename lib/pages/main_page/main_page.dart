import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_test/pages/main_page/main_page_cubit.dart';
import 'package:phone_test/pages/main_page/main_page_states.dart';
import 'package:phone_test/source/custom_class/Pair.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
              Padding(
                padding: const EdgeInsets.only(left: 17.0, right: 33),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Select category",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      "view all",
                      style: TextStyle(color: customOrange),
                    )
                  ],
                ),
              ),
              selectCategoryList()
            ],
          )),
    );
  }

  SizedBox selectCategoryList() {
    return SizedBox(
      height: 120.0,
      child: BlocBuilder<MainPageCubit, MainPageState>(
          buildWhen: (previous, current) {
        if (current is MainPageInitState || current is MainPageCategoryState)
          return true;
        return false;
      }, builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryIcons.length,
          itemBuilder: (context, index) {
            late int _selectedCategory = 0;
            if (state is MainPageCategoryState)
              _selectedCategory = (state).category;
            return getCategoryWidget(
                index, (_selectedCategory == index), context);
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

  Padding getCategoryWidget(int index, bool isSelected, BuildContext context) {
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
