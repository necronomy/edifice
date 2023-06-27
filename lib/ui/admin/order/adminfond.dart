import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/ui/admin/order/adminaddorder.dart';
import 'package:mybuilding/ui/admin/order/adminshoworder.dart';

import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/usermodel.dart';

class AdminFond extends StatefulWidget {
  const AdminFond({super.key, required this.firmaModel, required this.userModel, required this.obyektModel, required this.orders, this.ishchi});
  final FirmaModel firmaModel;
  final UserModel userModel;
  final ObyektModel obyektModel;
  final List<WalletModel> orders;
  final IshchilarModel? ishchi;

  @override
  State<AdminFond> createState() => _AdminFondState();
}

class _AdminFondState extends State<AdminFond> {
  List topList = ["So'rovlar", "Tasdiqlandi", "Shartnomalar", "Qabul qilindi"];
  Map confirmedForFour = {};
  Map<String, List<WalletModel>> sorovlar = {"0": [], "1": [], "2": [], "3": []};
  List<WalletModel> thisOrders = [];
  int selectedIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    sorovlar = {"0": [], "1": [], "2": [], "3": []};
    confirmedForFour = {};
    thisOrders = widget.orders.reversed.toList();
    thisOrders.forEach((element) {
      if (element.confirmedDocs && element.confirmedToBuy) {
        if (element.data.values.toList().any((item) => checkForFour(item['items'].values.toList()))) {
          confirmedForFour[element.orderUid] = {};
          confirmedForFour[element.orderUid]['done'] = 0;
          confirmedForFour[element.orderUid]['total'] = 0;
          for (var item in element.data.values.toList()) {
            getDones(item['items'].values.toList(), element.orderUid);
          }

          sorovlar['3']!.add(element);
        } else {
          sorovlar['2']!.add(element);
        }
      } else if (!element.confirmedDocs && element.confirmedToBuy) {
        sorovlar['1']!.add(element);
      } else {
        sorovlar['0']!.add(element);
      }
    });
  }

  @override
  void didUpdateWidget(covariant AdminFond oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    sorovlar = {"0": [], "1": [], "2": [], "3": []};
    confirmedForFour = {};
    thisOrders = widget.orders.reversed.toList();
    thisOrders.forEach((element) {
      if (element.confirmedDocs && element.confirmedToBuy) {
        if (element.data.values.toList().any((item) => checkForFour(item['items'].values.toList()))) {
          confirmedForFour[element.orderUid] = {};
          confirmedForFour[element.orderUid]['done'] = 0;
          confirmedForFour[element.orderUid]['total'] = 0;
          for (var item in element.data.values.toList()) {
            getDones(item['items'].values.toList(), element.orderUid);
          }

          sorovlar['3']!.add(element);
        } else {
          sorovlar['2']!.add(element);
        }
      } else if (!element.confirmedDocs && element.confirmedToBuy) {
        sorovlar['1']!.add(element);
      } else {
        sorovlar['0']!.add(element);
      }
    });
  }

  bool checkForFour(List items) {
    if (items.any((element) => element['done'])) return true;

    return false;
  }

  getDones(List items, String orderKey) {
    confirmedForFour[orderKey]['total'] = confirmedForFour[orderKey]['total'] + items.length;

    for (var element in items) {
      if (element['done']) {
        confirmedForFour[orderKey]['done'] = confirmedForFour[orderKey]['done'] + 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            ...List.generate(topList.length, (ind) {
              return ind != 0 && sorovlar[ind.toString()]!.isEmpty
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0, left: 19, right: 19, bottom: 9),
                          child: Row(
                            children: [
                              Text(topList[ind],
                                  style: MyDecoration.textStyle.copyWith(
                                      color: MyColors.secondaryColor.withOpacity(sorovlar[ind.toString()]!.isEmpty ? 0.59 : 0.99),
                                      fontSize: sorovlar[ind.toString()]!.isEmpty ? 29 : 37,
                                      fontWeight: sorovlar[ind.toString()]!.isEmpty ? FontWeight.w700 : FontWeight.w700)),
                              ind == 0 && widget.ishchi != null && widget.ishchi!.dostup['Foreman']
                                  ? GestureDetector(
                                      onTap: () async {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return AdminAddOrder(
                                            firmaModel: widget.firmaModel,
                                            userModel: widget.userModel,
                                            obyektModel: widget.obyektModel,
                                          );
                                        }));
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
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        ...List.generate(
                            sorovlar[ind.toString()]!.length,
                            (index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return AdminShowOrder(
                                      order: sorovlar[ind.toString()]![index],
                                      dostup: widget.ishchi != null ? widget.ishchi!.dostup : {},
                                      userModel: widget.userModel,
                                    );
                                  }));
                                },
                                child: itemWidget(
                                    ind: ind,
                                    txt: sorovlar[ind.toString()]![index].createdBy,
                                    title: "Zayavka ${widget.orders.indexOf(sorovlar[ind.toString()]![index]) + 1}",
                                    time: sorovlar[ind.toString()]![index].createdTimeString,
                                    total: ind == 3 && confirmedForFour.containsKey(sorovlar[ind.toString()]![index].orderUid)
                                        ? confirmedForFour[sorovlar[ind.toString()]![index].orderUid]['total']
                                        : 0,
                                    done: ind == 3 && confirmedForFour.containsKey(sorovlar[ind.toString()]![index].orderUid)
                                        ? confirmedForFour[sorovlar[ind.toString()]![index].orderUid]['done']
                                        : 0))),
                      ],
                    );
            }),
            SizedBox(
              height: MediaQuery.of(context).viewPadding.bottom + 109,
            ),
          ],
        ),
      ),
    );
  }
}

Widget itemWidget({required int ind, required String title, required String txt, required String time, int? total, int? done}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 19).copyWith(bottom: 9),
    decoration: MyDecoration.boxDecoration,
    padding: const EdgeInsets.symmetric(vertical: 5).copyWith(right: 9),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 49,
              height: 49,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              padding: const EdgeInsets.all(3),
              decoration: MyDecoration.boxDecoration.copyWith(
                color: ind == 3
                    ? Colors.green.withOpacity(0.19)
                    : ind == 2
                        ? Colors.deepPurple.withOpacity(0.19)
                        : ind == 1
                            ? Colors.amber.withOpacity(0.19)
                            : MyColors.secondaryColor.withOpacity(0.19),
                boxShadow: const [BoxShadow(color: MyColors.bgColor, blurRadius: 9, spreadRadius: 3)],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.library_books_rounded,
                  color: ind == 3
                      ? Colors.green.withOpacity(0.99)
                      : ind == 2
                          ? Colors.deepPurple.withOpacity(0.99)
                          : ind == 1
                              ? Colors.amber.withOpacity(0.99)
                              : MyColors.secondaryColor.withOpacity(0.99),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title ",
                      style: MyDecoration.textStyle
                          .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 22, height: 1, fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(txt,
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.69), fontSize: 14, fontWeight: FontWeight.w400)),
                      Text(time,
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.39), fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ind == 3 ? bt(total!, done!) : const SizedBox()
      ],
    ),
  );
}

Widget bt(int length, int current) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9).copyWith(top: 9),
    child: Row(
      children: [
        ...List.generate(length, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
              height: 7,
              decoration: BoxDecoration(
                  color: index >= current ? MyColors.secondaryColor.withOpacity(0.29) : Colors.deepPurple, borderRadius: BorderRadius.circular(3)),
            ),
          );
        })
      ],
    ),
  );
}
