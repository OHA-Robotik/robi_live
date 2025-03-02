import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RemoteController extends StatefulWidget {
  final void Function(double velocity) onVelocityChange;
  final void Function(double steer) onSteerChange;
  final bool disableVelocityControls, disableSteeringControls;

  const RemoteController({
    super.key,
    required this.onVelocityChange,
    required this.onSteerChange,
    this.disableVelocityControls = false,
    this.disableSteeringControls = false,
  });

  @override
  State<RemoteController> createState() => _RemoteControllerState();
}

class _RemoteControllerState extends State<RemoteController> {
  double velocityValue = 0;
  double steeringValue = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 170, bottom: 70, top: 70),
              child: SizedBox(
                height: 300,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: velocityValue,
                    onChanged: widget.disableVelocityControls
                        ? null
                        : (value) {
                            setState(() {
                              velocityValue = value;
                            });
                            widget.onVelocityChange(velocityValue);
                          },
                    onChangeEnd: (value) {
                      setState(() {
                        velocityValue = 0;
                      });
                      widget.onVelocityChange(velocityValue);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: SizedBox(
                width: 270,
                child: Slider(
                  value: steeringValue,
                  onChanged: widget.disableSteeringControls
                      ? null
                      : (value) {
                          setState(() {
                            steeringValue = value;
                          });
                          widget.onSteerChange(steeringValue);
                        },
                  min: -1,
                  onChangeEnd: (value) {
                    setState(() {
                      steeringValue = 0;
                    });
                    widget.onSteerChange(steeringValue);
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
