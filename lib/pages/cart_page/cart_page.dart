import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_test/pages/cart_page/cart_page_state.dart';
import 'package:phone_test/pages/phone_details_page/phone_datails_page.dart';

import '../../source/colors.dart';
import 'cart_page_cubit.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartPageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarWidget(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              alignment: Alignment.centerLeft,
              child: const Text("My cart"),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: darklBue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    BlocCartPageProductListWidget(),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    BlocTotalDeliveryWidget(),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    CartPageButtonWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlocTotalDeliveryWidget extends StatelessWidget {
  const BlocTotalDeliveryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartPageCubit, CartPageState>(
        buildWhen: ((previous, current) {
      if (current is CartPageInitState || current is CartPageTotalPriceState) {
        return true;
      } else {
        return false;
      }
    }), builder: (ctxt, state) {
      return Container(
        height: 80,
        padding:
            const EdgeInsets.only(left: 55, right: 35, top: 15, bottom: 26),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text("Delivery",
                    style: TextStyle(color: Colors.white, fontSize: 16))
              ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    state is CartPageInitState
                        ? ""
                        : "\$" +
                            getPriceFromDouble(
                                (state as CartPageTotalPriceState).total),
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                    state is CartPageInitState
                        ? ""
                        : (state as CartPageTotalPriceState).delivery,
                    style: const TextStyle(color: Colors.white, fontSize: 16))
              ])
        ]),
      );
    });
  }
}

class BlocCartPageProductListWidget extends StatelessWidget {
  const BlocCartPageProductListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartPageCubit, CartPageState>(
        buildWhen: (previous, current) {
      if (current is CartPageInitState ||
          current is CartPageNonConnectionState ||
          current is CartPageCartDataState) return true;
      return false;
    }, builder: (ctxt, state) {
      if (state is CartPageInitState) {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      }
      if (state is CartPageNonConnectionState) {
        return const Center(
          child: Icon(Icons.signal_wifi_off_outlined),
        );
      }
      return CartPageDevicesListWidget((state as CartPageCartDataState).data);
    });
  }
}

class CartPageDevicesListWidget extends StatelessWidget {
  final List<DeviceData> data;

  const CartPageDevicesListWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 27, right: 27),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            height: 80,
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image: data[index].image.image,
                                fit: BoxFit.cover)),
                        child: Container(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 153,
                            child: Text(
                              data[index].title,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Text("\$" + getPriceFromDouble(data[index].price),
                              style: const TextStyle(
                                  fontSize: 20, color: customOrange))
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ChangeDeviceCountWidget(
                      data[index].id,
                    ),
                    GestureDetector(
                      child: Icon(Icons.remove),
                      onTap: () {
                        context
                            .read<CartPageCubit>()
                            .removeDevice(data[index].id);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeDeviceCountWidget extends StatefulWidget {
  final int id;

  const ChangeDeviceCountWidget(this.id, {Key? key}) : super(key: key);

  @override
  State<ChangeDeviceCountWidget> createState() =>
      _ChangeDeviceCountWidgetState();
}

class _ChangeDeviceCountWidgetState extends State<ChangeDeviceCountWidget> {
  int currentDeviceCount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 68,
      child: Column(children: [
        GestureDetector(
          child: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              context.read<CartPageCubit>().reduceDeviceCount(widget.id);
              if (currentDeviceCount > 1) currentDeviceCount--;
            });
          },
        ),
        Text(
          currentDeviceCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              context.read<CartPageCubit>().increaseDeviceCount(widget.id);
              currentDeviceCount++;
            });
          },
        )
      ]),
    );
  }
}

class CartPageButtonWidget extends StatelessWidget {
  const CartPageButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        alignment: Alignment.center,
        width: 300,
        height: 40,
        decoration: const BoxDecoration(
            color: customOrange,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Text(
          "Checkout",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: darklBue,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 30,
            width: 30,
            child: const Center(child: Icon(Icons.navigate_before)),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  "Add address",
                  style: TextStyle(
                    fontSize: 15,
                    color: darklBue,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: customOrange,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 30,
                width: 30,
                child: const Center(
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 16,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
