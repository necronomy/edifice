import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mybuilding/ui/viewpdf.dart';
import 'package:path/path.dart';

class AdminShowOrder extends StatefulWidget {
  const AdminShowOrder({super.key, required this.order, required this.dostup, required this.userModel});
  final WalletModel order;
  final Map dostup;
  final UserModel userModel;
  @override
  State<AdminShowOrder> createState() => _AdminShowOrderState();
}

class _AdminShowOrderState extends State<AdminShowOrder> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController text2EditingController = TextEditingController();
  TextEditingController text3EditingController = TextEditingController();
  bool showBotForItems = true;
  List<File> myFiles = [];
  Map myMap = {};
  bool isDragStarted = false;
  String newKey = '';
  bool isChanging = false;
  @override
  void initState() {
    super.initState();

    myMap = {};
    myMap = widget.order.data;
    if (widget.order.confirmedDocs || (widget.dostup.isNotEmpty && !widget.dostup['Subcontractor'])) {
      showBotForItems = false;
    }
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: MyDecoration.textStyle
                                      .copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 19, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(widget.order.createdTimeString,
                            style: MyDecoration.textStyle
                                .copyWith(color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  ...List.generate(myMap.keys.length, (ind) {
                    return Column(
                      children: [
                        DragTarget<Map>(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return myMap.values.toList()[ind]['items'].isEmpty && accepted.isEmpty && isDragStarted
                                ? Padding(
                                    padding: const EdgeInsets.all(19.0),
                                    child: DottedBorder(
                                      dashPattern: const [9, 3],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(14),
                                      color: Colors.deepPurple.withOpacity(0.29),
                                      child: Container(
                                          height: 39,
                                          padding: const EdgeInsets.symmetric(horizontal: 9),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(19),
                                          ),
                                          child: Center(
                                            child: Text("Boshqa firma orqali",
                                                style: MyDecoration.textStyle
                                                    .copyWith(color: Colors.deepPurple.withOpacity(0.99), fontSize: 19, fontWeight: FontWeight.w500)),
                                          )),
                                    ),
                                  )
                                : AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
                                    decoration: MyDecoration.boxDecoration,
                                    child: Column(
                                      children: [
                                        ...List.generate(myMap.values.toList()[ind]['items'].length, (index) {
                                          return LongPressDraggable<Map>(
                                              maxSimultaneousDrags: isChanging ? 1 : 0,
                                              onDragStarted: () {
                                                HapticFeedback.mediumImpact();
                                                setState(() {
                                                  isDragStarted = true;
                                                  newKey = DateTime.now().microsecondsSinceEpoch.toString();
                                                  myMap[newKey] = {
                                                    'items': {},
                                                    'firma': '',
                                                    'docs': {},
                                                    'narx': '',
                                                  };
                                                });
                                              },
                                              onDragEnd: (details) {
                                                setState(() {
                                                  isDragStarted = false;
                                                  myMap.removeWhere((key, value) => value['items'].isEmpty);
                                                });
                                              },
                                              data: {
                                                'data': myMap.values.toList()[ind]['items'].values.toList()[index]['data'],
                                                'num': myMap.values.toList()[ind]['items'].values.toList()[index]['num'],
                                                'mapKey': index,
                                                'fromKey': myMap.keys.toList()[ind]
                                              },
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  width: 349,
                                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
                                                  decoration: MyDecoration.boxDecoration.copyWith(color: Colors.deepPurple),
                                                  child: contrItem(
                                                      myMap.values.toList()[ind]['items'].values.toList()[index]['data'],
                                                      "+ ${myMap.values.toList()[ind]['items'].values.toList()[index]['num']}",
                                                      false,
                                                      false,
                                                      false,
                                                      true,
                                                      const SizedBox(),
                                                      myMap.values.toList()[ind]['items'].values.toList()[index]['measure']),
                                                ),
                                              ),
                                              childWhenDragging: contrItem(
                                                  myMap.values.toList()[ind]['items'].values.toList()[index]['data'],
                                                  "+ ${myMap.values.toList()[ind]['items'].values.toList()[index]['num']}",
                                                  index != myMap.values.toList()[ind]['items'].length - 1,
                                                  true,
                                                  false,
                                                  false,
                                                  const SizedBox(),
                                                  myMap.values.toList()[ind]['items'].values.toList()[index]['measure']),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (widget.order.confirmedDocs) {
                                                    HapticFeedback.lightImpact();
                                                    if (widget.dostup.isNotEmpty && widget.dostup['Foreman']) {
                                                      setState(() {
                                                        myMap.values.toList()[ind]['items'].values.toList()[index]['done'] =
                                                            !myMap.values.toList()[ind]['items'].values.toList()[index]['done'];
                                                      });
                                                    }
                                                  }
                                                },
                                                child: contrItem(
                                                  myMap.values.toList()[ind]['items'].values.toList()[index]['data'],
                                                  "+ ${myMap.values.toList()[ind]['items'].values.toList()[index]['num']}",
                                                  index != myMap.values.toList()[ind]['items'].length - 1,
                                                  false,
                                                  false,
                                                  false,
                                                  !widget.order.confirmedDocs
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin: const EdgeInsets.only(right: 9),
                                                          height: 22,
                                                          width: 22,
                                                          decoration: MyDecoration.circularBoxDecoration.copyWith(
                                                              color: myMap.values.toList()[ind]['items'].values.toList()[index]['done']
                                                                  ? MyColors.blueColor.withOpacity(0.69)
                                                                  : Colors.transparent,
                                                              border: Border.all(
                                                                  width: 1.5,
                                                                  color: MyColors.blueColor.withOpacity(
                                                                      myMap.values.toList()[ind]['items'].values.toList()[index]['done'] ? 0 : 0.29))),
                                                          child: myMap.values.toList()[ind]['items'].values.toList()[index]['done']
                                                              ? const Center(
                                                                  child: Icon(
                                                                    Icons.check_rounded,
                                                                    color: MyColors.whiteColor,
                                                                    size: 19,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ),
                                                  myMap.values.toList()[ind]['items'].values.toList()[index]['measure'],
                                                ),
                                              ));
                                        }),
                                        ...List.generate(accepted.length, (index) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(myMap.values.toList()[ind]['items'].isEmpty && isDragStarted ? 14 : 0),
                                            child: contrItem(accepted[index]['data'], "+ ${accepted[index]['num']}", index != accepted.length - 1, false, true,
                                                false, const SizedBox(), accepted[index]['measure']),
                                          );
                                        }),
                                        !widget.order.confirmedToBuy || isDragStarted || isChanging
                                            ? const SizedBox()
                                            : Column(
                                                children: [
                                                  myMap.values.toList()[ind]['docs'].isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: 14,
                                                                  width: 9,
                                                                  decoration: MyDecoration.boxDecoration.copyWith(
                                                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                                                                      color: MyColors.bgColor),
                                                                ),
                                                                ...List.generate(14, (index) {
                                                                  return Expanded(
                                                                    flex: 1,
                                                                    child: Container(
                                                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                      height: 2.9,
                                                                      decoration: MyDecoration.boxDecoration
                                                                          .copyWith(borderRadius: BorderRadius.zero, color: MyColors.bgColor),
                                                                    ),
                                                                  );
                                                                }),
                                                                Container(
                                                                  height: 14,
                                                                  width: 9,
                                                                  decoration: MyDecoration.boxDecoration.copyWith(
                                                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                                                                      color: MyColors.bgColor),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(myMap.values.toList()[ind]['firma'],
                                                                  textAlign: TextAlign.center,
                                                                  style: MyDecoration.textStyle.copyWith(
                                                                      color: MyColors.secondaryColor.withOpacity(0.99),
                                                                      fontSize: 22,
                                                                      height: 1,
                                                                      fontWeight: FontWeight.w600)),
                                                            ),
                                                            Container(
                                                              decoration: MyDecoration.boxDecoration.copyWith(
                                                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                                                                color: Colors.grey.withOpacity(0),
                                                              ),
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("Narxi",
                                                                        style: MyDecoration.textStyle.copyWith(
                                                                            color: MyColors.secondaryColor.withOpacity(0.59),
                                                                            fontSize: 18,
                                                                            height: 1,
                                                                            fontWeight: FontWeight.w400)),
                                                                    Text(
                                                                        myMap.values.toList()[ind]['narx'].contains("s")
                                                                            ? myMap.values.toList()[ind]['narx']
                                                                            : "${myMap.values.toList()[ind]['narx']} so'm",
                                                                        style: MyDecoration.textStyle.copyWith(
                                                                            color: MyColors.secondaryColor.withOpacity(0.99),
                                                                            fontSize: 18,
                                                                            height: 1,
                                                                            fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            ...List.generate(myMap.values.toList()[ind]['docs'].values.toList().length, (docIndex) {
                                                              return Column(
                                                                children: [
                                                                  Divider(
                                                                    height: 1,
                                                                    color: MyColors.secondaryColor.withOpacity(0.19),
                                                                    thickness: 0.5,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                        return ViewPdf(
                                                                          url:
                                                                              "https://firebasestorage.googleapis.com/v0/b/necro-mybuilding.appspot.com/o/docs%2F${myMap.values.toList()[ind]['docs'].values.toList()[docIndex]['docurl']}?alt=media",
                                                                        );
                                                                      }));
                                                                    },
                                                                    child: Container(
                                                                      decoration: MyDecoration.boxDecoration.copyWith(
                                                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                                                                        color: Colors.grey.withOpacity(0),
                                                                      ),
                                                                      child: Container(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text("PDF",
                                                                                style: MyDecoration.textStyle.copyWith(
                                                                                    color: MyColors.secondaryColor.withOpacity(0.59),
                                                                                    fontSize: 18,
                                                                                    height: 1,
                                                                                    fontWeight: FontWeight.w400)),
                                                                            Text(myMap.values.toList()[ind]['docs'].values.toList()[docIndex]['basename'],
                                                                                style: MyDecoration.textStyle.copyWith(
                                                                                    color: MyColors.secondaryColor.withOpacity(0.69),
                                                                                    fontSize: 18,
                                                                                    height: 1,
                                                                                    fontWeight: FontWeight.w300)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            })
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  !showBotForItems || widget.dostup.isEmpty || (widget.dostup.isNotEmpty && !widget.dostup['Subcontractor'])
                                                      ? const SizedBox()
                                                      : Column(
                                                          children: [
                                                            Divider(
                                                              height: 1,
                                                              color: MyColors.secondaryColor.withOpacity(0.19),
                                                              thickness: 0.5,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  if (myMap.values.toList()[ind]['docs'].isEmpty) {
                                                                    showDialog(
                                                                        context: context,
                                                                        barrierColor: Colors.black38,
                                                                        builder: (context) {
                                                                          return Material(
                                                                            color: Colors.transparent,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 19),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(19),
                                                                                    child: BackdropFilter(
                                                                                      filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19),
                                                                                      child: Container(
                                                                                        decoration: MyDecoration.boxDecoration
                                                                                            .copyWith(color: MyColors.whiteColor.withOpacity(0.89)),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(14.0),
                                                                                              child: Text(
                                                                                                "Yuqoridagi mahsulotlar barchasi bitta firmadan olinyaptimi?",
                                                                                                textAlign: TextAlign.center,
                                                                                                style: MyDecoration.textStyle.copyWith(
                                                                                                    fontSize: 24,
                                                                                                    color: MyColors.secondaryColor.withOpacity(0.99),
                                                                                                    fontWeight: FontWeight.w600),
                                                                                              ),
                                                                                            ),
                                                                                            Divider(
                                                                                              height: 1,
                                                                                              color: MyColors.secondaryColor.withOpacity(0.19),
                                                                                              thickness: 0.5,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 59,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    flex: 1,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          isChanging = true;
                                                                                                        });
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        color: Colors.transparent,
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            "Ajratish",
                                                                                                            style: MyDecoration.textStyle.copyWith(
                                                                                                                color: Colors.deepPurple,
                                                                                                                fontWeight: FontWeight.w500),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  VerticalDivider(
                                                                                                    width: 1,
                                                                                                    color: MyColors.secondaryColor.withOpacity(0.19),
                                                                                                    thickness: 0.5,
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                    flex: 1,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                        showModalBottomSheet(
                                                                                                            context: context,
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            isScrollControlled: true,
                                                                                                            builder: (context) {
                                                                                                              return Container(
                                                                                                                decoration: MyDecoration.boxDecoration
                                                                                                                    .copyWith(
                                                                                                                        borderRadius:
                                                                                                                            const BorderRadius.vertical(
                                                                                                                                top: Radius.circular(29))),
                                                                                                                child: SafeArea(
                                                                                                                  top: false,
                                                                                                                  child: Column(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    children: [
                                                                                                                      Container(
                                                                                                                        margin: const EdgeInsets.symmetric(
                                                                                                                            vertical: 7),
                                                                                                                        height: 7,
                                                                                                                        width: 129,
                                                                                                                        decoration: BoxDecoration(
                                                                                                                            color: MyColors.secondaryColor
                                                                                                                                .withOpacity(0.79),
                                                                                                                            borderRadius:
                                                                                                                                BorderRadius.circular(7)),
                                                                                                                      ),
                                                                                                                      Padding(
                                                                                                                        padding: const EdgeInsets.symmetric(
                                                                                                                                horizontal: 19)
                                                                                                                            .copyWith(top: 9),
                                                                                                                        child: TextFormField(
                                                                                                                          controller: textEditingController,
                                                                                                                          onChanged: (value) {
                                                                                                                            setState(() {});
                                                                                                                          },
                                                                                                                          autofocus: true,
                                                                                                                          decoration: MyDecoration
                                                                                                                              .inputDecoration
                                                                                                                              .copyWith(
                                                                                                                                  labelText:
                                                                                                                                      "Shartnoma tuzilgan firma ",
                                                                                                                                  suffixText: "(MCHJ)"),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Padding(
                                                                                                                        padding: const EdgeInsets.symmetric(
                                                                                                                                horizontal: 19)
                                                                                                                            .copyWith(top: 9),
                                                                                                                        child: TextFormField(
                                                                                                                          controller: text2EditingController,
                                                                                                                          onChanged: (value) {
                                                                                                                            setState(() {});
                                                                                                                          },
                                                                                                                          autofocus: true,
                                                                                                                          decoration: MyDecoration
                                                                                                                              .inputDecoration
                                                                                                                              .copyWith(
                                                                                                                                  labelText:
                                                                                                                                      "Shartnoma umumiy summasi ",
                                                                                                                                  suffixText:
                                                                                                                                      "(1 mln, 1 mlrd)"),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Padding(
                                                                                                                        padding: const EdgeInsets.symmetric(
                                                                                                                                horizontal: 19)
                                                                                                                            .copyWith(top: 9),
                                                                                                                        child: GestureDetector(
                                                                                                                          onTap: () async {
                                                                                                                            print('tap');
                                                                                                                            FilePickerResult? result =
                                                                                                                                await FilePicker.platform
                                                                                                                                    .pickFiles(
                                                                                                                              allowMultiple: true,
                                                                                                                              type: FileType.custom,
                                                                                                                              allowedExtensions: [
                                                                                                                                'jpg',
                                                                                                                                'pdf',
                                                                                                                                'doc'
                                                                                                                              ],
                                                                                                                            );

                                                                                                                            if (result != null) {
                                                                                                                              List<File> files = result.paths
                                                                                                                                  .map((path) => File(path!))
                                                                                                                                  .toList();
                                                                                                                              print("<------->");
                                                                                                                              files.forEach((element) {
                                                                                                                                text3EditingController
                                                                                                                                    .text = text3EditingController
                                                                                                                                        .text.isEmpty
                                                                                                                                    ? basename(element.path)
                                                                                                                                    : "${text3EditingController.text}, ${basename(element.path)}";
                                                                                                                              });
                                                                                                                              setState(() {
                                                                                                                                myFiles = files;
                                                                                                                              });
                                                                                                                            } else {
                                                                                                                              // User canceled the picker
                                                                                                                            }
                                                                                                                          },
                                                                                                                          child: TextFormField(
                                                                                                                            controller: text3EditingController,
                                                                                                                            enabled: false,
                                                                                                                            autofocus: true,
                                                                                                                            decoration: MyDecoration
                                                                                                                                .inputDecoration
                                                                                                                                .copyWith(
                                                                                                                              labelText: "Shartnoma fayli ",
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          myMap.values.toList()[ind]['firma'] =
                                                                                                                              textEditingController.text;
                                                                                                                          myMap.values.toList()[ind]['narx'] =
                                                                                                                              text2EditingController.text;
                                                                                                                          for (var fayl in myFiles) {
                                                                                                                            String urlForDoc =
                                                                                                                                "docurl${Random().nextInt(999999999) + 1000000000}";

                                                                                                                            FirebaseStorage.instance
                                                                                                                                .ref('docs/$urlForDoc')
                                                                                                                                .putFile(fayl);

                                                                                                                            myMap.values.toList()[ind]['docs']
                                                                                                                                [urlForDoc] = {
                                                                                                                              'basename': basename(fayl.path),
                                                                                                                              'path': fayl.path,
                                                                                                                              'docurl': urlForDoc,
                                                                                                                              'type': basename(fayl.path)
                                                                                                                                  .split('.')
                                                                                                                                  .last
                                                                                                                            };
                                                                                                                          }

                                                                                                                          Navigator.pop(context);
                                                                                                                          FocusScope.of(context).unfocus();
                                                                                                                        },
                                                                                                                        child: Padding(
                                                                                                                          padding: const EdgeInsets.all(9.0),
                                                                                                                          child: Container(
                                                                                                                              width: 199,
                                                                                                                              height: 49,
                                                                                                                              constraints:
                                                                                                                                  const BoxConstraints(
                                                                                                                                      maxHeight: 59,
                                                                                                                                      maxWidth: 299),
                                                                                                                              decoration: MyDecoration
                                                                                                                                  .boxDecoration
                                                                                                                                  .copyWith(
                                                                                                                                      color: MyColors.blueColor
                                                                                                                                          .withOpacity(0.89)),
                                                                                                                              child: const Center(
                                                                                                                                child: Text(
                                                                                                                                  "Qo'shish",
                                                                                                                                  style:
                                                                                                                                      MyDecoration.textStyle,
                                                                                                                                ),
                                                                                                                              )),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      AnimatedContainer(
                                                                                                                        duration:
                                                                                                                            const Duration(milliseconds: 1),
                                                                                                                        height: MediaQuery.of(context)
                                                                                                                                .viewInsets
                                                                                                                                .bottom +
                                                                                                                            9,
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                              );
                                                                                                            }).then((value) {
                                                                                                          setState(() {
                                                                                                            textEditingController.text = '';
                                                                                                            text2EditingController.text = '';
                                                                                                            text3EditingController.text = '';
                                                                                                            myFiles = [];
                                                                                                          });
                                                                                                        });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                          color: Colors.transparent,
                                                                                                          child: Center(
                                                                                                              child: Text(
                                                                                                            "Davom etish",
                                                                                                            style: MyDecoration.textStyle.copyWith(
                                                                                                                color: MyColors.blueColor,
                                                                                                                fontWeight: FontWeight.w500),
                                                                                                          ))),
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else {
                                                                    myMap.values.toList()[ind]['docs'].values.toList().forEach((element) {
                                                                      text3EditingController.text = text3EditingController.text.isEmpty
                                                                          ? element['basename']
                                                                          : "${text3EditingController.text}, ${element['basename']}";
                                                                    });
                                                                    setState(() {
                                                                      textEditingController.text = myMap.values.toList()[ind]['firma'];
                                                                      text2EditingController.text = myMap.values.toList()[ind]['narx'];
                                                                    });
                                                                    showModalBottomSheet(
                                                                        context: context,
                                                                        backgroundColor: Colors.transparent,
                                                                        isScrollControlled: true,
                                                                        builder: (context) {
                                                                          return Container(
                                                                            decoration: MyDecoration.boxDecoration
                                                                                .copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(29))),
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
                                                                                        color: MyColors.secondaryColor.withOpacity(0.79),
                                                                                        borderRadius: BorderRadius.circular(7)),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                                                    child: TextFormField(
                                                                                      controller: textEditingController,
                                                                                      onChanged: (value) {
                                                                                        setState(() {});
                                                                                      },
                                                                                      autofocus: true,
                                                                                      decoration: MyDecoration.inputDecoration.copyWith(
                                                                                          labelText: "Shartnoma tuzilgan firma ", suffixText: "(MCHJ)"),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                                                    child: TextFormField(
                                                                                      controller: text2EditingController,
                                                                                      onChanged: (value) {
                                                                                        setState(() {});
                                                                                      },
                                                                                      autofocus: true,
                                                                                      decoration: MyDecoration.inputDecoration.copyWith(
                                                                                          labelText: "Shartnoma umumiy summasi ", suffixText: "(1 mln so'm)"),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 19).copyWith(top: 9),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: GestureDetector(
                                                                                            onTap: () async {
                                                                                              print('tap');
                                                                                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                                                                allowMultiple: true,
                                                                                                type: FileType.custom,
                                                                                                allowedExtensions: ['jpg', 'pdf', 'doc'],
                                                                                              );

                                                                                              if (result != null) {
                                                                                                List<File> files =
                                                                                                    result.paths.map((path) => File(path!)).toList();
                                                                                                print("<------->");
                                                                                                files.forEach((element) {
                                                                                                  print(basename(element.path));
                                                                                                  text3EditingController.text = text3EditingController
                                                                                                          .text.isEmpty
                                                                                                      ? basename(element.path)
                                                                                                      : "${text3EditingController.text}, ${basename(element.path)}";
                                                                                                });
                                                                                                setState(() {
                                                                                                  myFiles = files;
                                                                                                });
                                                                                              } else {
                                                                                                // User canceled the picker
                                                                                              }
                                                                                            },
                                                                                            child: TextFormField(
                                                                                              controller: text3EditingController,
                                                                                              enabled: false,
                                                                                              autofocus: true,
                                                                                              decoration: MyDecoration.inputDecoration.copyWith(
                                                                                                labelText: "Shartnoma fayli ",
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            for (var item
                                                                                                in myMap.values.toList()[ind]['docs'].keys.toList()) {
                                                                                              try {
                                                                                                FirebaseStorage.instance.ref('docs/$item').delete();
                                                                                              } catch (e) {
                                                                                                print(e);
                                                                                              }
                                                                                            }
                                                                                            setState(() {
                                                                                              myMap.values.toList()[ind]['docs'] = {};
                                                                                              text3EditingController.text = '';
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(
                                                                                              left: 9,
                                                                                            ),
                                                                                            height: 24,
                                                                                            width: 24,
                                                                                            decoration:
                                                                                                MyDecoration.circularBoxDecoration.copyWith(color: Colors.red),
                                                                                            child: Center(
                                                                                              child: Icon(
                                                                                                Icons.remove_rounded,
                                                                                                color: MyColors.whiteColor.withOpacity(0.99),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      myMap.values.toList()[ind]['firma'] = textEditingController.text;
                                                                                      myMap.values.toList()[ind]['narx'] = text2EditingController.text;
                                                                                      for (var fayl in myFiles) {
                                                                                        myMap.values.toList()[ind]['docs']['path${myFiles.indexOf(fayl)}'] = {
                                                                                          'basename': basename(fayl.path),
                                                                                          'path': fayl.path,
                                                                                          'type': basename(fayl.path).split('.').last
                                                                                        };
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
                                                                                          decoration: MyDecoration.boxDecoration
                                                                                              .copyWith(color: MyColors.blueColor.withOpacity(0.89)),
                                                                                          child: const Center(
                                                                                            child: Text(
                                                                                              "Saqlash",
                                                                                              style: MyDecoration.textStyle,
                                                                                            ),
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  AnimatedContainer(
                                                                                    duration: const Duration(milliseconds: 1),
                                                                                    height: MediaQuery.of(context).viewInsets.bottom + 9,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).then((value) {
                                                                      setState(() {
                                                                        textEditingController.text = '';
                                                                        text2EditingController.text = '';
                                                                        text3EditingController.text = '';
                                                                        myFiles = [];
                                                                      });
                                                                    });
                                                                  }
                                                                },
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                                    decoration: MyDecoration.boxDecoration.copyWith(
                                                                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                                                                      color: Colors.grey.withOpacity(0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                            myMap.values.toList()[ind]['docs'].isNotEmpty
                                                                                ? "O'zgartirish"
                                                                                : "Shartnoma qo'shish",
                                                                            style: MyDecoration.textStyle.copyWith(
                                                                                color: myMap.values.toList()[ind]['docs'].isNotEmpty
                                                                                    ? Colors.orange.withOpacity(0.79)
                                                                                    : MyColors.blueColor.withOpacity(0.79),
                                                                                fontSize: 24,
                                                                                height: 1,
                                                                                fontWeight: FontWeight.w500)),
                                                                      ],
                                                                    ))),
                                                          ],
                                                        ),
                                                ],
                                              )
                                      ],
                                    ));
                          },
                          onMove: (details) {},
                          onWillAccept: (mp) {
                            if (!(myMap.values.toList()[ind]['items'].values.toList().any((element) => mp!['data'] == element))) {
                              HapticFeedback.mediumImpact();
                            }
                            return myMap.values.toList()[ind]['items'].values.toList().any((element) => mp!['data'] == element['data']) ? false : true;
                          },
                          onAccept: (Map mp) {
                            setState(() {
                              myMap.values.toList()[ind]['items'][myMap[mp['fromKey']]!['items'].keys.toList()[mp['mapKey']]] =
                                  myMap[mp['fromKey']]!['items'].values.toList()[mp['mapKey']];
                              myMap[mp['fromKey']]!['items'].removeWhere((key, value) => value['data'] == mp['data']);
                              myMap.removeWhere((key, value) => value['items'].isEmpty);
                            });
                          },
                        ),
                        // myMap.values.toList()[ind]['items'].isEmpty || myMap.keys.length - 1 == ind
                        //     ? const SizedBox()
                        //     : Divider(
                        //         color: MyColors.secondaryColor.withOpacity(0.19),
                        //         thickness: 0.5,
                        //       ),
                      ],
                    );
                  }),
                  Divider(
                    color: MyColors.secondaryColor.withOpacity(0.19),
                    thickness: 0.5,
                  ),
                  isDragStarted || isChanging ? const SizedBox() : itemWidget(title: "Yubordi", txt: widget.order.createdBy),
                  isDragStarted || isChanging ? const SizedBox() : itemWidget(title: "Obyekt", txt: widget.order.obyekt),
                  myMap.values.toList().any((element) => element['docs'].isEmpty) || !showBotForItems
                      ? const SizedBox()
                      : Center(
                          child: GestureDetector(
                            onTap: () {
                              Map newMyMap = myMap;
                              for (String keyData in newMyMap.keys) {
                                for (String keyItem in newMyMap[keyData]['items'].keys) {
                                  String rand = "itemUid${Random().nextInt(999999999) + 1000000000}";
                                  if (!(newMyMap[keyData]['items'][keyItem].containsKey('itemUid'))) {
                                    newMyMap[keyData]['items'][keyItem]['itemUid'] = rand;
                                  }
                                }
                              }
                              Map updatedOrder = widget.order.toMap();
                              updatedOrder['data'] = newMyMap;
                              updatedOrder['confirmedDocs'] = true;

                              FirebaseFirestore.instance.collection(widget.order.obyektUid).doc('wallet').update({widget.order.orderUid: updatedOrder});
                              Navigator.pop(context);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 59, bottom: 29),
                                height: 49,
                                constraints: const BoxConstraints(maxHeight: 59, maxWidth: 299),
                                decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.blueColor.withOpacity(0.89)),
                                child: const Center(
                                  child: Text(
                                    "Tasdiqlash va Yuborish",
                                    style: MyDecoration.textStyle,
                                  ),
                                )),
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.bottom + 69,
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: AdminTop(),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                      child: widget.dostup.isNotEmpty && widget.dostup['Foreman'] && widget.order.confirmedToBuy && widget.order.confirmedDocs
                          ? GestureDetector(
                              onTap: () {
                                Map newMyMap = myMap;
                                for (String keyData in newMyMap.keys) {
                                  for (String keyItem in newMyMap[keyData]['items'].keys) {
                                    String rand = "itemUid${Random().nextInt(999999999) + 1000000000}";
                                    if (!(newMyMap[keyData]['items'][keyItem].containsKey('itemUid'))) {
                                      newMyMap[keyData]['items'][keyItem]['itemUid'] = rand;
                                    }
                                  }
                                }

                                Map newOrderMap = widget.order.toMap();
                                newOrderMap['data'] = newMyMap;
                                for (var dataKey in newOrderMap['data'].keys) {
                                  for (var item in newOrderMap['data'][dataKey]['items'].values) {
                                    Map mp = {
                                      'name': item['data'],
                                      'type': item['type'],
                                      'hajmi': item['num'],
                                      'measure': item['measure'],
                                      'orderId': widget.order.orderUid,
                                      'dataId': dataKey,
                                      'itemUid': item['itemUid'],
                                      'done': item['done'],
                                      'docs': newOrderMap['data'][dataKey]['docs'],
                                      'createdTime': DateTime.now(),
                                      'createdTimeString': DateFormat("dd.MM.yyyy").format(DateTime.now()),
                                      'createdBy': widget.order.createdBy,
                                      'createdByUid': widget.order.createdByUid
                                    };
                                    FirebaseFirestore.instance.collection(widget.order.obyektUid).doc('ombor').update({item['itemUid']: mp});
                                  }
                                }

                                FirebaseFirestore.instance.collection(widget.order.obyektUid).doc('wallet').update({widget.order.orderUid: newOrderMap});
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: MediaQuery.of(context).viewPadding.bottom > 19 ? 45 + MediaQuery.of(context).viewPadding.bottom : 59,
                                width: double.maxFinite,
                                decoration: MyDecoration.boxDecoration
                                    .copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(0)), color: MyColors.bgColor.withOpacity(0.59)),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Saqlash",
                                    style: MyDecoration.textStyle.copyWith(color: Colors.deepPurple, fontSize: 29, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          : widget.order.confirmedToBuy && widget.dostup.isNotEmpty && widget.dostup['Subcontractor']
                              ? GestureDetector(
                                  onTap: () {
                                    if (isChanging) {
                                      Map updatedOrder = widget.order.toMap();
                                      updatedOrder['data'] = myMap;
                                      FirebaseFirestore.instance
                                          .collection(widget.order.obyektUid)
                                          .doc('wallet')
                                          .update({widget.order.orderUid: updatedOrder});
                                    }
                                    setState(() {
                                      isChanging = !isChanging;
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).viewPadding.bottom > 19 ? 45 + MediaQuery.of(context).viewPadding.bottom : 59,
                                    width: double.maxFinite,
                                    decoration: MyDecoration.boxDecoration.copyWith(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)), color: MyColors.bgColor.withOpacity(0.59)),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        isChanging ? "Tayyor" : "Ajratish",
                                        style: MyDecoration.textStyle
                                            .copyWith(color: isChanging ? MyColors.blueColor : Colors.deepPurple, fontSize: 29, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              : !widget.order.confirmedToBuy && widget.userModel.type == 'director'
                                  ? SizedBox(
                                      height: MediaQuery.of(context).viewPadding.bottom > 19 ? 45 + MediaQuery.of(context).viewPadding.bottom : 59,
                                      child: Column(
                                        children: [
                                          Divider(
                                            height: 1,
                                            color: MyColors.secondaryColor.withOpacity(0.19),
                                            thickness: 0.5,
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 19.0),
                                                          child: Text(
                                                            "Rad etish",
                                                            style: MyDecoration.textStyle
                                                                .copyWith(color: const Color.fromARGB(255, 234, 24, 9), fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color: MyColors.secondaryColor.withOpacity(0.19),
                                                  thickness: 0.5,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Map newOrderMap = widget.order.toMap();
                                                      newOrderMap['confirmedToBuy'] = true;
                                                      FirebaseFirestore.instance
                                                          .collection(widget.order.obyektUid)
                                                          .doc('wallet')
                                                          .update({widget.order.orderUid: newOrderMap});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                        color: Colors.transparent,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 19.0),
                                                          child: Center(
                                                              child: Text(
                                                            "Tasdiqlash",
                                                            style: MyDecoration.textStyle
                                                                .copyWith(color: MyColors.blueColor.withOpacity(0.89), fontWeight: FontWeight.w500),
                                                          )),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                    ))),
          ],
        ));
  }
}

Widget contrItem(String title, String sub, bool showDivider, bool titleFade, bool target, bool feedback, Widget lead, String measure) {
  return Container(
    decoration: MyDecoration.boxDecoration.copyWith(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
      color: target ? Colors.deepPurple.withOpacity(0.39) : Colors.transparent,
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  lead,
                  Text(title,
                      style: MyDecoration.textStyle.copyWith(
                          color: target || feedback ? MyColors.whiteColor : MyColors.secondaryColor.withOpacity(titleFade ? 0.39 : 0.99),
                          fontSize: 24,
                          height: 1,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Text("$sub $measure",
                  style: MyDecoration.textStyle.copyWith(
                      color: target || feedback ? MyColors.whiteColor : MyColors.blueColor.withOpacity(titleFade ? 0.39 : 0.69),
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: showDivider ? MyColors.secondaryColor.withOpacity(0.19) : Colors.transparent,
        ),
      ],
    ),
  );
}

Widget itemWidget({
  required String title,
  required String txt,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22).copyWith(top: 9),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title ", style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 18, fontWeight: FontWeight.w400)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(txt,
                style:
                    MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), height: 1, fontSize: 22, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}
