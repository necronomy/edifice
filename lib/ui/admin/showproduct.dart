import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/obyektmodel.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key, required this.ombor, required this.itemUids, required this.name, required this.total});
  final Map<String, OmborModel> ombor;
  final List itemUids;
  final String name;
  final String total;

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  Map items = {};
  @override
  void initState() {
    super.initState();
    for (var itemUid in widget.itemUids) {
      if (items.containsKey(widget.ombor[itemUid]!.createdTimeString)) {
        items[widget.ombor[itemUid]!.createdTimeString].add(itemUid);
      } else {
        items[widget.ombor[itemUid]!.createdTimeString] = [];
        items[widget.ombor[itemUid]!.createdTimeString].add(itemUid);
      }
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
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 69,
              ),
              ...List.generate(items.length, (ind) {
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                    margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 0).copyWith(bottom: 19),
                    width: double.maxFinite,
                    decoration: MyDecoration.boxDecoration,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0).copyWith(top: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(items.keys.toList()[ind] == DateFormat("dd.MM.yyyy").format(DateTime.now()) ? "BUGUNDA" : items.keys.toList()[ind],
                                  style: MyDecoration.textStyle
                                      .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 17, fontWeight: FontWeight.w700)),
                              // Icon(
                              //   Icons.list_rounded,
                              //   color: MyColors.secondaryColor.withOpacity(0.59),
                              //   size: 39,
                              // )
                            ],
                          ),
                        ),
                        ...List.generate(
                            items.values.toList()[ind].length,
                            (index) => itemWidget(
                                done: widget.ombor[items.values.toList()[ind][index]]!.done,
                                title: widget.ombor[items.values.toList()[ind][index]]!.createdBy,
                                txt: "Ishchi",
                                measure: widget.ombor[items.values.toList()[ind][index]]!.measure,
                                lastText: widget.ombor[items.values.toList()[ind][index]]!.hajmi,
                                showDivider: index == items.values.toList()[ind].length - 1 ? false : true))
                      ],
                    ));
              }),
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom,
              ),
            ]),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    height: MediaQuery.of(context).viewPadding.top + 39,
                    width: double.maxFinite,
                    decoration: MyDecoration.boxDecoration
                        .copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), color: MyColors.bgColor.withOpacity(0.59)),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: MyColors.blueColor,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(widget.name,
                              style: MyDecoration.textStyle
                                  .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), height: 1, fontSize: 25, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

Widget itemWidget(
    {required bool done, required String title, required String txt, required String lastText, required bool showDivider, required String measure}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  padding: const EdgeInsets.all(3),
                  decoration: MyDecoration.boxDecoration.copyWith(
                    color: done ? Colors.green.withOpacity(0.19) : Colors.amber.withOpacity(0.19),
                    boxShadow: const [BoxShadow(color: MyColors.bgColor, blurRadius: 9, spreadRadius: 3)],
                  ),
                  child: Center(
                    child: Icon(
                      done ? Icons.check_rounded : Icons.warning_rounded,
                      size: 29,
                      color: done ? Colors.green.withOpacity(0.99) : Colors.amber.withOpacity(0.99),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$title ',
                          style: MyDecoration.textStyle
                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 16, height: 1, fontWeight: FontWeight.w600)),
                      Text(txt,
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 15, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text("+$lastText $measure",
                style: MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.69), fontSize: 18, fontWeight: FontWeight.w500)),
          )
        ],
      ),
      Divider(
        height: 1,
        indent: 57,
        thickness: 0.5,
        color: showDivider ? MyColors.secondaryColor.withOpacity(0.19) : Colors.transparent,
      ),
    ],
  );
}
