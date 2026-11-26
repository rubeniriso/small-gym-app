import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/theme.dart';

/// Small uppercase label above a page title or a section.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: color ?? theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

/// Eyebrow line plus a large title, at the top of a screen.
class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title, this.eyebrow, this.below});

  final String title;
  final String? eyebrow;
  final String? below;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[Eyebrow(eyebrow!), const SizedBox(height: 4)],
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(height: 1.15),
        ),
        if (below != null) ...[
          const SizedBox(height: 4),
          Text(
            below!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// The tinted, rounded card that holds the main thing on a screen.
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.hero),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: scheme.onPrimaryContainer),
        child: IconTheme.merge(
          data: IconThemeData(color: scheme.onPrimaryContainer),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

enum PillTone { neutral, onHero, positive, primary }

class InfoPill extends StatelessWidget {
  const InfoPill(this.label, {super.key, this.tone = PillTone.neutral});

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final (background, foreground) = switch (tone) {
      PillTone.neutral => (
        scheme.surfaceContainerHigh,
        scheme.onSurfaceVariant,
      ),
      PillTone.onHero => (
        scheme.surface.withValues(alpha: dark ? 0.25 : 0.6),
        scheme.onPrimaryContainer,
      ),
      PillTone.positive =>
        dark
            ? (const Color(0xFF1F3A24), const Color(0xFFA8E0AE))
            : (const Color(0xFFD3F0D6), const Color(0xFF1F5F2E)),
      PillTone.primary => (scheme.primary, scheme.onPrimary),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

IconData exerciseIcon(ExerciseKind kind) => switch (kind) {
  ExerciseKind.strength => Icons.fitness_center,
  ExerciseKind.jogging => Icons.directions_run,
  ExerciseKind.sprinting => Icons.bolt,
};

/// Square tinted box with an icon, at the start of exercise rows.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Icon(icon, size: 22, color: scheme.primary),
    );
  }
}

/// One exercise on a card: icon, name, details and an optional badge.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final ExerciseKind kind;
  final String title;
  final Widget subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              IconBadge(exerciseIcon(kind)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    DefaultTextStyle.merge(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      child: subtitle,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Monday to Sunday of this week. Logged days carry a dot; today is filled.
class WeekStrip extends ConsumerWidget {
  const WeekStrip({super.key, required this.routineId});

  final int routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(activityCalendarProvider(routineId)).value;
    if (days == null || days.length < 7) {
      return const SizedBox(height: 52);
    }
    final week = days.sublist(days.length - 7);
    final scheme = Theme.of(context).colorScheme;
    final labels = context.s.weekdayInitials;
    return Row(
      children: [
        for (var index = 0; index < 7; index++) ...[
          if (index > 0) const SizedBox(width: 6),
          Expanded(
            child: _WeekCell(
              label: labels[index],
              logged: week[index].logged,
              today: week[index].isToday,
              scheme: scheme,
            ),
          ),
        ],
      ],
    );
  }
}

class _WeekCell extends StatelessWidget {
  const _WeekCell({
    required this.label,
    required this.logged,
    required this.today,
    required this.scheme,
  });

  final String label;
  final bool logged;
  final bool today;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final foreground = today ? scheme.onPrimary : scheme.onSurfaceVariant;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: today ? scheme.primary : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: today ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: logged
                  ? (today ? scheme.onPrimary : scheme.primary)
                  : null,
              border: logged
                  ? null
                  : Border.all(
                      color: today ? scheme.onPrimary : scheme.outline,
                      width: 1.5,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
