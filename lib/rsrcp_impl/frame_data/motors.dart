import 'dart:typed_data';

import 'package:robi_live/rsrcp_impl/frame_data/abstract.dart';

class MotorsFrameData extends AbstractFrameData {
  static const int reservedBytes = 4;
  static const int scaleFactor = 100;

  final double leftMotorAngularVelocity, rightMotorAngularVelocity;

  const MotorsFrameData({
    required this.leftMotorAngularVelocity,
    required this.rightMotorAngularVelocity,
  });

  static MotorsFrameData? fromBytes(List<int> bytes) {
    if (bytes.length != reservedBytes) {
      print('MotorsFrameData.fromBytes: bytes.length != $reservedBytes');
      return null;
    }

    final byteData = ByteData.sublistView(Uint8List.fromList(bytes), 0, 4);

    final leftMotorAngularVelocity = byteData.getInt16(0) / scaleFactor;
    final rightMotorAngularVelocity = byteData.getInt16(2) / scaleFactor;

    return MotorsFrameData(
      leftMotorAngularVelocity: leftMotorAngularVelocity,
      rightMotorAngularVelocity: rightMotorAngularVelocity,
    );
  }
}
