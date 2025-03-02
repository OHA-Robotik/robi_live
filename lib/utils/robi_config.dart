import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Remote Control

const String remoteControlServiceUUID = "ba73";
const String velocityCharacteristicUUID = "6b2f";
const String steeringCharacteristicUUID = "3f4a";

final remoteControlServiceGuid = Guid(remoteControlServiceUUID);
final velocityCharacteristicGuid = Guid(velocityCharacteristicUUID);
final steeringCharacteristicGuid = Guid(steeringCharacteristicUUID);

//  RSRC
const String rsrcServiceUUID = "2579";
const String rsrcCharacteristicUUID = "8765";
const String startConfirmationCharacteristicUUID = "4234";
const String rsrcHandshakeCharacteristicUUID = "4744";

final rsrcServiceGuid = Guid(rsrcServiceUUID);
final rsrcCharacteristicGuid = Guid(rsrcCharacteristicUUID);
final startConfirmationCharacteristicGuid = Guid(startConfirmationCharacteristicUUID);
final rsrcHandshakeCharacteristicGuid = Guid(rsrcHandshakeCharacteristicUUID);
