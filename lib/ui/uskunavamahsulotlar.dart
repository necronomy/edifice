import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/ui/admin/admintop.dart';

class UskunaVaMahsulotlar extends StatefulWidget {
  const UskunaVaMahsulotlar({super.key, required this.uskunavamahsulotlar});
  final Map uskunavamahsulotlar;
  @override
  State<UskunaVaMahsulotlar> createState() => _UskunaVaMahsulotlarState();
}

class _UskunaVaMahsulotlarState extends State<UskunaVaMahsulotlar> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController text2EditingController = TextEditingController();
  TextEditingController text3EditingController = TextEditingController();
  int selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  Map uskunalarMap = {};
  Map mahsulotlarMap = {};

  @override
  void initState() {
    super.initState();
    for (var key in widget.uskunavamahsulotlar.keys.toList()) {
      if (widget.uskunavamahsulotlar[key]['type'] == 'uskuna') {
        uskunalarMap[key] = widget.uskunavamahsulotlar[key];
      } else {
        mahsulotlarMap[key] = widget.uskunavamahsulotlar[key];
      }
    }
  }

  @override
  void didUpdateWidget(covariant UskunaVaMahsulotlar oldWidget) {
    super.didUpdateWidget(oldWidget);
    uskunalarMap = {};
    mahsulotlarMap = {};
    for (var key in widget.uskunavamahsulotlar.keys.toList()) {
      if (widget.uskunavamahsulotlar[key]['type'] == 'uskuna') {
        uskunalarMap[key] = widget.uskunavamahsulotlar[key];
      } else {
        mahsulotlarMap[key] = widget.uskunavamahsulotlar[key];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: Stack(
        children: [
          PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              controller: pageController,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).viewPadding.top + 69,
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: MyDecoration.boxDecoration,
                        child: Column(
                          children: [
                            ...List.generate(selectedIndex == 0 ? uskunalarMap.length : mahsulotlarMap.length, (index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    textEditingController.text =
                                        selectedIndex == 0 ? uskunalarMap.values.toList()[index]['uz'] : mahsulotlarMap.values.toList()[index]['uz'];
                                    text2EditingController.text =
                                        selectedIndex == 0 ? uskunalarMap.values.toList()[index]['oz'] : mahsulotlarMap.values.toList()[index]['oz'];
                                    text3EditingController.text =
                                        selectedIndex == 0 ? uskunalarMap.values.toList()[index]['ru'] : mahsulotlarMap.values.toList()[index]['ru'];
                                  });
                                  await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Container(
                                          decoration: MyDecoration.boxDecoration.copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
                                          child: SafeArea(
                                            top: false,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 7),
                                                  height: 7,
                                                  width: 129,
                                                  decoration:
                                                      BoxDecoration(color: MyColors.secondaryColor.withOpacity(0.79), borderRadius: BorderRadius.circular(7)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                  child: TextFormField(
                                                    controller: textEditingController,
                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                    maxLines: 5,
                                                    minLines: 1,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    autofocus: true,
                                                    decoration: MyDecoration.inputDecoration.copyWith(labelText: "Uskuna nomi", suffixText: "O'zbekcha"),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                  child: TextFormField(
                                                    controller: text2EditingController,
                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                    maxLines: 5,
                                                    minLines: 1,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    autofocus: true,
                                                    decoration: MyDecoration.inputDecoration.copyWith(labelText: "Ускуна номи", suffixText: "Ўзбекча"),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                  child: TextFormField(
                                                    controller: text3EditingController,
                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                    maxLines: 5,
                                                    minLines: 1,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    autofocus: true,
                                                    decoration:
                                                        MyDecoration.inputDecoration.copyWith(labelText: "Наименование устройства", suffixText: "Русский"),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    String uid = selectedIndex == 0 ? uskunalarMap.keys.toList()[index] : mahsulotlarMap.keys.toList()[index];
                                                    FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').update({
                                                      uid: {
                                                        'uz': textEditingController.text,
                                                        'oz': text2EditingController.text,
                                                        'ru': text3EditingController.text,
                                                        'type': selectedIndex == 0 ? "mahsulot" : "uskuna"
                                                      }
                                                    });
                                                    setState(() {
                                                      textEditingController.text = '';
                                                      text2EditingController.text = '';
                                                      text3EditingController.text = '';
                                                    });

                                                    Navigator.pop(context);
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(19.0),
                                                    child: Container(
                                                        height: 49,
                                                        decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.89)),
                                                        child: Center(
                                                          child: Text(
                                                            selectedIndex == 0 ? "Mahsulotlarga o'tkazish" : "Uskunalarga o'tkazish",
                                                            style: MyDecoration.textStyle,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    String uid = selectedIndex == 0 ? uskunalarMap.keys.toList()[index] : mahsulotlarMap.keys.toList()[index];
                                                    FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').update({
                                                      uid: {
                                                        'uz': textEditingController.text,
                                                        'oz': text2EditingController.text,
                                                        'ru': text3EditingController.text,
                                                        'type': selectedIndex == 0
                                                            ? uskunalarMap.values.toList()[index]['type']
                                                            : mahsulotlarMap.values.toList()[index]['type']
                                                      }
                                                    });
                                                    setState(() {
                                                      textEditingController.text = '';
                                                      text2EditingController.text = '';
                                                      text3EditingController.text = '';
                                                    });

                                                    Navigator.pop(context);
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(9.0),
                                                    child: Container(
                                                        width: 199,
                                                        height: 49,
                                                        constraints: const BoxConstraints(maxHeight: 59, maxWidth: 299),
                                                        decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.blueColor.withOpacity(0.89)),
                                                        child: const Center(
                                                          child: Text(
                                                            "Saqlash",
                                                            style: MyDecoration.textStyle,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  duration: const Duration(microseconds: 1),
                                                  height: MediaQuery.of(context).viewInsets.bottom,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                  setState(() {
                                    textEditingController.text = '';
                                    text2EditingController.text = '';
                                    text3EditingController.text = '';
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
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
                                            decoration: MyDecoration.boxDecoration.copyWith(
                                                color: MyColors.secondaryColor.withOpacity(0.79), borderRadius: const BorderRadius.all(Radius.circular(9))),
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: MyDecoration.textStyle,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 7),
                                              child: Text(
                                                  selectedIndex == 0 ? uskunalarMap.values.toList()[index]['uz'] : mahsulotlarMap.values.toList()[index]['uz'],
                                                  textAlign: TextAlign.start,
                                                  style: MyDecoration.textStyle.copyWith(
                                                      color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 21, fontWeight: FontWeight.normal)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      (selectedIndex == 0 && index == uskunalarMap.length - 1) || (selectedIndex == 1 && index == mahsulotlarMap.length - 1)
                                          ? const SizedBox()
                                          : Divider(
                                              thickness: 0.3,
                                              height: 1,
                                              indent: 53,
                                              color: MyColors.secondaryColor.withOpacity(0.19),
                                            )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                    ],
                  ),
                );
              }),
          const Align(
            alignment: Alignment.topCenter,
            child: AdminTop(),
          ),
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
                      Row(
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
                          selectedIndex != 0
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            decoration:
                                                MyDecoration.boxDecoration.copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 7),
                                                    height: 7,
                                                    width: 129,
                                                    decoration: BoxDecoration(
                                                        color: MyColors.secondaryColor.withOpacity(0.79), borderRadius: BorderRadius.circular(7)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: textEditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration: MyDecoration.inputDecoration.copyWith(labelText: "Uskuna nomi", suffixText: "O'zbekcha"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: text2EditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration: MyDecoration.inputDecoration.copyWith(labelText: "Ускуна номи", suffixText: "Ўзбекча"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: text3EditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration:
                                                          MyDecoration.inputDecoration.copyWith(labelText: "Наименование устройства", suffixText: "Русский"),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').update({
                                                        widget.uskunavamahsulotlar.length.toString(): {
                                                          'uz': textEditingController.text,
                                                          'oz': text2EditingController.text,
                                                          'ru': text3EditingController.text,
                                                          'type': 'uskuna'
                                                        }
                                                      });
                                                      setState(() {
                                                        textEditingController.text = '';
                                                        text2EditingController.text = '';
                                                        text3EditingController.text = '';
                                                      });

                                                      Navigator.pop(context);
                                                      FocusScope.of(context).unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(9.0),
                                                      child: Container(
                                                          width: 199,
                                                          height: 49,
                                                          constraints: const BoxConstraints(maxHeight: 59, maxWidth: 299),
                                                          decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.blueColor.withOpacity(0.89)),
                                                          child: const Center(
                                                            child: Text(
                                                              "Qo'shish",
                                                              style: MyDecoration.textStyle,
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  AnimatedContainer(
                                                    duration: const Duration(microseconds: 1),
                                                    height: MediaQuery.of(context).viewInsets.bottom,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                                    height: 29,
                                    width: 29,
                                    decoration: BoxDecoration(color: MyColors.blueColor.withOpacity(0.79), shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 29,
                                        color: MyColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      Row(
                        children: [
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
                          selectedIndex != 1
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            decoration:
                                                MyDecoration.boxDecoration.copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 7),
                                                    height: 7,
                                                    width: 129,
                                                    decoration: BoxDecoration(
                                                        color: MyColors.secondaryColor.withOpacity(0.79), borderRadius: BorderRadius.circular(7)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: textEditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration: MyDecoration.inputDecoration.copyWith(labelText: "Mahsulot nomi", suffixText: "O'zbekcha"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: text2EditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration: MyDecoration.inputDecoration.copyWith(labelText: "Маҳсулот номи", suffixText: "Ўзбекча"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                    child: TextFormField(
                                                      controller: text3EditingController,
                                                      style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor, fontSize: 17),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      autofocus: true,
                                                      decoration:
                                                          MyDecoration.inputDecoration.copyWith(labelText: "Наименование товара", suffixText: "Русский"),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').update({
                                                        widget.uskunavamahsulotlar.length.toString(): {
                                                          'uz': textEditingController.text,
                                                          'oz': text2EditingController.text,
                                                          'ru': text3EditingController.text,
                                                          'type': 'mahsulot'
                                                        }
                                                      });
                                                      setState(() {
                                                        textEditingController.text = '';
                                                        text2EditingController.text = '';
                                                        text3EditingController.text = '';
                                                      });

                                                      Navigator.pop(context);
                                                      FocusScope.of(context).unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(9.0),
                                                      child: Container(
                                                          width: 199,
                                                          height: 49,
                                                          constraints: const BoxConstraints(maxHeight: 59, maxWidth: 299),
                                                          decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.blueColor.withOpacity(0.89)),
                                                          child: const Center(
                                                            child: Text(
                                                              "Qo'shish",
                                                              style: MyDecoration.textStyle,
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  AnimatedContainer(
                                                    duration: const Duration(microseconds: 1),
                                                    height: MediaQuery.of(context).viewInsets.bottom,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                                    height: 29,
                                    width: 29,
                                    decoration: BoxDecoration(color: MyColors.blueColor.withOpacity(0.79), shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 29,
                                        color: MyColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
