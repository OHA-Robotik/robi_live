import 'package:flutter/material.dart';
import 'package:robi_live/rsrcp_impl/rsrc_frame.dart';
import 'package:robi_live/rsrcp_impl/rsrc_handshake.dart';

class RSRCVisualizationWidget extends StatelessWidget {
  final RSRCHandshake rsrcHandshake;
  final List<RSRCFrame> rsrcFrames;

  const RSRCVisualizationWidget({super.key, required this.rsrcHandshake, required this.rsrcFrames});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (rsrcFrames.last.potiFrameData != null) Text(rsrcFrames.last.potiFrameData!.value.toString()),
        if (rsrcFrames.last.buttonsFrameData != null) ... [
          Text("Center Button ${rsrcFrames.last.buttonsFrameData!.isCenterButtonPressed ? 'Pressed' : 'Not Pressed'}"),
          Text("Left Button ${rsrcFrames.last.buttonsFrameData!.isLeftButtonPressed ? 'Pressed' : 'Not Pressed'}"),
          Text("Right Button ${rsrcFrames.last.buttonsFrameData!.isRightButtonPressed ? 'Pressed' : 'Not Pressed'}"),
          Text("Top Button ${rsrcFrames.last.buttonsFrameData!.isUpButtonPressed ? 'Pressed' : 'Not Pressed'}"),
          Text("Bottom Button ${rsrcFrames.last.buttonsFrameData!.isDownButtonPressed ? 'Pressed' : 'Not Pressed'}"),
        ]
      ],
    );
  }
}
