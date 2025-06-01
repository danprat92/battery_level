import 'package:flutter/material.dart';
import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({super.key});

  @override
  _BatteryWidgetState createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  final Battery _battery = Battery();
  BatteryState? _batteryState;
  int _level = 0;
  int _timeTaken = 0;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen(
      _updateBatteryState,
    );
    _getBatteryLevel();
  }

  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
  }

  Future<void> _getBatteryLevel() async {
    final startTime = DateTime.now(); // Record start time
    final level = await _battery.batteryLevel; // Fetch battery level
    final endTime = DateTime.now(); // Record end time

    final duration = endTime.difference(startTime); // Calculate duration

    setState(() {
      _level = level;
      _timeTaken = duration.inMilliseconds; // Store time taken
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Level')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Align children vertically in the center
          children: [
            Text('Battery Level: $_level%'),
            Text('Time taken: $_timeTaken milliseconds'),
            Text('Status: $_batteryState'),
          ],
        ),
      ),
    );
  }
}
