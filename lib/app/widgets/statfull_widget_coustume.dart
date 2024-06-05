import 'package:flutter/material.dart';


// custom stateful widget for evading the mounted tree case
class CustomStatefulBuilder extends StatefulWidget {
  final StatefulWidgetBuilder builder;

  const CustomStatefulBuilder({
    Key? key,
    required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  State<CustomStatefulBuilder> createState() => _CustomStatefulBuilderState();
}

class _CustomStatefulBuilderState extends State<CustomStatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, (callback) {
        if (mounted) {
          this.setState(callback);
        }
      });
}
