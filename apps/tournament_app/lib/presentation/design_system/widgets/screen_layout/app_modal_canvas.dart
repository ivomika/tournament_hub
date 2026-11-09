import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_modal_canvas_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';

class AppModalCanvas extends StatelessWidget {
  const AppModalCanvas({required this.child,this.underlay,this.sheet=false,this.theme,super.key});
  final Widget child;
  final Widget? underlay;
  final bool sheet;
  final AppModalCanvasTheme? theme;
  @override
  Widget build(BuildContext context) {
    final t=theme??AppModalCanvasTheme.of(context);
    return Scaffold(
      backgroundColor:t.background,
      body:SafeArea(
        child:Stack(
          children:[
            Positioned.fill(
              child:ExcludeSemantics(
                child:ExcludeFocus(
                  child:IgnorePointer(
                    child:AppScreenCanvas(child:underlay??const SizedBox.shrink()),
                  ),
                ),
              ),
            ),
            Positioned.fill(child:ColoredBox(color:t.scrim)),
            FocusScope(
              autofocus:true,
              child:Align(
                alignment:sheet&&!t.desktop?t.bottomAlign:t.centerAlign,
                child:Padding(
                  padding:sheet&&!t.desktop?EdgeInsets.all(t.zero):t.inset,
                  child:ConstrainedBox(
                    constraints:BoxConstraints(maxWidth:sheet?t.modalSheetWidth:t.fullWidth,maxHeight:t.maxHeight),
                    child:SingleChildScrollView(child:child),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
