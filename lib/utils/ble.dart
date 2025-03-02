import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<bool> writeToCharacteristic(BluetoothCharacteristic characteristic, List<int> data) async {
  try {
    await characteristic.write(data, withoutResponse: characteristic.properties.writeWithoutResponse);
    return true;
  } catch (e) {
    return false;
  }
}
