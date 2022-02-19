import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData iconData;
  const RoundButton({
    Key? key,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(20.0),
      child: CircleAvatar(
        child: Icon(iconData),
      ),
    );
  }
}
