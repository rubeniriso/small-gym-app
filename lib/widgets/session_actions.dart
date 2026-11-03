import 'package:flutter/material.dart';
import 'package:gym_app/l10n/app_strings.dart';

class SessionActions extends StatelessWidget {
  const SessionActions({
    super.key,
    required this.logged,
    required this.autopilot,
    required this.onLog,
    required this.onAutopilot,
  });

  final bool logged;
  final bool autopilot;
  final VoidCallback onLog;
  final VoidCallback onAutopilot;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onLog,
            child: Text(logged ? s.text('Edit log') : s.text('Log session')),
          ),
        ),
        if (autopilot) ...[
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.tonal(
              onPressed: onAutopilot,
              child: Text(s.text('Autopilot')),
            ),
          ),
        ],
      ],
    );
  }
}
