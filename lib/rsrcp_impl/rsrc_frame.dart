import 'package:robi_live/rsrcp_impl/frame_data/buttons.dart';
import 'package:robi_live/rsrcp_impl/frame_data/enabled_feature_set.dart';
import 'package:robi_live/rsrcp_impl/frame_data/motors.dart';
import 'package:robi_live/rsrcp_impl/frame_data/poti.dart';
import 'package:robi_live/rsrcp_impl/utils.dart';

class RSRCFrame {
  static const int SOP = 0x7E;
  static const int EOP = 0x7F;

  static const int frameIdBytes = 3;

  final int frameId;
  final EnabledFeatureSetFrameData enabledFeatureSetFrameData;
  final PotiFrameData? potiFrameData;
  final ButtonsFrameData? buttonsFrameData;
  final MotorsFrameData? motorsFrameData;

  const RSRCFrame({
    required this.frameId,
    required this.enabledFeatureSetFrameData,
    this.potiFrameData,
    this.buttonsFrameData,
    this.motorsFrameData,
  });

  static RSRCFrame? fromBytes(List<int> bytes) {
    if (bytes.first != SOP || bytes.last != EOP) {
      print('RSRCFrame.fromBytes: bytes[0] != SOP || bytes[bytes.length - 1] != EOP');
      return null;
    }

    final payloadBytes = bytes.sublist(1, bytes.length - 1);
    final frameId = intFromBytes(payloadBytes.sublist(0, frameIdBytes));
    final enabledFeatureSetFrameBytes = payloadBytes.sublist(frameIdBytes, EnabledFeatureSetFrameData.reservedBytes + frameIdBytes);
    final enabledFeatureSetFrameData = EnabledFeatureSetFrameData.fromBytes(enabledFeatureSetFrameBytes);

    if (enabledFeatureSetFrameData == null) {
      print('RSRCFrame.fromBytes: enabledFeatureSetFrameData == null');
      return null;
    }

    final featureBytes = payloadBytes.sublist(frameIdBytes + EnabledFeatureSetFrameData.reservedBytes);

    int featureReaderIndex = 0;

    PotiFrameData? potiFrameData;
    ButtonsFrameData? buttonsFrameData;
    MotorsFrameData? motorsFrameData;

    if (enabledFeatureSetFrameData.enableVoltages) {}

    if (enabledFeatureSetFrameData.enableMotorStates) {
      final motorsFrameDataBytes = featureBytes.sublist(featureReaderIndex, featureReaderIndex + MotorsFrameData.reservedBytes);
      motorsFrameData = MotorsFrameData.fromBytes(motorsFrameDataBytes);
      featureReaderIndex += MotorsFrameData.reservedBytes;
    }

    if (enabledFeatureSetFrameData.enableGyroscopeState) {}

    if (enabledFeatureSetFrameData.enableAccelerometerState) {}

    if (enabledFeatureSetFrameData.enableLaserSensorState) {}

    if (enabledFeatureSetFrameData.enableInfraredSensorsState) {}

    if (enabledFeatureSetFrameData.enablePotiState) {
      final potiFrameDataBytes = featureBytes.sublist(featureReaderIndex, featureReaderIndex + PotiFrameData.reservedBytes);
      potiFrameData = PotiFrameData.fromBytes(potiFrameDataBytes);
      featureReaderIndex += PotiFrameData.reservedBytes;
    }

    if (enabledFeatureSetFrameData.enableButtonStates) {
      final buttonsFrameDataBytes = featureBytes.sublist(featureReaderIndex, featureReaderIndex + ButtonsFrameData.reservedBytes);
      buttonsFrameData = ButtonsFrameData.fromBytes(buttonsFrameDataBytes);
      featureReaderIndex += ButtonsFrameData.reservedBytes;
    }

    if (enabledFeatureSetFrameData.enableLEDStates) {}

    if (enabledFeatureSetFrameData.enablePiezoState) {}

    if (enabledFeatureSetFrameData.enableLCDState) {}

    return RSRCFrame(
      frameId: frameId,
      enabledFeatureSetFrameData: enabledFeatureSetFrameData,
      potiFrameData: potiFrameData,
      buttonsFrameData: buttonsFrameData,
      motorsFrameData: motorsFrameData,
    );
  }
}
