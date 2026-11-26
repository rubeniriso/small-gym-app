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
          child: FilledButton.icon(
            onPressed: onLog,
            icon: Icon(logged ? Icons.edit_outlined : Icons.add),
            label: Text(
              logged ? s.text('Edit log') : s.text('Log session'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (autopilot) ...[
          const SizedBox(width: 10),
          FilledButton.tonalIcon(
            onPressed: onAutopilot,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(s.text('Autopilot')),
          ),
        ],
      ],
    );
  }
}
