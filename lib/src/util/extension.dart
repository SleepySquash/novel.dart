import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Determining whether a [BuildContext] is mobile or not.
extension MobileExtensionOnContext on BuildContext {
  /// Returns `true` if [MediaQuery]'s width is less than `600p` on desktop and
  /// [MediaQuery]'s shortest side is less than `600p` on mobile.
  bool get isMobile =>
      GetPlatform.isWindows || GetPlatform.isLinux || GetPlatform.isMacOS
          ? MediaQuery.of(this).size.width < 600
          : MediaQuery.of(this).size.shortestSide < 600;
}
