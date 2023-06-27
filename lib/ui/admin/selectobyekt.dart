import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';

class SelectObyekt extends StatefulWidget {
  const SelectObyekt({super.key, required this.obyekts, required this.changeObyekt});
  final Map obyekts;
  final Function changeObyekt;
  @override
  State<SelectObyekt> createState() => _SelectObyektState();
}

class _SelectObyektState extends State<SelectObyekt> {
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
                        ...List.generate(widget.obyekts.length, (index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.changeObyekt(widget.obyekts.values.toList()[index]['obyektuid']);

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 49,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      widget.obyekts.values.toList()[index]['obyektnomi'],
                                      style: MyDecoration.textStyle,
                                    ),
                                  ),
                                ),
                              ),
                              index == widget.obyekts.length - 1
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
