import 'package:robi_live/rsrcp_impl/frame_data/abstract.dart';

/*
| Bit Position | Represented Button |
|--------------|--------------------|
| 0 (MSB)      | Center Button      |
| 1            | Left Button        |
| 2            | Right Button       |
| 3            | Top Button         |
| 4            | Bottom Button      |
| 5            | (Unused)           |
| 6            | (Unused)           |
| 7 (LSB)      | (Unused)           |
*/

class ButtonsFrameData extends AbstractFrameData {
  static const int reservedBytes = 1;

  final bool isCenterButtonPressed, isLeftButtonPressed, isRightButtonPressed, isUpButtonPressed, isDownButtonPressed;

  const ButtonsFrameData({
    required this.isCenterButtonPressed,
    required this.isLeftButtonPressed,
    required this.isRightButtonPressed,
    required this.isUpButtonPressed,
    required this.isDownButtonPressed,
  });

  static ButtonsFrameData? fromBytes(List<int> bytes) {
    if (bytes.length != reservedBytes) {
      print('ButtonsFrameData.fromBytes: bytes.length != $reservedBytes');
      return null;
    }

    return ButtonsFrameData(
      isCenterButtonPressed: (bytes[0] & 0x80) != 0,
      isLeftButtonPressed: (bytes[0] & 0x40) != 0,
      isRightButtonPressed: (bytes[0] & 0x20) != 0,
      isUpButtonPressed: (bytes[0] & 0x10) != 0,
      isDownButtonPressed: (bytes[0] & 0x08) != 0,
    );
  }
}
