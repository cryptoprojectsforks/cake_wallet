import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  FilterTile({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      child: child,
    );
  }
}