import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routinesProvider);
    return DatabaseView(
      value: routines,
      builder: (context, items) {
        return Stack(
          children: [
            if (items.isEmpty)
              const Center(child: Text('No routines yet.'))
            else
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () => context.push('/routines/${item.id}'),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (item.isTemplate)
                              Text(
                                '12-week plan',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            if (item.isCurrent)
                              Text(
                                'Current',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            Row(
                              children: [
                                if (!item.isCurrent)
                                  TextButton(
                                    onPressed: () {
                                      ref.mutate(
                                        (repository) => repository
                                            .setCurrentRoutine(item.id),
                                      );
                                    },
                                    child: const Text('Set as current'),
                                  ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Delete routine',
                                  onPressed: () =>
                                      _delete(context, ref, item.id),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            Positioned(
              right: 16,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: FloatingActionButton.extended(
                tooltip: 'Create routine',
                onPressed: () => _openCreate(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Empty routine'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(_createEmpty(context, ref));
                },
              ),
              ListTile(
                title: const Text('12-week template'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push('/routines/new/template');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createEmpty(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewRoutineDialog(),
    );
    if (name == null || !context.mounted) {
      return;
    }
    await ref.mutate((repository) => repository.createRoutine(name));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete this routine?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await ref.mutate((repository) => repository.deleteRoutine(id));
  }
}

class _NewRoutineDialog extends StatefulWidget {
  const _NewRoutineDialog();

  @override
  State<_NewRoutineDialog> createState() => _NewRoutineDialogState();
}

class _NewRoutineDialogState extends State<_NewRoutineDialog> {
  final _name = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name.');
      return;
    }
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New routine'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(labelText: 'Name', errorText: _error),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}
