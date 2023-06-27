import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/service/sendmsg.dart';

class AdminAddOrder extends StatefulWidget {
  const AdminAddOrder({super.key, required this.firmaModel, required this.userModel, required this.obyektModel});
  final FirmaModel firmaModel;
  final UserModel userModel;
  final ObyektModel obyektModel;
  @override
  State<AdminAddOrder> createState() => _AdminAddOrderState();
}

class _AdminAddOrderState extends State<AdminAddOrder> {
  List measures = ["dona", 'tonna', "kg", "litr", 'km', 'metr', 'sm', 'sm.kv', 'm.kv', 'km.kv', 'm.kub', 'km.kub'];
  int? measureIndex;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController text2EditingController = TextEditingController();
  int? selectedIndex;
  bool edit = false;

  Map addedItems = {};
  Map existingItems = {};
  Map existingItemsType = {};

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').get().then((value) {
      for (var item in value.data()!.values.toList()) {
        existingItemsType["${existingItems.length}"] = item['type'];
        existingItems["${existingItems.length}"] = item['uz'];

        // existingItems.add(item['oz']);
        // existingItems.add(item['ru']);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: MyColors.blueColor.withOpacity(0.79),
                            ),
                            Text("Orqaga",
                                style:
                                    MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 19, fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        child: Text(edit ? "Tayyor" : "O'zgartirish",
                            style: MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 18, fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                ),
                addedItems.isEmpty
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
                        decoration: MyDecoration.boxDecoration,
                        child: Column(
                          children: [
                            ...List.generate(addedItems.length, (index) {
                              return contrItem(
                                  addedItems.values.toList()[index]['data'], addedItems.values.toList()[index]['num'], addedItems.length - 1 != index, edit,
                                  () {
                                setState(() {
                                  addedItems.remove(addedItems.keys.toList()[index]);
                                });
                              }, addedItems.values.toList()[index]['measure']);
                            }),
                          ],
                        ),
                      ),
                addedItems.isEmpty ? const SizedBox() : Divider(height: 29, thickness: 0.5, color: MyColors.secondaryColor.withOpacity(0.29)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 19),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: textEditingController,
                          smartQuotesType: SmartQuotesType.enabled,
                          autofocus: false,
                          decoration: MyDecoration.inputDecoration.copyWith(
                            labelText: "Uskuna yoki Mahsulot nomi",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          List typeList = existingItems.keys
                              .toList()
                              .where((key) => existingItems[key].toString().toUpperCase() == textEditingController.value.text.toUpperCase())
                              .toList();
                          if (typeList.isNotEmpty) {
                            setState(() {
                              String typekey = typeList.first;
                              selectedIndex = existingItemsType[typekey] == 'mahsulot' ? 1 : 0;
                            });
                          }
                          await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                    return Container(
                                      decoration: MyDecoration.boxDecoration
                                          .copyWith(color: MyColors.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
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
                                            selectedIndex == null
                                                ? Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                                    child: Text(
                                                      "Kiritilgan ma'lumot bazada mavjud emas. Shu sabab Mahsulot yoki Uskunadan birini tanlang.",
                                                      textAlign: TextAlign.center,
                                                      style: MyDecoration.textStyle.copyWith(color: Colors.red.withOpacity(0.79), fontSize: 16),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            selectedIndex == null
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback.lightImpact();
                                                            setState(
                                                              () {
                                                                selectedIndex = 0;
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7).copyWith(right: 14),
                                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                                            decoration: MyDecoration.boxDecoration
                                                                .copyWith(color: selectedIndex == 0 ? Colors.deepPurple : MyColors.whiteColor),
                                                            child: Center(
                                                              child: Text(
                                                                "Uskuna",
                                                                style: MyDecoration.textStyle
                                                                    .copyWith(color: selectedIndex == 0 ? MyColors.whiteColor : MyColors.secondaryColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback.lightImpact();
                                                            setState(
                                                              () {
                                                                selectedIndex = 1;
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                                            decoration: MyDecoration.boxDecoration
                                                                .copyWith(color: selectedIndex == 1 ? Colors.deepPurple : MyColors.whiteColor),
                                                            child: Center(
                                                              child: Text(
                                                                "Mahsulot",
                                                                style: MyDecoration.textStyle
                                                                    .copyWith(color: selectedIndex == 1 ? MyColors.whiteColor : MyColors.secondaryColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: text2EditingController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration: MyDecoration.inputDecoration.copyWith(labelText: "Hajmi ", suffixText: "(1, 10, 100)"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 59,
                                              child: Center(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      ...List.generate(measures.length, (index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              measureIndex = index;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.only(left: 9),
                                                            padding: const EdgeInsets.symmetric(horizontal: 14),
                                                            height: 39,
                                                            decoration: MyDecoration.boxDecoration
                                                                .copyWith(color: measureIndex == index ? Colors.deepPurple : MyColors.whiteColor),
                                                            child: Center(
                                                              child: Text(
                                                                measures[index],
                                                                style: MyDecoration.textStyle.copyWith(
                                                                    color: measureIndex == index
                                                                        ? MyColors.whiteColor
                                                                        : MyColors.secondaryColor.withOpacity(0.99)),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (text2EditingController.text.isNotEmpty && measureIndex != null) {
                                                  setState(() {
                                                    addedItems[addedItems.entries.length.toString()] = {
                                                      'data': textEditingController.value.text,
                                                      'num': text2EditingController.value.text,
                                                      'done': false,
                                                      'type': selectedIndex == 1 ? 'mahsulot' : 'uskuna',
                                                      'measure': measures[measureIndex!]
                                                    };
                                                    textEditingController.text = '';
                                                    text2EditingController.text = '';
                                                  });
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                }
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
                                  }));
                          setState(() {
                            measureIndex = null;
                            selectedIndex = null;
                            textEditingController.text = '';
                            text2EditingController.text = '';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(left: 14),
                          decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.49)),
                          child: Center(
                            child: Icon(
                              Icons.done_rounded,
                              color: MyColors.whiteColor.withOpacity(0.99),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                textEditingController.value.text.isEmpty
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
                        decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.19)),
                        child: Column(
                          children: [
                            ...List.generate(
                                existingItems.values
                                    .toList()
                                    .where((element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                    .toList()
                                    .length, (index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      String typekey = existingItems.keys
                                          .toList()
                                          .where((key) => existingItems[key].toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                          .toList()[index];

                                      setState(() {
                                        textEditingController.text = existingItems[typekey];

                                        selectedIndex = existingItemsType[typekey] == 'mahsulot' ? 1 : 0;
                                      });

                                      await showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (_) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                return Container(
                                                  decoration: MyDecoration.boxDecoration
                                                      .copyWith(color: MyColors.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
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
                                                            keyboardType: TextInputType.number,
                                                            controller: text2EditingController,
                                                            onChanged: (value) {
                                                              setState(() {});
                                                            },
                                                            autofocus: true,
                                                            decoration: MyDecoration.inputDecoration.copyWith(labelText: "Hajmi ", suffixText: "(1, 10, 100)"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 59,
                                                          child: Center(
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  ...List.generate(measures.length, (index) {
                                                                    return GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          measureIndex = index;
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(left: 9),
                                                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                                                        height: 39,
                                                                        decoration: MyDecoration.boxDecoration
                                                                            .copyWith(color: measureIndex == index ? Colors.deepPurple : MyColors.whiteColor),
                                                                        child: Center(
                                                                          child: Text(
                                                                            measures[index],
                                                                            style: MyDecoration.textStyle.copyWith(
                                                                                color: measureIndex == index
                                                                                    ? MyColors.whiteColor
                                                                                    : MyColors.secondaryColor.withOpacity(0.99)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (text2EditingController.text.isNotEmpty && measureIndex != null) {
                                                              setState(() {
                                                                addedItems[addedItems.entries.length.toString()] = {
                                                                  'data': textEditingController.value.text,
                                                                  'num': text2EditingController.value.text,
                                                                  'done': false,
                                                                  'type': selectedIndex == 1
                                                                      ? 'mahsulot'
                                                                      : selectedIndex == 0
                                                                          ? 'uskuna'
                                                                          : '',
                                                                  'measure': measures[measureIndex!]
                                                                };
                                                              });

                                                              Navigator.pop(context);
                                                              FocusScope.of(context).unfocus();
                                                            }
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
                                              }));
                                      setState(() {
                                        selectedIndex = null;
                                        measureIndex = null;
                                        textEditingController.text = '';
                                        text2EditingController.text = '';
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      child: Text(
                                          existingItems.values
                                              .toList()
                                              .where((element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                              .toList()[index],
                                          style: MyDecoration.textStyle.copyWith(
                                              color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, height: 1, fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: index !=
                                            existingItems.values
                                                    .toList()
                                                    .where(
                                                        (element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                                    .toList()
                                                    .length -
                                                1
                                        ? MyColors.secondaryColor.withOpacity(0.29)
                                        : Colors.transparent,
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                    child: GestureDetector(
                      onTap: () async {
                        String body = "";

                        for (var item in addedItems.values) {
                          if (addedItems.values.toList().indexOf(item) == 0) {
                            body = "${item['data']}";
                          } else {
                            body = "$body, ${item['data']}";
                          }
                        }

                        if (body.isNotEmpty) {
                          String orderUid = "order${DateTime.now().millisecondsSinceEpoch}";

                          Map myMap = {
                            'data': {
                              DateTime.now().microsecondsSinceEpoch.toString(): {'items': addedItems, 'docs': {}, 'firma': '', 'narx': ''}
                            },
                            'createdBy': widget.userModel.name,
                            'createdByUid': widget.userModel.uid,
                            'obyekt': widget.obyektModel.obyektNomi,
                            'obyektUid': widget.obyektModel.obyektUid,
                            'firma': widget.firmaModel.firmanomi,
                            'firmaUid': widget.firmaModel.firmauid,
                            'orderUid': orderUid,
                            'confirmedDocs': false,
                            'confirmedToBuy': false,
                            'createdTime': DateTime.now(),
                            'createdTimeString': DateFormat('dd.MM.yyyy').format(DateTime.now())
                          };
                          FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('wallet').update({orderUid: myMap});

                          SendMsg().sendMessage(widget.obyektModel.obyektNomi, body, widget.firmaModel.director);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).viewPadding.bottom > 19 ? 45 + MediaQuery.of(context).viewPadding.bottom : 59,
                        width: double.maxFinite,
                        decoration: MyDecoration.boxDecoration
                            .copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(0)), color: MyColors.bgColor.withOpacity(0.59)),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Yuborish",
                            style: MyDecoration.textStyle.copyWith(color: Colors.deepPurple, fontSize: 29, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }
}

Widget contrItem(String title, String sub, bool showDivider, bool edit, Function editFunction, String measure) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                edit
                    ? GestureDetector(
                        onTap: () {
                          editFunction();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 9),
                          height: 24,
                          width: 24,
                          decoration: MyDecoration.circularBoxDecoration.copyWith(color: Colors.red),
                          child: Center(
                            child: Icon(
                              Icons.remove_rounded,
                              color: MyColors.whiteColor.withOpacity(0.99),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Text(title,
                    style: MyDecoration.textStyle
                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, height: 1, fontWeight: FontWeight.w500)),
              ],
            ),
            Text("$sub $measure",
                style: MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.69), fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      Divider(
        height: 1,
        thickness: 0.5,
        color: showDivider ? MyColors.secondaryColor.withOpacity(0.19) : Colors.transparent,
      ),
    ],
  );
}
