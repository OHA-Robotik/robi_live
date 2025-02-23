import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RssiMonitor extends StatefulWidget {
  final BluetoothDevice device;

  const RssiMonitor({super.key, required this.device});

  @override
  State<RssiMonitor> createState() => _RssiMonitorState();
}

class _RssiMonitorState extends State<RssiMonitor> {
  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  int? _rssi;
  bool _runUpdateRssiLoop = true;
  bool _showAsNumber = false;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });

    _runUpdateRssiLoop = true;
    _updateRssiLoop();
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _runUpdateRssiLoop = false;
    super.dispose();
  }

  void _updateRssiLoop() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      if (!_runUpdateRssiLoop) return;

      if (_connectionState != BluetoothConnectionState.connected) {
        _rssi = null;
      } else {
        try {
          _rssi = await widget.device.readRssi();
        } catch (e) {
          _rssi = null;
        }
      }

      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final String text;
    final rssi = _rssi;

    if (rssi == null) {
      icon = Icons.signal_cellular_nodata;
      text = "N/A";
    } else {
      text = "$rssi dBm";
      if (rssi > -60) {
        icon = Icons.signal_cellular_alt;
      } else if (rssi > -80) {
        icon = Icons.signal_cellular_alt_2_bar;
      } else {
        icon = Icons.signal_cellular_alt_1_bar;
      }
    }

    return IconButton(
      onPressed: () => setState(() => _showAsNumber = !_showAsNumber),
      icon: _showAsNumber? Text(text) : Stack(
        children: [
          if (rssi != null)
            Icon(
              Icons.signal_cellular_alt,
              color: Colors.grey.withAlpha(120),
            ),
          Icon(icon),
        ],
      ),
    );
  }
}
