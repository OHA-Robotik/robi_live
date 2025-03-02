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

    final uint8List = Uint8List.fromList(bytes);

    final leftMotorByteData = ByteData.sublistView(uint8List, 0, 2);
    final rightMotorByteData = ByteData.sublistView(uint8List, 2, 4);

    final leftMotorAngularVelocity = leftMotorByteData.getInt16(0, Endian.big) / scaleFactor;
    final rightMotorAngularVelocity = rightMotorByteData.getInt16(0, Endian.big) / scaleFactor;

    return MotorsFrameData(
      leftMotorAngularVelocity: leftMotorAngularVelocity,
      rightMotorAngularVelocity: rightMotorAngularVelocity,
    );
  }
}
