import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';

class ShowPlanFull extends StatefulWidget {
  const ShowPlanFull(
      {super.key,
      required this.userModel,
      required this.domlar,
      required this.changeDom,
      required this.domKey,
      required this.firmaModel,
      this.planModel,
      this.ishchi,
      required this.ended,
      required this.canStart,
      required this.obyektModel});
  final UserModel userModel;
  final Map domlar;
  final String domKey;
  final Function changeDom;
  final FirmaModel firmaModel;
  final ObyektModel obyektModel;
  final PlanModel? planModel;
  final bool canStart;
  final bool ended;
  final IshchilarModel? ishchi;

  @override
  State<ShowPlanFull> createState() => _ShowPlanFullState();
}

class _ShowPlanFullState extends State<ShowPlanFull> {
  TextEditingController text2EditingController = TextEditingController();
  TextEditingController text3EditingController = TextEditingController();
  Map planMap = {
    'planUid': '',
    'obyekt': '',
    'obyektUid': '',
    'firma': '',
    'firmaUid': '',
    'planNomi': '',
    'startTime': '',
    'startTimeString': 'Vaqt tanlang',
    'endTime': '',
    'endTimeString': 'Vaqt tanlang',
    'startRealTime': '',
    'startTimeRealString': '',
    'endtRealTime': '',
    'endTimeRealString': '',
    'manager': {},
    'subContractor': {},
    'foreman': {},
    'numIshchilar': '0',
    'groups': {},
    'bino': '',
    'binoKey': ''
  };
  bool textInput = false;
  bool textDone = false;
  bool canEdit = false;
  List existingItems = [
    "Katlavan qazish",
    "Qoziq urish",
    "Armatura to'qish",
    "Beton quyish (Katlavan)",
    "Beton quyish (Podval)",
    "1 etaj armaturalarini to'qish",
    "1 etaj beton quyish",
    "1 etaj tomini yopish",
  ];
  bool edit = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.planModel == null) {
      canEdit = true;
      planMap['obyekt'] = widget.obyektModel.obyektNomi;
      planMap['obyektUid'] = widget.obyektModel.obyektUid;
      planMap['firma'] = widget.firmaModel.firmanomi;
      planMap['firmaUid'] = widget.firmaModel.firmauid;
      planMap['bino'] = widget.domlar[widget.domKey]['domname'];
      planMap['binoKey'] = widget.domKey;
    } else {
      planMap = widget.planModel!.toMap();
      textEditingController.text = planMap['planNomi'];
    }

    if (widget.ishchi == null || (widget.ishchi != null && !widget.ishchi!.dostup['Manager'])) {
      canEdit = false;
    }
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
                  padding: const EdgeInsets.only(top: 19.0, left: 19, right: 9, bottom: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("THURSDAY 25 MAY",
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 14, fontWeight: FontWeight.w600)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text("Reja",
                                    style: MyDecoration.textStyle
                                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          widget.domlar.isEmpty
                              ? Text('Binolar mavjud emas',
                                  style: MyDecoration.textStyle
                                      .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 19, fontWeight: FontWeight.w700))
                              : GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(widget.domlar[widget.domKey]['domname'],
                                          style: MyDecoration.textStyle
                                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 24, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 19),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: canEdit,
                          onChanged: (value) {
                            setState(() {
                              textInput = true;
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              textInput = false;
                              planMap['planNomi'] = textEditingController.text;
                              print(planMap['planNomi']);
                              FocusScope.of(context).unfocus();
                            });
                          },
                          controller: textEditingController,
                          smartQuotesType: SmartQuotesType.enabled,
                          autofocus: false,
                          decoration: MyDecoration.inputDecoration.copyWith(
                            labelText: "Reja nomi",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            planMap['planNomi'] = textEditingController.text;
                            textInput = false;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(left: 14),
                          decoration: MyDecoration.boxDecoration.copyWith(
                              color: textEditingController.text.isNotEmpty ? MyColors.blueColor.withOpacity(0.79) : MyColors.secondaryColor.withOpacity(0.49)),
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
                textEditingController.value.text.isEmpty ||
                        !textInput ||
                        existingItems
                            .where((element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                            .toList()
                            .isEmpty
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
                        decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.19)),
                        child: Column(
                          children: [
                            ...List.generate(
                                existingItems
                                    .where((element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                    .toList()
                                    .length, (index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        textEditingController.text = existingItems
                                            .where((element) => element.toString().toUpperCase().contains(textEditingController.value.text.toUpperCase()))
                                            .toList()[index];
                                        planMap['planNomi'] = textEditingController.text;
                                        textInput = false;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      child: Text(
                                          existingItems
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
                                            existingItems
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
                      ),
                Container(
                  decoration: MyDecoration.boxDecoration,
                  margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 39).copyWith(bottom: 9),
                  child: Column(
                    children: [
                      itemWidget(
                          leadingTxt: 'Boshlanish vaqti',
                          titleTxt: planMap['startTimeString'],
                          function: () {
                            if (canEdit) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: MyDecoration.boxDecoration
                                              .copyWith(color: MyColors.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
                                          height: 329,
                                          child: Stack(
                                            children: [
                                              CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode.date,
                                                  dateOrder: DatePickerDateOrder.ymd,
                                                  minimumDate: DateTime.now(),
                                                  use24hFormat: true,
                                                  onDateTimeChanged: (v) {
                                                    setState(() {
                                                      planMap['startTime'] = v;
                                                      planMap['startTimeString'] = DateFormat("dd.MM.yyyy").format(v);
                                                    });
                                                  }),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(9.0).copyWith(left: 14),
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: 29,
                                                        color: MyColors.secondaryColor.withOpacity(0.59),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (planMap['startTime'].runtimeType != DateTime) {
                                                        setState(() {
                                                          planMap['startTime'] = DateTime.now();
                                                          planMap['startTimeString'] = DateFormat("dd.MM.yyyy").format(DateTime.now());
                                                        });
                                                      }

                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(9.0).copyWith(right: 14),
                                                        child: Text(
                                                          "Tayyor",
                                                          style: MyDecoration.textStyle
                                                              .copyWith(height: 1, color: MyColors.blueColor.withOpacity(0.79), fontWeight: FontWeight.w400),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }),
                      Divider(
                        height: 1,
                        color: MyColors.secondaryColor.withOpacity(0.19),
                        thickness: 0.5,
                      ),
                      itemWidget(
                          leadingTxt: 'Tugash vaqti',
                          titleTxt: planMap['endTimeString'],
                          function: () {
                            if (canEdit) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: MyDecoration.boxDecoration
                                              .copyWith(color: MyColors.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
                                          height: 329,
                                          child: Stack(
                                            children: [
                                              CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode.date,
                                                  dateOrder: DatePickerDateOrder.ymd,
                                                  minimumDate: DateTime.now(),
                                                  use24hFormat: true,
                                                  onDateTimeChanged: (v) {
                                                    setState(() {
                                                      planMap['endTime'] = v;
                                                      planMap['endTimeString'] = DateFormat("dd.MM.yyyy").format(v);
                                                    });
                                                  }),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(9.0).copyWith(left: 14),
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: 29,
                                                        color: MyColors.secondaryColor.withOpacity(0.59),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (planMap['endTime'].runtimeType != DateTime) {
                                                        setState(() {
                                                          planMap['endTime'] = DateTime.now();
                                                          planMap['endTimeString'] = DateFormat("dd.MM.yyyy").format(DateTime.now());
                                                        });
                                                      }

                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(9.0).copyWith(right: 14),
                                                        child: Text(
                                                          "Tayyor",
                                                          style: MyDecoration.textStyle
                                                              .copyWith(height: 1, color: MyColors.blueColor.withOpacity(0.79), fontWeight: FontWeight.w400),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }),
                    ],
                  ),
                ),
                Container(
                  decoration: MyDecoration.boxDecoration.copyWith(),
                  margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                  child: Column(
                    children: [
                      itemWidget(
                          leadingTxt: 'Manager',
                          titleTxt: planMap['manager'].isEmpty
                              ? 'Mavjud emas'
                              : planMap['manager'].values.toList().toString().replaceAll('[', '').replaceAll(']', ''),
                          function: () async {
                            if (canEdit) {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 9),
                                              decoration: MyDecoration.boxDecoration,
                                              child: Column(
                                                children: [
                                                  ...List.generate(widget.firmaModel.ishchilar.length, (index) {
                                                    return Column(
                                                      children: [
                                                        index == 0
                                                            ? const SizedBox()
                                                            : Divider(
                                                                height: 1,
                                                                color: MyColors.secondaryColor.withOpacity(0.19),
                                                                thickness: 0.5,
                                                              ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (planMap['manager'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])) {
                                                                planMap['manager'].remove(widget.firmaModel.ishchilar.keys.toList()[index]);
                                                              } else {
                                                                planMap['manager'][widget.firmaModel.ishchilar.keys.toList()[index]] =
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'];
                                                              }
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(14.0),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets.only(right: 9),
                                                                    height: 22,
                                                                    width: 22,
                                                                    decoration: MyDecoration.circularBoxDecoration.copyWith(
                                                                        color: planMap['manager'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                            ? MyColors.blueColor.withOpacity(0.69)
                                                                            : Colors.transparent,
                                                                        border: Border.all(
                                                                            width: 1.5,
                                                                            color: MyColors.blueColor.withOpacity(planMap['manager']
                                                                                    .containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                                ? 0
                                                                                : 0.29))),
                                                                    child: planMap['manager'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                        ? const Center(
                                                                            child: Icon(
                                                                              Icons.check_rounded,
                                                                              color: MyColors.whiteColor,
                                                                              size: 19,
                                                                            ),
                                                                          )
                                                                        : const SizedBox()),
                                                                Expanded(
                                                                  child: Text(
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'],
                                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 29),
                                                padding: const EdgeInsets.all(14),
                                                decoration: MyDecoration.boxDecoration,
                                                child: Center(
                                                  child: Text(
                                                    "Saqlash",
                                                    style:
                                                        MyDecoration.textStyle.copyWith(height: 1, color: MyColors.blueColor.withOpacity(0.79), fontSize: 24),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }));
                              setState(() {});
                            }
                          }),
                      Divider(
                        height: 1,
                        color: MyColors.secondaryColor.withOpacity(0.19),
                        thickness: 0.5,
                      ),
                      itemWidget(
                          leadingTxt: 'SubContractor',
                          titleTxt: planMap['subContractor'].isEmpty
                              ? 'Mavjud emas'
                              : planMap['subContractor'].values.toList().toString().replaceAll('[', '').replaceAll(']', ''),
                          function: () async {
                            if (canEdit) {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 9),
                                              decoration: MyDecoration.boxDecoration,
                                              child: Column(
                                                children: [
                                                  ...List.generate(widget.firmaModel.ishchilar.length, (index) {
                                                    return Column(
                                                      children: [
                                                        index == 0
                                                            ? const SizedBox()
                                                            : Divider(
                                                                height: 1,
                                                                color: MyColors.secondaryColor.withOpacity(0.19),
                                                                thickness: 0.5,
                                                              ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (planMap['subContractor'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])) {
                                                                planMap['subContractor'].remove(widget.firmaModel.ishchilar.keys.toList()[index]);
                                                              } else {
                                                                planMap['subContractor'][widget.firmaModel.ishchilar.keys.toList()[index]] =
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'];
                                                              }
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(14.0),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets.only(right: 9),
                                                                    height: 22,
                                                                    width: 22,
                                                                    decoration: MyDecoration.circularBoxDecoration.copyWith(
                                                                        color: planMap['subContractor']
                                                                                .containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                            ? MyColors.blueColor.withOpacity(0.69)
                                                                            : Colors.transparent,
                                                                        border: Border.all(
                                                                            width: 1.5,
                                                                            color: MyColors.blueColor.withOpacity(planMap['subContractor']
                                                                                    .containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                                ? 0
                                                                                : 0.29))),
                                                                    child:
                                                                        planMap['subContractor'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                            ? const Center(
                                                                                child: Icon(
                                                                                  Icons.check_rounded,
                                                                                  color: MyColors.whiteColor,
                                                                                  size: 19,
                                                                                ),
                                                                              )
                                                                            : const SizedBox()),
                                                                Expanded(
                                                                  child: Text(
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'],
                                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 29),
                                                padding: const EdgeInsets.all(14),
                                                decoration: MyDecoration.boxDecoration,
                                                child: Center(
                                                  child: Text(
                                                    "Saqlash",
                                                    style:
                                                        MyDecoration.textStyle.copyWith(height: 1, color: MyColors.blueColor.withOpacity(0.79), fontSize: 24),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }));
                              setState(() {});
                            }
                          }),
                      Divider(
                        height: 1,
                        color: MyColors.secondaryColor.withOpacity(0.19),
                        thickness: 0.5,
                      ),
                      itemWidget(
                          leadingTxt: 'Foreman',
                          titleTxt: planMap['foreman'].isEmpty
                              ? 'Mavjud emas'
                              : planMap['foreman'].values.toList().toString().replaceAll('[', '').replaceAll(']', ''),
                          function: () async {
                            if (canEdit) {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 9),
                                              decoration: MyDecoration.boxDecoration,
                                              child: Column(
                                                children: [
                                                  ...List.generate(widget.firmaModel.ishchilar.length, (index) {
                                                    return Column(
                                                      children: [
                                                        index == 0
                                                            ? const SizedBox()
                                                            : Divider(
                                                                height: 1,
                                                                color: MyColors.secondaryColor.withOpacity(0.19),
                                                                thickness: 0.5,
                                                              ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (planMap['foreman'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])) {
                                                                planMap['foreman'].remove(widget.firmaModel.ishchilar.keys.toList()[index]);
                                                              } else {
                                                                planMap['foreman'][widget.firmaModel.ishchilar.keys.toList()[index]] =
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'];
                                                              }
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(14.0),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets.only(right: 9),
                                                                    height: 22,
                                                                    width: 22,
                                                                    decoration: MyDecoration.circularBoxDecoration.copyWith(
                                                                        color: planMap['foreman'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                            ? MyColors.blueColor.withOpacity(0.69)
                                                                            : Colors.transparent,
                                                                        border: Border.all(
                                                                            width: 1.5,
                                                                            color: MyColors.blueColor.withOpacity(planMap['foreman']
                                                                                    .containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                                ? 0
                                                                                : 0.29))),
                                                                    child: planMap['foreman'].containsKey(widget.firmaModel.ishchilar.keys.toList()[index])
                                                                        ? const Center(
                                                                            child: Icon(
                                                                              Icons.check_rounded,
                                                                              color: MyColors.whiteColor,
                                                                              size: 19,
                                                                            ),
                                                                          )
                                                                        : const SizedBox()),
                                                                Expanded(
                                                                  child: Text(
                                                                    widget.firmaModel.ishchilar.values.toList()[index]['name'],
                                                                    style: MyDecoration.textStyle.copyWith(height: 1, color: MyColors.secondaryColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 29),
                                                padding: const EdgeInsets.all(14),
                                                decoration: MyDecoration.boxDecoration,
                                                child: Center(
                                                  child: Text(
                                                    "Saqlash",
                                                    style:
                                                        MyDecoration.textStyle.copyWith(height: 1, color: MyColors.blueColor.withOpacity(0.79), fontSize: 24),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }));
                              setState(() {});
                            }
                          }),
                      Divider(
                        height: 1,
                        color: MyColors.secondaryColor.withOpacity(0.19),
                        thickness: 0.5,
                      ),
                      itemWidget(
                          leadingTxt: 'Jami ishchilar soni',
                          titleTxt: planMap['numIshchilar'],
                          function: () async {
                            if (canEdit) {
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
                                                controller: text2EditingController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration: MyDecoration.inputDecoration.copyWith(labelText: "Jami ishchilar soni ", suffixText: "(1 ta)"),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (text2EditingController.text.isNotEmpty) {
                                                  setState(() {
                                                    planMap['numIshchilar'] = text2EditingController.text;
                                                  });
                                                }

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
                                text2EditingController.text = '';
                              });
                            }
                          }),
                      ...List.generate(planMap['groups'].length, (index) {
                        return Column(
                          children: [
                            Divider(
                              height: 1,
                              color: MyColors.secondaryColor.withOpacity(0.19),
                              thickness: 0.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      edit
                                          ? Container(
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
                                            )
                                          : const SizedBox(),
                                      Text('Ishchi guruh ${index + 1}',
                                          style: MyDecoration.textStyle
                                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 17, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(planMap['groups'].values.toList()[index]['groupName'],
                                            textAlign: TextAlign.end,
                                            style: MyDecoration.textStyle
                                                .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 19, fontWeight: FontWeight.w500)),
                                        Text("${planMap['groups'].values.toList()[index]['ishchilar']} ishchi",
                                            style: MyDecoration.textStyle
                                                .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 15, fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      canEdit
                          ? Divider(
                              height: 1,
                              color: MyColors.secondaryColor.withOpacity(0.19),
                              thickness: 0.5,
                            )
                          : const SizedBox(),
                      canEdit
                          ? Container(
                              padding: const EdgeInsets.all(9.0),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () async {
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
                                                    controller: text2EditingController,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    autofocus: true,
                                                    decoration: MyDecoration.inputDecoration.copyWith(labelText: "Guruh nomi", suffixText: "(Quruvchilar)"),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                  child: TextFormField(
                                                    controller: text3EditingController,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    autofocus: false,
                                                    decoration:
                                                        MyDecoration.inputDecoration.copyWith(labelText: "Guruhdagi ishchilar soni ", suffixText: "(1 ta)"),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (text2EditingController.text.isNotEmpty && text3EditingController.text.isNotEmpty) {
                                                      setState(() {
                                                        planMap['groups'][planMap['groups'].length.toString()] = {
                                                          'groupName': text2EditingController.text,
                                                          'ishchilar': text3EditingController.text
                                                        };
                                                      });
                                                    }

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
                                  setState(() {
                                    text2EditingController.text = '';
                                    text3EditingController.text = '';
                                  });
                                },
                                child: Text("Ishchi guruh qo'shish",
                                    textAlign: TextAlign.center,
                                    style: MyDecoration.textStyle
                                        .copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 24, fontWeight: FontWeight.w500)),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                widget.planModel != null && (!widget.canStart && widget.planModel!.startTimeRealString.isEmpty) ||
                        widget.ended ||
                        widget.ishchi == null ||
                        (widget.ishchi != null && !widget.ishchi!.dostup['Manager'])
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (widget.planModel == null) {
                            String planUid = "plan${DateTime.now().millisecondsSinceEpoch}";
                            setState(() {
                              planMap['planUid'] = planUid;
                            });
                            FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('plan').update({planUid: planMap});
                          } else if (widget.canStart) {
                            setState(() {
                              planMap['startRealTime'] = DateTime.now();
                              planMap['startTimeRealString'] = DateFormat("dd.MM.yyyy").format(DateTime.now());
                            });
                            FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('plan').update({planMap['planUid']: planMap});
                          } else {
                            setState(() {
                              planMap['endRealTime'] = DateTime.now();
                              planMap['endTimeRealString'] = DateFormat("dd.MM.yyyy").format(DateTime.now());
                            });
                            FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('plan').update({planMap['planUid']: planMap});
                          }

                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 29),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.99)),
                          child: Center(
                            child: Text(
                              widget.planModel == null
                                  ? "Rejani yaratish"
                                  : widget.canStart
                                      ? "Boshlash"
                                      : 'Tugatish',
                              style: MyDecoration.textStyle,
                            ),
                          ),
                        ),
                      ),
                widget.planModel == null || widget.ishchi == null || (widget.ishchi != null && !widget.ishchi!.dostup['Manager'])
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 39),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: MyDecoration.boxDecoration.copyWith(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Text(
                              "Rejani o'chirish",
                              style: MyDecoration.textStyle.copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: AdminTop(),
          )
        ],
      ),
    );
  }

  Widget itemWidget({required String leadingTxt, required String titleTxt, required Function function}) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              edit
                  ? Container(
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
                    )
                  : const SizedBox(),
              Text(leadingTxt,
                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 17, fontWeight: FontWeight.w400)),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                function();
              },
              child: Text(titleTxt,
                  textAlign: TextAlign.end,
                  style: MyDecoration.textStyle.copyWith(
                      color: MyColors.secondaryColor.withOpacity(titleTxt == 'Mavjud emas' ? 0.49 : 0.99), fontSize: 19, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
