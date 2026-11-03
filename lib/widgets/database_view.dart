import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/l10n/app_strings.dart';

class DatabaseView<T> extends StatelessWidget {
  const DatabaseView({super.key, required this.value, required this.builder});

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    if (!value.hasValue) {
      if (value.hasError) {
        return Center(child: Text(context.s.text(messageFor(value.error!))));
      }
      return const SizedBox.shrink();
    }
    return builder(context, value.requireValue);
  }
}

String messageFor(Object error) {
  if (error is ArgumentError && error.message is String) {
    return error.message! as String;
  }
  return 'Could not open the database.';
}
