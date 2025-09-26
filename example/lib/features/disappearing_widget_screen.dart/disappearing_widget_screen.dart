import 'package:flutter/material.dart';

import 'disappearing_keys.dart';

final class DisappearingWidgetScreen extends StatefulWidget {
  const DisappearingWidgetScreen({super.key});

  @override
  State<DisappearingWidgetScreen> createState() => _DisappearingWidgetScreenState();
}

final class _DisappearingWidgetScreenState extends State<DisappearingWidgetScreen> {
  var visible = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: DisappearingKeys.screen,
      appBar: AppBar(title: const Text('Disappearing Widget')),
      body: Center(
        child: visible
            ? Container(
                key: DisappearingKeys.disappearingWidget,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(24),
                ),
                width: 200,
                height: 200,
                padding: EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text(
                  'I will disappear\nin 2 seconds',
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey, width: 1),
                  borderRadius: BorderRadius.circular(24),
                ),
                width: 200,
                height: 200,
              ),
      ),
    );
  }
}
