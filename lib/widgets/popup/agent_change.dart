import 'package:flutter/material.dart';
import 'package:omni_chat/constants/assistant.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/assistant.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:provider/provider.dart';

class AgentChangePopUp extends StatelessWidget {
  const AgentChangePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Center(
                child: Text(
                  "AI Models",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children:
                    Assistant.values
                        .map((agent) => AgentLine(agent: agent.toDto()))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgentLine extends StatelessWidget {
  const AgentLine({super.key, required this.agent});

  final AssistantDto agent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          context.read<ConvoProvider>().changeAssistant(agent);
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          foregroundColor: WidgetStateProperty.all(
            context.watch<ConvoProvider>().currentAssistant.name == agent.name
                ? omniMilk
                : Colors.black54,
          ),
          backgroundColor: WidgetStateProperty.all(
            context.watch<ConvoProvider>().currentAssistant.name == agent.name
                ? omniDarkBlue
                : Colors.transparent,
          ),
          iconColor: WidgetStateProperty.all(
            context.watch<ConvoProvider>().currentAssistant.name == agent.name
                ? omniMilk
                : Colors.black54,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(agent.name, style: TextStyle(fontSize: 15)),
            context.watch<ConvoProvider>().currentAssistant.name == agent.name
                ? Icon(Icons.smart_toy, size: 20)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
