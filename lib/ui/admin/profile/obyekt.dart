import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Obyekt extends StatefulWidget {
  const Obyekt({super.key, required this.firmaModel, required this.userModel, required this.obyektModel});
  final UserModel userModel;
  final FirmaModel firmaModel;
  final ObyektModel obyektModel;
  @override
  State<Obyekt> createState() => _ObyektState();
}

class _ObyektState extends State<Obyekt> {
  Map domlar = {};
  bool loading = true;
  TextEditingController domnomiController = TextEditingController();
  TextEditingController etajController = TextEditingController();
  TextEditingController xonadonlarController = TextEditingController();
  TextEditingController podyezdController = TextEditingController();

  getData() async {
    var dmlar = await FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('domlar').get();
    if (dmlar.exists) {
      domlar = dmlar.data()!;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: loading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.deepPurple,
                size: 99.0,
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 19, right: 19),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: Text(widget.obyektModel.obyektNomi,
                                style: MyDecoration.textStyle
                                    .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                      width: double.maxFinite,
                      decoration: MyDecoration.boxDecoration,
                      child: Column(
                        children: [
                          ...List.generate(domlar.length, (index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                          child: Text(domlar.values.toList()[index]['domname'],
                                              style: MyDecoration.textStyle
                                                  .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 21, fontWeight: FontWeight.normal)),
                                        ),
                                        Row(
                                          children: [
                                            Text(domlar.values.toList()[index]['dometaj'],
                                                style: MyDecoration.textStyle
                                                    .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 18, fontWeight: FontWeight.w400)),
                                            Icon(
                                              Icons.keyboard_arrow_right_rounded,
                                              color: MyColors.secondaryColor.withOpacity(0.29),
                                              size: 27,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  indent: 0,
                                  thickness: 0.5,
                                  color: MyColors.secondaryColor.withOpacity(0.19),
                                ),
                              ],
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
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
                                                controller: domnomiController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration:
                                                    MyDecoration.inputDecoration.copyWith(labelText: "Bino raqami yoki nomi", suffixText: "(Bino 1, Bino 2)"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: etajController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration: MyDecoration.inputDecoration.copyWith(labelText: "Bino etaj", suffixText: "(10, 20)"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: podyezdController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration: MyDecoration.inputDecoration.copyWith(labelText: "Kirishlar soni", suffixText: "(5, 15)"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: xonadonlarController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                autofocus: true,
                                                decoration: MyDecoration.inputDecoration.copyWith(labelText: "Xonadonlar soni", suffixText: "(100, 200)"),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (domlar.containsKey('dom0')) {
                                                  FirebaseFirestore.instance
                                                      .collection(widget.obyektModel.obyektUid)
                                                      .doc('domlar')
                                                      .update({'dom0': FieldValue.delete()});

                                                  FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('domlar').update({
                                                    'dom1': {
                                                      'domname': domnomiController.value.text,
                                                      'dometaj': "${etajController.value.text} etaj",
                                                      'domxonadonlar': "${xonadonlarController.value.text} ta",
                                                      'dompodyezd': "${podyezdController.value.text} ta",
                                                    }
                                                  });
                                                } else {
                                                  FirebaseFirestore.instance.collection(widget.obyektModel.obyektUid).doc('domlar').update({
                                                    (domlar.entries.length + 1).toString(): {
                                                      'domname': domnomiController.value.text,
                                                      'dometaj': "${etajController.value.text} etaj",
                                                      'domxonadonlar': "${xonadonlarController.value.text} ta",
                                                      'dompodyezd': "${podyezdController.value.text} ta",
                                                    }
                                                  });
                                                }

                                                setState(() {
                                                  domnomiController.text = '';
                                                  etajController.text = '';
                                                  xonadonlarController.text = '';
                                                  podyezdController.text = '';
                                                });
                                                getData();

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
                                              duration: const Duration(milliseconds: 100),
                                              height: MediaQuery.of(context).viewInsets.bottom,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                                        decoration: MyDecoration.boxDecoration.copyWith(
                                          color: MyColors.blueColor.withOpacity(0.79),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: MyColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                      Text("Bino qo'shish",
                                          style: MyDecoration.textStyle
                                              .copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 21, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: MyColors.secondaryColor.withOpacity(0.29),
                                    size: 27,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: AdminTop(),
                )
              ],
            ),
    );
  }
}
