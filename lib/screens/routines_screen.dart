import 'dart:async';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/l10n/app_strings.dart';
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
              Center(child: Text(context.s.text('No routines yet.')))
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
                        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  if (item.isTemplate)
                                    Text(
                                      context.s.text('12-week plan'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  if (item.kind == RoutineKind.dynamicDay)
                                    Text(
                                      context.s.routineKind(
                                        RoutineKind.dynamicDay,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  if (item.kind == RoutineKind.customPattern)
                                    Text(
                                      context.s.routineKind(
                                        RoutineKind.customPattern,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: item.isCurrent
                                  ? null
                                  : () {
                                      ref.mutate(
                                        (repository) => repository
                                            .setCurrentRoutine(item.id),
                                      );
                                    },
                              style: IconButton.styleFrom(
                                disabledForegroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                              icon: Icon(
                                item.isCurrent ? Icons.star : Icons.star_border,
                              ),
                            ),
                            IconButton(
                              tooltip: context.s.text('Delete routine'),
                              onPressed: () => _delete(context, ref, item.id),
                              icon: const Icon(Icons.delete_outline),
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
                tooltip: context.s.text('Create routine'),
                onPressed: () => _openCreate(context, ref),
                icon: const Icon(Icons.add),
                label: Text(context.s.text('Create')),
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
                title: Text(sheetContext.s.text('Empty routine')),
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(_createEmpty(context, ref));
                },
              ),
              ListTile(
                title: Text(sheetContext.s.text('12-week template')),
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push('/routines/new/template');
                },
              ),
              ListTile(
                title: Text(sheetContext.s.text('Import template')),
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(_import(context, ref));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createEmpty(BuildContext context, WidgetRef ref) async {
    final draft = await showDialog<_DraftRoutine>(
      context: context,
      builder: (context) => const _NewRoutineDialog(),
    );
    if (draft == null || !context.mounted) {
      return;
    }
    await ref.mutate(
      (repository) => repository.createRoutine(
        draft.name,
        kind: draft.kind,
        patternStart: draft.kind == RoutineKind.customPattern
            ? ref.read(clockProvider)()
            : null,
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final source = await showDialog<String>(
      context: context,
      builder: (context) => const _ImportDialog(),
    );
    if (source == null || !context.mounted) {
      return;
    }
    try {
      final id = await ref.mutate(
        (repository) => repository.importRoutine(source),
      );
      if (!context.mounted) {
        return;
      }
      context.push('/routines/$id');
    } on FormatException {
      if (!context.mounted) {
        return;
      }
      _showMessage(context, context.s.text('That file is not a template.'));
    } on ArgumentError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showMessage(context, context.s.errorMessage(error));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.s.text('Delete this routine?')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.s.text('Cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.s.text('Delete')),
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

class _DraftRoutine {
  const _DraftRoutine(this.name, this.kind);

  final String name;
  final RoutineKind kind;
}

class _NewRoutineDialog extends StatefulWidget {
  const _NewRoutineDialog();

  @override
  State<_NewRoutineDialog> createState() => _NewRoutineDialogState();
}

class _NewRoutineDialogState extends State<_NewRoutineDialog> {
  final _name = TextEditingController();
  var _kind = RoutineKind.staticWeek;
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
    Navigator.pop(context, _DraftRoutine(name, _kind));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      title: Text(s.text('New routine')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              decoration: InputDecoration(
                labelText: s.text('Name'),
                errorText: _error == null ? null : s.text(_error!),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Text(s.text('Type'), style: Theme.of(context).textTheme.labelLarge),
            for (final kind in RoutineKind.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  _kind == kind
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(s.routineKind(kind)),
                onTap: () => setState(() => _kind = kind),
              ),
            if (_kind == RoutineKind.customPattern)
              Text(
                s.text('Numbered days repeat on the calendar.'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        TextButton(onPressed: _submit, child: Text(s.text('Create'))),
      ],
    );
  }
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog();

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  final _source = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _source.dispose();
    super.dispose();
  }

  void _submit() {
    final source = _source.text.trim();
    if (source.isEmpty) {
      setState(() => _error = 'Paste a template.');
      return;
    }
    try {
      jsonDecode(source);
    } on FormatException {
      setState(() => _error = 'That file is not a template.');
      return;
    }
    Navigator.pop(context, source);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      title: Text(s.text('Import template')),
      content: TextField(
        controller: _source,
        autofocus: true,
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(
          labelText: s.text('Template JSON'),
          errorText: _error == null ? null : s.text(_error!),
          alignLabelWithHint: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        TextButton(onPressed: _submit, child: Text(s.text('Import'))),
      ],
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
