import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostRunningScreenPreview extends StatelessWidget {
  const HostRunningScreenPreview({
    this.title = 'Турнир идёт',
    this.currentFirst = previewIvan,
    this.currentSecond = previewMira,
    this.currentMatchTitle = 'Текущий матч',
    this.progress = 'МАТЧ 1',
    this.structure,
    this.readyToFinish = false,
    this.onEnterResult,
    this.onCorrectResult,
    this.onFinish,
    this.onWithdrawFirst,
    this.onWithdrawSecond,
    super.key,
  });

  final String title;
  final PreviewParticipant currentFirst;
  final PreviewParticipant currentSecond;
  final String currentMatchTitle;
  final String progress;
  final BracketViewData? structure;
  final bool readyToFinish;
  final VoidCallback? onEnterResult;
  final VoidCallback? onCorrectResult;
  final VoidCallback? onFinish;
  final VoidCallback? onWithdrawFirst;
  final VoidCallback? onWithdrawSecond;

  @override
  Widget build(BuildContext context) {
    final currentMatchKey = GlobalKey();
    return AppShell(
      title: title,
      subtitle: readyToFinish
          ? 'Все обязательные матчи завершены.'
          : 'Текущий матч определяется турнирными правилами.',
      sectionLabel: 'ТУРНИР · ЭТАП 4 ИЗ 5',
      headerVariant: PageHeaderVariant.compact,
      actionDock: ActionDock(
        primary: DsAction(
          label: readyToFinish ? 'Подвести итоги' : 'Ввести результат',
          onPressed: readyToFinish ? onFinish : onEnterResult,
        ),
        contextual: ActionDockAction(
          key: const Key('host-running-current-jump'),
          label: 'К текущему бою',
          onSelected: () {
            final target = currentMatchKey.currentContext;
            if (target != null) {
              Scrollable.ensureVisible(target, alignment: 0.04);
            }
          },
        ),
        secondary: [
          if (onCorrectResult != null)
            ActionDockAction(
              label: 'Исправить последний результат',
              onSelected: onCorrectResult ?? () {},
            ),
          if (!readyToFinish && onWithdrawFirst != null)
            ActionDockAction(
              label:
                  'Снять ${currentFirst.fighterName} · ${currentFirst.nickname}',
              onSelected: onWithdrawFirst ?? () {},
            ),
          if (!readyToFinish && onWithdrawSecond != null)
            ActionDockAction(
              label:
                  'Снять ${currentSecond.fighterName} · ${currentSecond.nickname}',
              onSelected: onWithdrawSecond ?? () {},
            ),
        ],
      ),
      child: PageLayout(
        preset: PageLayoutPreset.flow,
        primary: KeyedSubtree(
          key: currentMatchKey,
          child: TournamentMatchCard(
            title: currentMatchTitle,
            first: currentFirst,
            second: currentSecond,
            isCurrent: !readyToFinish,
          ),
        ),
        secondary: TournamentStageHeader(
          variant: TournamentStageVariant.strip,
          stage: readyToFinish ? 'Итоги готовы' : 'Турнир идёт',
          progress: progress,
          detail: readyToFinish
              ? 'Чемпион и ranking рассчитаны Domain engine.'
              : 'Выбери победителя после завершения серии.',
          kind: readyToFinish ? StatusKind.success : StatusKind.warning,
        ),
        supporting: TournamentBracketPreview(data: structure),
      ),
    );
  }
}
