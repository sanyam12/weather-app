import 'package:flutter/material.dart';

class AdditionalCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;

  const AdditionalCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
  });

  final textStyle = const TextStyle(
    fontSize: 22,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
          ),
          Text(
            title,
            style: textStyle,
          ),
          Text(
            amount.toString(),
            style: textStyle,
          )
        ],
      ),
    );
  }
}
