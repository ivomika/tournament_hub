import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_presentation_mapper.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_session.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';

class BootstrapGate<Output> extends StatefulWidget {
  const BootstrapGate({
    required this.runner,
    required this.readyBuilder,
    this.shellBuilder,
    super.key,
  });

  final BootstrapRunner<Output> runner;
  final Widget Function(BuildContext, BootstrapSession<Output>) readyBuilder;
  final Widget Function(BuildContext, Widget)? shellBuilder;

  @override
  State<BootstrapGate<Output>> createState() => _BootstrapGateState<Output>();
}

class _BootstrapGateState<Output> extends State<BootstrapGate<Output>> {
  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    widget.runner.addListener(_changed);
    if (widget.runner.state is BootstrapAwaitingApplication<Output>) {
      _observe(widget.runner.runAfterApp());
    }
  }

  @override
  void didUpdateWidget(BootstrapGate<Output> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.runner, widget.runner)) return;
    oldWidget.runner.removeListener(_changed);
    _observe(_release(oldWidget.runner));
    _attach();
  }

  void _changed() => setState(_refresh);

  void _refresh() {}

  void _retry() => _observe(widget.runner.retry());

  void _observe(Future<void> operation) {
    unawaited(operation.then<void>(_observed, onError: _report));
  }

  static void _observed(void result) {}

  static void _report(Object error, StackTrace stackTrace) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'bootstrap',
        ),
      );

  static Future<void> _release<Value>(BootstrapRunner<Value> runner) async {
    final current = runner.state;
    await runner.close();
    if (current is BootstrapReady<Value>) await current.session.close();
  }

  @override
  void dispose() {
    widget.runner.removeListener(_changed);
    _observe(_release(widget.runner));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.runner.state;
    if (current is BootstrapReady<Output>) {
      return widget.readyBuilder(context, current.session);
    }
    final screen = BootstrapScreen(
      state: BootstrapPresentationMapper.map(current),
      onRetry: current is BootstrapFailed<Output> && current.canRetry
          ? _retry
          : null,
    );
    final shell = widget.shellBuilder;
    if (shell == null) return screen;
    return shell(context, screen);
  }
}
