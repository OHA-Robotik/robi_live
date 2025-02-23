import 'package:flutter/material.dart';

import '../utils/logger.dart';

class MiniLog extends StatefulWidget {
  final List<LogMessage> logMessages;

  const MiniLog({super.key, required this.logMessages});

  @override
  State<MiniLog> createState() => _MiniLogState();
}

class _MiniLogState extends State<MiniLog> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      },
    );
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: widget.logMessages.length,
        padding: EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (context, index) {
          final logMessage = widget.logMessages[index];
          return Container(
            decoration: BoxDecoration(color: logMessage.color),
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              spacing: 3,
              children: [
                Icon(logMessage.icon, size: 12),
                Expanded(
                  child: Text(
                    logMessage.message,
                    softWrap: true,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
