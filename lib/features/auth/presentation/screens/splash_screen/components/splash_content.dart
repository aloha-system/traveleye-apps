import 'package:flutter/material.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({super.key, this.text, this.image});
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "BooLe",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            widget.text!,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
          ),
        ),
        const Spacer(flex: 2),
        Image.asset(widget.image!, height: 265, width: 235),
      ],
    );
  }
}
