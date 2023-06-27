import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';

class SelectDom extends StatefulWidget {
  const SelectDom({super.key, required this.changeDom, required this.domKey, required this.domlar});
  final Map domlar;
  final String domKey;
  final Function changeDom;
  @override
  State<SelectDom> createState() => _SelectDomState();
}

class _SelectDomState extends State<SelectDom> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(19),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                child: Container(
                    decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.69)),
                    child: Column(
                      children: [
                        ...List.generate(widget.domlar.length, (index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.changeDom(widget.domlar.keys.toList()[index]);

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 49,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      widget.domlar.values.toList()[index]['domname'],
                                      style: MyDecoration.textStyle,
                                    ),
                                  ),
                                ),
                              ),
                              index == widget.domlar.length - 1
                                  ? const SizedBox()
                                  : Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: MyColors.whiteColor.withOpacity(0.19),
                                    ),
                            ],
                          );
                        })
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
