import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
class AppModalCanvasTheme extends AppScreenLayoutTheme {AppModalCanvasTheme.of(BuildContext context):super.of(context){scrim=Theme.of(context).colorScheme.scrim;maxHeight=MediaQuery.sizeOf(context).height-modalViewportInset;}late final Color scrim;late final double maxHeight;}
