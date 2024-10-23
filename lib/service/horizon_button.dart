import 'package:flutter/material.dart';

class LeviButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const LeviButton({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromRGBO(228, 212, 156, 1), Color(0xffad9c00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
