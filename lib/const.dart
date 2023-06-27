import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget myLogo() {
  return Container(
    height: 44,
    width: 44,
    padding: const EdgeInsets.all(5),
    decoration: MyDecoration.boxDecoration.copyWith(
      color: Colors.deepPurple,
      image: const DecorationImage(image: AssetImage("assets/logo.png")),
      borderRadius: BorderRadius.circular(19),
    ),
  );
}

String logoImageUrl(String path) {
  return "https://firebasestorage.googleapis.com/v0/b/necro-mybuilding.appspot.com/o/logos%2F$path?alt=media";
}

String obyektLogoImageUrl(String path) {
  return "https://firebasestorage.googleapis.com/v0/b/necro-mybuilding.appspot.com/o/obyektlogos%2F$path?alt=media";
}

class MyColors {
  static const Color bgColor = Color.fromARGB(255, 239, 239, 245);
  static const Color whiteColor = Colors.white;
  static const Color secondaryColor = Color.fromARGB(255, 30, 34, 38);
  static const Color bgColor2 = Color.fromARGB(255, 169, 171, 172);
  static const Color bgColor3 = Color.fromARGB(255, 125, 127, 130);
  static const Color blueColor = Color.fromARGB(255, 4, 92, 233);
}

class MyDecoration {
  static BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(14),
    color: MyColors.whiteColor,
  );
  static BoxDecoration circularBoxDecoration = const BoxDecoration(color: MyColors.whiteColor, shape: BoxShape.circle);
  static const TextStyle textStyle = TextStyle(fontSize: 21, color: MyColors.whiteColor);
  static InputDecoration inputDecoration = InputDecoration(

      //prefixText: "Start text",
      //helperText: 'bottom helper',
      //suffixText: "End text",

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      isDense: true,
      labelText: "123 ",
      labelStyle: textStyle.copyWith(color: MyColors.bgColor3, fontSize: 17),
      suffixStyle: textStyle.copyWith(color: Colors.deepPurple, fontSize: 17),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: MyColors.bgColor3)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: MyColors.bgColor2)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: MyColors.bgColor2)));
}

Widget myButton({required Function function, required Widget child}) {
  return GestureDetector(
    onTap: () async {
      await function();
    },
    child: Container(
      constraints: const BoxConstraints(maxHeight: 59, maxWidth: 299),
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
      decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor),
      child: Center(
        child: child,
      ),
    ),
  );
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class MyAnimation extends StatefulWidget {
  const MyAnimation({super.key, required this.child, required this.function});
  final Function function;
  final Widget child;

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  double scale = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) async {
          HapticFeedback.mediumImpact();
          SystemSound.play(SystemSoundType.click);
          setState(() {
            scale = 0.9;
          });
        },
        onTapCancel: () {
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              scale = 1;
            });
          });
        },
        onTapUp: (d) {
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.function();
            setState(() {
              scale = 1;
            });
          });
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: scale,
          child: widget.child,
        ));
  }
}
