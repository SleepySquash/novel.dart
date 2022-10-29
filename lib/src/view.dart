import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'core/line.dart';
import 'core/scenario.dart';
import 'util/log.dart';

class Novel extends StatelessWidget {
  const Novel({
    Key? key,
    required this.scenario,
    this.onEnd,
  }) : super(key: key);

  /// [Scenario] to read in this [Novel].
  final Scenario scenario;

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  /// Enables or disables the logging.
  static void setLogging(bool value) => Log.enabled = value;

  static String backgrounds = 'assets/background';
  static String characters = 'assets/character';
  static String voices = 'voice';
  static String musics = 'music';

  static int backgroundDepth = 0;
  static int characterDepth = 16000;
  static int dialogueDepth = 32000;

  /// Displays a dialog with the provided [scenario] above the current contents.
  static Future<T?> show<T extends Object?>({
    required BuildContext context,
    required List<Line> scenario,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Novel(scenario: Scenario(scenario)),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Threshold(0),
            reverseCurve: Curves.linear,
          ),
          child: child,
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: 200.milliseconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NovelController(
        scenario,
        onEnd: onEnd ?? Navigator.of(context).pop,
      ),
      builder: (NovelController c) {
        return Obx(() {
          return Stack(
            children: c.layers.objects.value.values
                .expand((e) => e)
                .map((e) => e.build(context))
                .toList(),
          );
        });
      },
    );
  }
}
