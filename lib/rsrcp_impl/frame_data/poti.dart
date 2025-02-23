import 'package:robi_live/rsrcp_impl/frame_data/abstract.dart';

class PotiFrameData extends AbstractFrameData {
  static const int reservedBytes = 1;

  final int value;

  const PotiFrameData({required this.value});

  static PotiFrameData? fromBytes(List<int> bytes) {
    if (bytes.length != reservedBytes) {
      print('PotiFrameData.fromBytes: bytes.length != $reservedBytes');
      return null;
    }

    return PotiFrameData(value: bytes[0]);
  }
}
