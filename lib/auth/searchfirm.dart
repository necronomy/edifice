import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/service/sendmsg.dart';
import 'package:mybuilding/ui/admin/admintop.dart';

class SearchFirm extends StatefulWidget {
  const SearchFirm({super.key, required this.userModel, required this.firmalar});
  final UserModel userModel;
  final List<FirmaModel> firmalar;
  @override
  State<SearchFirm> createState() => _SearchFirmState();
}

class _SearchFirmState extends State<SearchFirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19.0, left: 19, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text("Mavjud firmalar",
                                style: MyDecoration.textStyle
                                    .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CupertinoSearchTextField(),
                      ),
                      ...List.generate(
                          widget.firmalar.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
                                  FirebaseFirestore.instance.collection('xabarlar').doc(widget.firmalar[index].xabarlar).update({
                                    dateTime: {'type': 'qabul', 'person': widget.userModel.name, 'personuid': widget.userModel.uid, 'isActive': true}
                                  });
                                  FirebaseFirestore.instance.collection('allusers').doc(widget.userModel.uid).update({'firmauid': 'waiting'});
                                  SendMsg().sendMessage(widget.userModel.name, 'Ishchga qabul qiling', widget.firmalar[index].director);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: GestureDetector(
                                          onTap: () {
                                            ScaffoldMessenger.of(context).clearSnackBars();
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: MyDecoration.boxDecoration.copyWith(color: Colors.deepPurple),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 9.0),
                                                    child: Text("Firmaga so'rov yuborildi",
                                                        style: TextStyle(color: MyColors.whiteColor, fontSize: 19, fontWeight: FontWeight.bold)),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                                                      child: Text("So'rov qabul qilinishi vaqt olishi mumkin",
                                                          style: TextStyle(color: MyColors.whiteColor.withOpacity(0.79)))),
                                                ],
                                              )),
                                        ),
                                      ))
                                      .closed
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: itemWidget(
                                    imgUrl: logoImageUrl(widget.firmalar[index].logoUrl),
                                    firmanomi: widget.firmalar[index].firmanomi,
                                    director: widget.firmalar[index].firmainn),
                              ))
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
}

Widget itemWidget({required String imgUrl, required String firmanomi, required String director}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 9),
    decoration: MyDecoration.boxDecoration,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(firmanomi,
                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 19, fontWeight: FontWeight.w700)),
            ),
            Text(director,
                style:
                    MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 15, height: 1, fontWeight: FontWeight.w400)),
          ],
        ),
      ],
    ),
  );
}
