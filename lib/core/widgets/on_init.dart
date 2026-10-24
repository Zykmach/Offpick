import 'package:flutter/widgets.dart';

/// Runs [onInit] once, right after the first frame is drawn.
/// Handy for "load data when the screen opens" without setState.
class OnInit extends StatefulWidget {
  final void Function(BuildContext context) onInit;
  final Widget child;

  const OnInit({super.key, required this.onInit, required this.child});

  @override
  State<OnInit> createState() => OnInitState();
}

class OnInitState extends State<OnInit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) widget.onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
