import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicIconButton extends StatelessWidget{
  final Icon icon;
  final NeumorphicButtonClickListener onPressed;

  const NeumorphicIconButton({required this.onPressed, required this.icon,});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        color: Colors.transparent,
        lightSource: LightSource(0, 0),
        shadowLightColor: Colors.black87,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: icon,
      onPressed: onPressed,
    );
  }
}