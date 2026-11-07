import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

/// Только визуальное раскрытие и remove intent. Данные и confirmation вне DS.
class AppRosterRow extends StatefulWidget {
  const AppRosterRow({
    required this.name,
    required this.initials,
    required this.onRemove,
    this.initiallyRevealed = false,
    this.focusNode,
    this.removeFocusNode,
    this.removeStatesController,
    super.key,
  });
  final String name, initials;
  final VoidCallback? onRemove;
  final bool initiallyRevealed;
  final FocusNode? focusNode, removeFocusNode;
  final WidgetStatesController? removeStatesController;
  @override
  State<AppRosterRow> createState() => _AppRosterRowState();
}

class _RosterRevealIntent extends Intent {
  const _RosterRevealIntent(this.revealed);
  final bool revealed;
}

class _AppRosterRowState extends State<AppRosterRow> {
  late bool _revealed = widget.initiallyRevealed;
  final _ownedFocus = FocusNode();
  @override
  void dispose() {
    _ownedFocus.dispose();
    super.dispose();
  }

  bool _pointerStartRevealed = false;
  void _pointerDown(PointerDownEvent event) {
    _pointerStartRevealed = _revealed;
  }

  void _pointerCancel(PointerCancelEvent event) {
    _revealed = _pointerStartRevealed;
    _cancel();
  }

  bool _dragging = false;
  double _distance = 0;
  void _noop() {}
  void _start(DragStartDetails details) {
    setState(_begin);
  }

  void _begin() {
    _dragging = true;
    _distance = 0;
  }

  void _update(DragUpdateDetails details) {
    _distance += details.primaryDelta ?? 0;
    setState(_noop);
  }

  void _end(DragEndDetails details) {
    final t = AppRosterRowTheme.of(context);
    if (_distance.abs() >= t.threshold) {
      _revealed = _distance < 0;
    }
    _resetDrag();
    setState(_noop);
  }

  void _cancel() {
    setState(_resetDrag);
  }

  void _resetDrag() {
    _dragging = false;
    _distance = 0;
  }

  Object? _reveal(_RosterRevealIntent intent) {
    _revealed = intent.revealed;
    if (!intent.revealed) {
      (widget.focusNode ?? _ownedFocus).requestFocus();
    }
    setState(_noop);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppRosterRowTheme.of(context),
        l = FoundationLocalizations.of(context);
    final label = l.rosterRemove(widget.name);
    final offset = theme.desktop
        ? theme.zero
        : ((_revealed ? -theme.actionWidth : theme.zero) +
                  (_dragging ? _distance : theme.zero))
              .clamp(-theme.actionWidth, theme.zero);
    return Semantics(
      customSemanticsActions: widget.onRemove == null
          ? null
          : {CustomSemanticsAction(label: label): widget.onRemove!},
      child: FocusableActionDetector(
        enabled: !theme.desktop,
        focusNode: widget.focusNode ?? _ownedFocus,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.arrowLeft): _RosterRevealIntent(
            true,
          ),
          SingleActivator(LogicalKeyboardKey.arrowRight): _RosterRevealIntent(
            false,
          ),
          SingleActivator(LogicalKeyboardKey.escape): _RosterRevealIntent(
            false,
          ),
        },
        actions: {
          _RosterRevealIntent: CallbackAction<_RosterRevealIntent>(
            onInvoke: _reveal,
          ),
        },
        child: ClipRRect(
          borderRadius: theme.radius,
          child: AppSurface(
            tone: AppSurfaceTone.surface,
            shape: theme.desktop
                ? AppSurfaceShape.card
                : AppSurfaceShape.nested,
            inset: AppSurfaceInset.none,
            child: Stack(
              children: [
                if (!theme.desktop)
                  Positioned(
                    right: theme.zero,
                    top: theme.zero,
                    bottom: theme.zero,
                    width: theme.actionWidth,
                    child: IgnorePointer(
                      ignoring: !_revealed,
                      child: ExcludeFocus(
                        excluding: !_revealed,
                        child: ExcludeSemantics(
                          excluding: !_revealed,
                          child: AppButton(
                            label: l.rosterDelete,
                            kind: AppButtonKind.removeSwipe,
                            onPressed: widget.onRemove,
                            focusNode: widget.removeFocusNode,
                          ),
                        ),
                      ),
                    ),
                  ),
                Listener(
                  onPointerDown: theme.desktop ? null : _pointerDown,
                  onPointerCancel: theme.desktop ? null : _pointerCancel,
                  child: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onHorizontalDragStart: theme.desktop ? null : _start,
                    onHorizontalDragUpdate: theme.desktop ? null : _update,
                    onHorizontalDragEnd: theme.desktop ? null : _end,
                    onHorizontalDragCancel: theme.desktop ? null : _cancel,
                    child: AnimatedContainer(
                      duration: _dragging ? theme.reduced : theme.duration,
                      curve: theme.curve,
                      transform: Matrix4.translationValues(
                        offset,
                        theme.zero,
                        theme.zero,
                      ),
                      child: AppSurface(
                        tone: AppSurfaceTone.surface,
                        shape: AppSurfaceShape.flat,
                        inset: AppSurfaceInset.none,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: theme.minHeight,
                          ),
                          child: Padding(
                            padding: theme.padding,
                            child: AppIdentity(
                              primary: widget.name,
                              initials: widget.initials,
                              kind: AppIdentityKind.participant,
                              layout: theme.desktop
                                  ? AppIdentityLayout.stacked
                                  : AppIdentityLayout.inline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (theme.desktop)
                  Positioned(
                    top: theme.actionInset,
                    right: theme.actionInset,
                    child: Tooltip(
                      message: label,
                      child: AppButton(
                        label: label,
                        kind: AppButtonKind.removeIcon,
                        glyph: AppGlyph.trash,
                        onPressed: widget.onRemove,
                        focusNode: widget.removeFocusNode,
                        statesController: widget.removeStatesController,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
