import 'package:robi_live/rsrcp_impl/utils.dart';

class RSRCHandshake {
  static const int SOP = 0x7E;
  static const int EOP = 0x7F;

  static const int reservedBytes = 5;

  final int protocolVersion;
  final int msdt;

  const RSRCHandshake({required this.protocolVersion, required this.msdt});

  static RSRCHandshake? fromBytes(List<int> bytes) {
    if (bytes.length != reservedBytes) {
      print('RSRCHandshake.fromBytes: bytes.length != $reservedBytes');
      return null;
    }

    if (bytes.first != SOP || bytes.last != EOP) {
      print('RSRCHandshake.fromBytes: bytes[0] != SOP || bytes[bytes.length - 1] != EOP');
      return null;
    }

    return RSRCHandshake(
      protocolVersion: bytes[1],
      msdt: intFromBytes(bytes.sublist(2, 4)),
    );
  }

  @override
  String toString() => 'Protocol Version: $protocolVersion, MSDT: $msdt';
}
