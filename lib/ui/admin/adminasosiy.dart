import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/selectobyekt.dart';
import 'package:mybuilding/ui/charts/barchart.dart';
import 'package:mybuilding/ui/xabarlar.dart';

class AdminAsosy extends StatefulWidget {
  const AdminAsosy(
      {super.key,
      required this.userModel,
      required this.firmaModel,
      required this.obyektModel,
      required this.changeDom,
      required this.firmaxabarlar,
      required this.ombor,
      this.changeObyekt,
      required this.numberOfActiveXabarlar});
  final UserModel userModel;
  final FirmaModel firmaModel;
  final ObyektModel? obyektModel;
  final Map<String, OmborModel> ombor;

  final Function changeDom;
  final Map<String, FirmaXabarlar> firmaxabarlar;
  final int numberOfActiveXabarlar;
  final Function? changeObyekt;
  @override
  State<AdminAsosy> createState() => _AdminAsosyState();
}

class _AdminAsosyState extends State<AdminAsosy> {
  Map uskunalar = {};
  Map mahsulotlar = {};
  Map obyektlar = {};
  @override
  void initState() {
    super.initState();
    if (widget.userModel.type == 'director') {
      obyektlar = widget.firmaModel.obyektlar;
    } else {
      for (var item in widget.userModel.obyektlar) {
        obyektlar[item] = widget.firmaModel.obyektlar[item];
      }
    }
    // uskuna va mahsulotlar
    uskunalar = {};
    mahsulotlar = {};
    for (OmborModel model in widget.ombor.values) {
      if (model.type == 'uskuna') {
        if (uskunalar.containsKey(model.name)) {
          uskunalar[model.name]['items'].add(model.itemUid);
        } else {
          uskunalar[model.name] = {'total': '', 'totalforchart': 0.0, 'items': []};
          uskunalar[model.name]['items'].add(model.itemUid);
        }
      } else {
        if (mahsulotlar.containsKey(model.name)) {
          mahsulotlar[model.name]['items'].add(model.itemUid);
        } else {
          mahsulotlar[model.name] = {'total': '', 'totalforchart': 0.0, 'items': []};
          mahsulotlar[model.name]['items'].add(model.itemUid);
        }
      }
    }
    ////
    /////total uskunalar
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
      uskunalar[key]['totalforchart'] = sum;
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
      mahsulotlar[key]['totalforchart'] = sum;
    }
  }

  @override
  void didUpdateWidget(covariant AdminAsosy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userModel.type == 'director') {
      obyektlar = widget.firmaModel.obyektlar;
    } else {
      for (var item in widget.userModel.obyektlar) {
        obyektlar[item] = widget.firmaModel.obyektlar[item];
      }
    }
    // uskuna va mahsulotlar
    uskunalar = {};
    mahsulotlar = {};
    for (OmborModel model in widget.ombor.values) {
      if (model.type == 'uskuna') {
        if (uskunalar.containsKey(model.name)) {
          uskunalar[model.name]['items'].add(model.itemUid);
        } else {
          uskunalar[model.name] = {'total': '', 'totalforchart': 0.0, 'items': []};
          uskunalar[model.name]['items'].add(model.itemUid);
        }
      } else {
        if (mahsulotlar.containsKey(model.name)) {
          mahsulotlar[model.name]['items'].add(model.itemUid);
        } else {
          mahsulotlar[model.name] = {'total': '', 'totalforchart': 0.0, 'items': []};
          mahsulotlar[model.name]['items'].add(model.itemUid);
        }
      }
    }
    ////
    /////total uskunalar
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
      uskunalar[key]['totalforchart'] = sum;
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
      mahsulotlar[key]['totalforchart'] = sum;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0, left: 19, right: 19, bottom: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        enableDrag: false,
                        backgroundColor: const Color.fromARGB(0, 14, 11, 11),
                        builder: (context) {
                          return SelectObyekt(
                            obyekts: obyektlar,
                            changeObyekt: widget.changeObyekt!,
                          );
                        });
                  },
                  child: Text(widget.obyektModel!.obyektNomi,
                      style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Xabarlar(
                        userModel: widget.userModel,
                        firmaxabarlar: widget.userModel.type == 'director' ? widget.firmaxabarlar : {},
                        firmaModel: widget.firmaModel,
                      );
                    }));
                  },
                  child: Badge(
                    label: Text(widget.numberOfActiveXabarlar.toString()),
                    isLabelVisible: widget.numberOfActiveXabarlar != 0,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.notifications_rounded,
                      color: MyColors.secondaryColor.withOpacity(0.69),
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(9).copyWith(top: 0),
            margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
            width: double.maxFinite,
            decoration: MyDecoration.boxDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BUGUNDA",
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 15, fontWeight: FontWeight.w700)),
                      Text("Uskunalar Statistikasi",
                          style: MyDecoration.textStyle
                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, fontWeight: FontWeight.w700, height: 1)),
                    ],
                  ),
                ),
                BarChart(
                  map: uskunalar,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(9).copyWith(top: 0),
            margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
            width: double.maxFinite,
            decoration: MyDecoration.boxDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BUGUNDA",
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 15, fontWeight: FontWeight.w700)),
                      Text("Mahsulotlar Statistikasi",
                          style: MyDecoration.textStyle
                              .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, fontWeight: FontWeight.w700, height: 1)),
                    ],
                  ),
                ),
                BarChart(
                  map: mahsulotlar,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + 69,
          ),
        ],
      ),
    );
  }
}
