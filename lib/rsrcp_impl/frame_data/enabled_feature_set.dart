import 'package:robi_live/rsrcp_impl/frame_data/abstract.dart';

import '../utils.dart';

/*
The enabled feature set is communicated as an 16-bit unsigned integer. Each bit represents a feature:

| Bit Position | Feature                |
|--------------|------------------------|
| 0 (MSB)      | Voltages               |
| 1            | Motor States           |
| 2            | Gyroscope State        |
| 3            | Accelerometer State    |
| 4            | Laser Sensor State     |
| 5            | Infrared Sensors State |
| 6            | Poti State             |
| 7            | Button States          |
| 8            | LED States             |
| 9            | Piezo State            |
| 10           | LCD State              |
*/
class EnabledFeatureSetFrameData extends AbstractFrameData {

  static const int reservedBytes = 2;

  final bool enableVoltages,
      enableMotorStates,
      enableGyroscopeState,
      enableAccelerometerState,
      enableLaserSensorState,
      enableInfraredSensorsState,
      enablePotiState,
      enableButtonStates,
      enableLEDStates,
      enablePiezoState,
      enableLCDState;

  const EnabledFeatureSetFrameData({
    required this.enableVoltages,
    required this.enableMotorStates,
    required this.enableGyroscopeState,
    required this.enableAccelerometerState,
    required this.enableLaserSensorState,
    required this.enableInfraredSensorsState,
    required this.enablePotiState,
    required this.enableButtonStates,
    required this.enableLEDStates,
    required this.enablePiezoState,
    required this.enableLCDState,
  });

  static EnabledFeatureSetFrameData? fromBytes(List<int> bytes) {
    if (bytes.length != reservedBytes) {
      print('EnabledFeatureSetFrameData.fromBytes: bytes.length != reservedBytes');
      return null;
    }

    final int value = intFromBytes(bytes);

    return EnabledFeatureSetFrameData(
      enableVoltages: value & 0x8000 != 0,
      enableMotorStates: value & 0x4000 != 0,
      enableGyroscopeState: value & 0x2000 != 0,
      enableAccelerometerState: value & 0x1000 != 0,
      enableLaserSensorState: value & 0x0800 != 0,
      enableInfraredSensorsState: value & 0x0400 != 0,
      enablePotiState: value & 0x0200 != 0,
      enableButtonStates: value & 0x0100 != 0,
      enableLEDStates: value & 0x0080 != 0,
      enablePiezoState: value & 0x0040 != 0,
      enableLCDState: value & 0x0020 != 0,
    );
  }
}
