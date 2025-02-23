import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:robi_live/rsrcp_impl/rsrc_frame.dart';
import 'package:robi_live/utils/extra.dart';
import 'package:robi_live/utils/robi_config.dart';
import 'package:robi_live/widgets/rsrc_visulization.dart';

import '../rsrcp_impl/rsrc_handshake.dart';
import '../utils/logger.dart';
import '../widgets/mini_log.dart';
import '../widgets/rssi_monitor.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({super.key, required this.device});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  bool _isDiscoveringServices = false;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;

  // Characteristics
  BluetoothCharacteristic? _rsrcCharacteristic, _startConfirmationCharacteristic, _rsrcHandshakeCharacteristic;

  RSRCHandshake? _rsrcHandshake;
  final List<RSRCFrame> _rsrcFrames = [];

  final List<LogMessage> logMessages = [];

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        logSuccess("Connected");
        postConnectionSequence();
      }
      if (mounted) {
        setState(() {});
      }
    });

    _isConnectingSubscription = widget.device.isConnecting.listen((value) {
      _isConnecting = value;
      if (_isConnecting) {
        logInfo("Connecting...");
      }
      if (mounted) {
        setState(() {});
      }
    });

    _isDisconnectingSubscription = widget.device.isDisconnecting.listen((value) {
      _isDisconnecting = value;
      if (_isDisconnecting) {
        logInfo("Disconnecting...");
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> postConnectionSequence() async {
    bool success;
    success = await discoverServices();
    if (!success) return;
    success = await readRSRCHandshakeCharacteristic();
    if (!success) return;
    await sendStartConfirmation();
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    super.dispose();
  }

  void addLogMsg(String msg, IconData icon, Color color) {
    if (mounted) setState(() => logMessages.add(LogMessage(icon: icon, message: msg, color: color)));
  }

  void logSuccess(String msg) => addLogMsg(msg, Icons.check_circle, Colors.green);

  void logInfo(String msg) => addLogMsg(msg, Icons.info, Colors.transparent);

  void logException(String prefix, Object e) => logError('$prefix ${e.toString()}');

  void logError(String msg) => addLogMsg(msg, Icons.error, Colors.red);

  void logWarning(String msg) => addLogMsg(msg, Icons.warning, Colors.yellow);

  bool get isConnected => _connectionState == BluetoothConnectionState.connected;

  bool get enableAnyControl => isConnected;

  Future<bool> discoverServices() async {
    logInfo("Discovering services...");

    setState(() {
      _isDiscoveringServices = true;
    });

    final services = await widget.device.discoverServices();

    for (final service in services) {
      if (service.serviceUuid == rsrcServiceGuid) {
        logSuccess("Discovered RSRC service");

        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == rsrcCharacteristicGuid) {
            logSuccess("Discovered RSRC characteristic");

            _rsrcCharacteristic = characteristic;

            final subscription = _rsrcCharacteristic!.onValueReceived.listen((value) {
              if (!mounted) return;
              logInfo("RSRC frame: $value");
              final frame = RSRCFrame.fromBytes(value);
              if (frame != null) {
                setState(() {
                  _rsrcFrames.add(frame);
                });
              } else {
                logError("RSRC frame parsing failed");
              }
            });

            widget.device.cancelWhenDisconnected(subscription);

            logInfo("Setting notify to RSRC characteristic...");
            try {
              await _rsrcCharacteristic!.setNotifyValue(true, timeout: 5);
              logSuccess("Notify set");
            } catch (e) {
              logException("Notify Error:", e);
            }
          } else if (characteristic.uuid == startConfirmationCharacteristicGuid) {
            logSuccess("Discovered RSRC confirmation service");
            _startConfirmationCharacteristic = characteristic;
          } else if (characteristic.uuid == rsrcHandshakeCharacteristicGuid) {
            logSuccess("Discovered RSRC handshake characteristic");
            _rsrcHandshakeCharacteristic = characteristic;
          } else {
            logWarning("Unknown characteristic: ${characteristic.uuid.str}");
          }
        }
      } else {
        logWarning("Discovered unknown service: ${service.serviceUuid.str}");
      }
    }

    if (_rsrcCharacteristic == null) {
      logError("RSRC characteristic not found");
    }

    if (_startConfirmationCharacteristic == null) {
      logError("RSRC confirmation characteristic not found");
    }

    if (_rsrcHandshakeCharacteristic == null) {
      logError("RSRC handshake characteristic not found");
    }

    logInfo("Services discovery completed");

    setState(() {
      _isDiscoveringServices = false;
    });

    return _rsrcCharacteristic != null && _startConfirmationCharacteristic != null && _rsrcHandshakeCharacteristic != null;
  }

  Future<bool> readRSRCHandshakeCharacteristic() async {
    logInfo("Reading RSRC handshake...");
    late final List<int> rsrcHandshakeBytes;
    try {
      rsrcHandshakeBytes = await _rsrcHandshakeCharacteristic!.read();
      logSuccess("RSRC handshake read");
    } catch (e) {
      logException("Read Error:", e);
      return false;
    }

    logInfo("Parsing RSRC handshake...");
    _rsrcHandshake = RSRCHandshake.fromBytes(rsrcHandshakeBytes);

    if (_rsrcHandshake == null) {
      logError("RSRC handshake parsing failed");
      return false;
    }

    logSuccess("RSRC handshake parsed");

    logInfo("Handshake data: $_rsrcHandshake");

    return true;
  }

  Future<bool> sendStartConfirmation() async {
    logInfo("Sending start confirmation...");
    try {
      await _startConfirmationCharacteristic!.write([0x01], withoutResponse: _startConfirmationCharacteristic!.properties.writeWithoutResponse);
    } catch (e) {
      logException("Start confirmation Error:", e);
      return false;
    }
    logSuccess("Start confirmation sent");
    return true;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.connectAndUpdateStream();
      logSuccess("Connect: Success");
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        logException("Connect Error:", e);
      }
    }
  }

  Future onCancelPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream(queue: false);
      logSuccess("Cancel: Success");
    } catch (e) {
      logException("Cancel Error:", e);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream();
      logSuccess("Disconnect: Success");
    } catch (e) {
      logException("Disconnect Error:", e);
    }
  }

  Widget buildConnectButton(BuildContext context) {
    if (_isConnecting || _isDisconnecting) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          ),
          if (_isConnecting)
            IconButton(
              onPressed: () => onCancelPressed(),
              icon: Icon(Icons.cancel),
            )
        ],
      );
    }

    if (isConnected) {
      return IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        icon: Icon(Icons.bluetooth_connected),
        onPressed: onDisconnectPressed,
      );
    }

    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      onPressed: onConnectPressed,
      icon: Icon(Icons.bluetooth),
    );
  }

  Future<bool> writeToCharacteristic(BluetoothCharacteristic characteristic, List<int> data) async {
    try {
      await characteristic.write(data, withoutResponse: characteristic.properties.writeWithoutResponse);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RssiMonitor(device: widget.device),
          buildConnectButton(context),
          SizedBox(width: 5),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (logMessages.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  minWidth: 200,
                  maxWidth: 200,
                ),
                child: MiniLog(logMessages: logMessages),
              ),
            ),
          if (_rsrcHandshake != null && _rsrcFrames.isNotEmpty) RSRCVisualizationWidget(rsrcHandshake: _rsrcHandshake!, rsrcFrames: _rsrcFrames),
        ],
      ),
    );
  }
}
