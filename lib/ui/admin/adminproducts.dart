import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/ui/admin/showproduct.dart';
import 'package:mybuilding/models/usermodel.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key, required this.userModel, required this.ombor});
  final UserModel userModel;
  final Map<String, OmborModel> ombor;
  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  Map uskunalar = {};
  Map mahsulotlar = {};
  int selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    uskunalar = {};
    mahsulotlar = {};
    for (OmborModel model in widget.ombor.values) {
      if (model.type == 'uskuna') {
        if (uskunalar.containsKey(model.name)) {
          uskunalar[model.name]['items'].add(model.itemUid);
        } else {
          uskunalar[model.name] = {'total': '', 'items': []};
          uskunalar[model.name]['items'].add(model.itemUid);
        }
      } else {
        if (mahsulotlar.containsKey(model.name)) {
          mahsulotlar[model.name]['items'].add(model.itemUid);
        } else {
          mahsulotlar[model.name] = {'total': '', 'items': []};
          mahsulotlar[model.name]['items'].add(model.itemUid);
        }
      }
    }
    //total uskunalar
    for (var key in uskunalar.keys) {
      double sum = 0;

      for (var item in uskunalar[key]['items']) {
        if (widget.ombor[item]!.measure == 'dona') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'tonna') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'kg') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'km') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'metr') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'sm') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 100000;
        } else if (widget.ombor[item]!.measure == 'sm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 10000;
        } else if (widget.ombor[item]!.measure == 'm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000;
        } else if (widget.ombor[item]!.measure == 'm.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000000;
        }
      }
      uskunalar[key]['total'] = "${sum.round()} ${widget.ombor[uskunalar[key]['items'][0]]!.measure}";
    }
    //total mahsulotlar
    for (var key in mahsulotlar.keys) {
      double sum = 0;

      for (var item in mahsulotlar[key]['items']) {
        if (widget.ombor[item]!.measure == 'dona') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'tonna') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'kg') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'km') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'metr') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'sm') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 100000;
        } else if (widget.ombor[item]!.measure == 'sm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 10000;
        } else if (widget.ombor[item]!.measure == 'm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000;
        } else if (widget.ombor[item]!.measure == 'm.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000000;
        }
      }
      mahsulotlar[key]['total'] = "${sum.round()} ${widget.ombor[mahsulotlar[key]['items'][0]]!.measure}";
    }
  }

  @override
  void didUpdateWidget(covariant AdminProducts oldWidget) {
    super.didUpdateWidget(oldWidget);

    uskunalar = {};
    mahsulotlar = {};
    for (OmborModel model in widget.ombor.values) {
      if (model.type == 'uskuna') {
        if (uskunalar.containsKey(model.name)) {
          uskunalar[model.name]['items'].add(model.itemUid);
        } else {
          uskunalar[model.name] = {'total': '', 'items': []};
          uskunalar[model.name]['items'].add(model.itemUid);
        }
      } else {
        if (mahsulotlar.containsKey(model.name)) {
          mahsulotlar[model.name]['items'].add(model.itemUid);
        } else {
          mahsulotlar[model.name] = {'total': '', 'items': []};
          mahsulotlar[model.name]['items'].add(model.itemUid);
        }
      }
    }
    //total uskunalar
    for (var key in uskunalar.keys) {
      double sum = 0;

      for (var item in uskunalar[key]['items']) {
        if (widget.ombor[item]!.measure == 'dona') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'tonna') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'kg') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'km') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'metr') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'sm') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 100000;
        } else if (widget.ombor[item]!.measure == 'sm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 10000;
        } else if (widget.ombor[item]!.measure == 'm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000;
        } else if (widget.ombor[item]!.measure == 'm.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000000;
        }
      }
      uskunalar[key]['total'] = "${sum.round()} ${widget.ombor[uskunalar[key]['items'][0]]!.measure}";
    }
    //total mahsulotlar
    for (var key in mahsulotlar.keys) {
      double sum = 0;

      for (var item in mahsulotlar[key]['items']) {
        if (widget.ombor[item]!.measure == 'dona') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'tonna') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'kg') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'km') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'metr') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 1000;
        } else if (widget.ombor[item]!.measure == 'sm') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 100000;
        } else if (widget.ombor[item]!.measure == 'sm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) * 10000;
        } else if (widget.ombor[item]!.measure == 'm.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kv') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000;
        } else if (widget.ombor[item]!.measure == 'm.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi);
        } else if (widget.ombor[item]!.measure == 'km.kub') {
          sum = sum + double.parse(widget.ombor[item]!.hajmi) / 1000000000;
        }
      }
      mahsulotlar[key]['total'] = "${sum.round()} ${widget.ombor[mahsulotlar[key]['items'][0]]!.measure}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            controller: pageController,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top + 69,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      width: double.maxFinite,
                      decoration: MyDecoration.boxDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(19.0).copyWith(top: 9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("BUGUNDA",
                                    style: MyDecoration.textStyle
                                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 15, fontWeight: FontWeight.w700)),
                                Text("Mavjud",
                                    style: MyDecoration.textStyle
                                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, fontWeight: FontWeight.w700, height: 1)),
                              ],
                            ),
                          ),
                          ...List.generate(
                              selectedIndex == 0 ? uskunalar.length : mahsulotlar.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      List sortedItems =
                                          selectedIndex == 0 ? uskunalar.values.toList()[index]['items'] : mahsulotlar.values.toList()[index]['items'];
                                      sortedItems.sort((a, b) => widget.ombor[a]!.createdTime.compareTo(widget.ombor[b]!.createdTime));

                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ShowProduct(
                                          ombor: widget.ombor,
                                          total: selectedIndex == 0 ? uskunalar.values.toList()[index]['total'] : mahsulotlar.values.toList()[index]['total'],
                                          name: selectedIndex == 0 ? uskunalar.keys.toList()[index] : mahsulotlar.keys.toList()[index],
                                          itemUids: sortedItems.reversed.toList(),
                                        );
                                      }));
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: itemWidget(
                                          index: index,
                                          title: selectedIndex == 0 ? uskunalar.values.toList()[index]['total'] : mahsulotlar.values.toList()[index]['total'],
                                          txt: selectedIndex == 0 ? uskunalar.keys.toList()[index] : mahsulotlar.keys.toList()[index],
                                          lastText: '231',
                                          lastText2: '136',
                                          showDivider:
                                              (selectedIndex == 0 && index == uskunalar.length - 1) || (selectedIndex == 1 && index == mahsulotlar.length - 1)
                                                  ? false
                                                  : true),
                                    ),
                                  ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom + 69,
                    ),
                  ],
                ),
              );
            }),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: MyDecoration.boxDecoration.copyWith(borderRadius: BorderRadius.zero, color: MyColors.bgColor.withOpacity(0.59)),
              height: 49 + MediaQuery.of(context).viewPadding.top,
              width: double.maxFinite,
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedIndex != 0) {
                          HapticFeedback.lightImpact();
                          SystemSound.play(SystemSoundType.click);
                          setState(() {
                            selectedIndex = 0;
                          });
                          pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
                        }
                      },
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: MyDecoration.textStyle.copyWith(
                            color: MyColors.secondaryColor.withOpacity(selectedIndex == 0 ? 0.99 : 0.59),
                            fontSize: selectedIndex == 0 ? 37 : 24,
                            fontWeight: FontWeight.w700),
                        child: const Text("Uskunalar"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedIndex != 1) {
                          HapticFeedback.lightImpact();
                          SystemSound.play(SystemSoundType.click);
                          setState(() {
                            selectedIndex = 1;
                          });
                          pageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
                        }
                      },
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: MyDecoration.textStyle.copyWith(
                            color: MyColors.secondaryColor.withOpacity(selectedIndex == 1 ? 0.99 : 0.59),
                            fontSize: selectedIndex == 1 ? 37 : 24,
                            fontWeight: FontWeight.w700),
                        child: const Text("Material"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget itemWidget(
    {required int index, required String title, required String txt, required String lastText, required String lastText2, required bool showDivider}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: 29,
                    width: index + 1 > 9999
                        ? 65
                        : index + 1 > 999
                            ? 55
                            : index + 1 > 99
                                ? 45
                                : index + 1 > 9
                                    ? 32
                                    : 29,
                    decoration: MyDecoration.boxDecoration
                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.79), borderRadius: const BorderRadius.all(Radius.circular(9))),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: MyDecoration.textStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Text(txt,
                          style: MyDecoration.textStyle
                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, height: 1, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.69), fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            )
          ],
        ),
      ),
      Divider(
        height: 1,
        indent: 55,
        thickness: 0.5,
        color: showDivider ? MyColors.secondaryColor.withOpacity(0.19) : Colors.transparent,
      ),
    ],
  );
}
