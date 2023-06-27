import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/adminasosiy.dart';
import 'package:mybuilding/ui/admin/adminbottom.dart';
import 'package:mybuilding/ui/admin/order/adminfond.dart';
import 'package:mybuilding/ui/admin/plan/adminplan.dart';
import 'package:mybuilding/ui/admin/adminproducts.dart';
import 'package:mybuilding/ui/admin/profile/adminprofile.dart';
import 'package:mybuilding/ui/admin/admintop.dart';

class AdminHome extends StatefulWidget {
  const AdminHome(
      {super.key,
      required this.userModel,
      required this.firmaModel,
      this.obyektModel,
      this.ishchilar,
      this.changeObyekt,
      this.ishchi,
      required this.firmaxabarlar,
      this.plans,
      this.ombor,
      this.orders});
  final UserModel userModel;
  final FirmaModel firmaModel;
  final ObyektModel? obyektModel;
  final List<WalletModel>? orders;
  final Map<String, FirmaXabarlar> firmaxabarlar;
  final List<IshchilarModel>? ishchilar;
  final Function? changeObyekt;
  final List<PlanModel>? plans;
  final IshchilarModel? ishchi;
  final Map<String, OmborModel>? ombor;

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int uiIndex = 0;
  String obyektKey = '';
  Map domlar = {};

  bool loading = true;

  String domKey = '';

  changeUI(int newIndex) {
    setState(() {
      uiIndex = newIndex;
    });
  }

  changeDom(String key) {
    setState(() {
      domKey = key;
    });
  }

  getData() async {
    var dmlar = await FirebaseFirestore.instance.collection(widget.obyektModel!.obyektUid).doc('domlar').get();
    if (dmlar.exists) {
      domlar = dmlar.data()!;
      domKey = domlar.keys.toList()[0];
      loading = false;
      setState(() {});
      print('read');
    }
  }

  @override
  void initState() {
    super.initState();

    if ((widget.userModel.type == "director" && widget.firmaModel.obyektlar.isEmpty) ||
        (widget.userModel.type != "director" && widget.userModel.obyektlar.isEmpty)) {
      uiIndex = 3;
      obyektKey = widget.obyektModel!.obyektUid;
    }
    getData();
  }

  @override
  void didUpdateWidget(covariant AdminHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (obyektKey != widget.obyektModel!.obyektUid) {
      getData();
      obyektKey = widget.obyektModel!.obyektUid;
    }
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
                IndexedStack(
                  index: uiIndex,
                  sizing: StackFit.expand,
                  children: [
                    AdminAsosy(
                      userModel: widget.userModel,
                      firmaModel: widget.firmaModel,
                      obyektModel: widget.obyektModel,
                      ombor: widget.ombor ?? {},
                      changeDom: changeDom,
                      firmaxabarlar: widget.firmaxabarlar,
                      numberOfActiveXabarlar: widget.firmaxabarlar.values.where((element) => element.isActive).length,
                      changeObyekt: widget.changeObyekt,
                    ),
                    AdminProducts(
                      userModel: widget.userModel,
                      ombor: widget.ombor ?? {},
                    ),
                    AdminFond(
                      firmaModel: widget.firmaModel,
                      userModel: widget.userModel,
                      obyektModel: widget.obyektModel!,
                      orders: widget.orders ?? [],
                      ishchi: widget.ishchi,
                    ),
                    AdminPersonal(
                      userModel: widget.userModel,
                      firmaModel: widget.firmaModel,
                      ishchilar: widget.ishchilar ?? [],
                    ),
                    AdminPlan(
                      userModel: widget.userModel,
                      domlar: domlar,
                      domKey: domKey,
                      changeDom: changeDom,
                      firmaModel: widget.firmaModel,
                      obyektModel: widget.obyektModel!,
                      plans: widget.plans == null ? [] : widget.plans!.where((element) => element.binoKey == domKey).toList(),
                      ishchi: widget.ishchi,
                    )
                  ],
                ),
                widget.userModel.type == "director" && widget.firmaModel.obyektlar.isEmpty
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: AdminBottom(
                          changeUI: changeUI,
                          uiIndex: uiIndex,
                        ),
                      ),
                uiIndex == 1
                    ? const SizedBox()
                    : const Align(
                        alignment: Alignment.topCenter,
                        child: AdminTop(),
                      )
              ],
            ),
    );
  }
}
