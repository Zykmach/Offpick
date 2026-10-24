import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The API sends icon names as text. This maps them to Lucide icons.
/// "jeans" and "shoe" have no Lucide icon, they are drawn by AppIcon.
class AppIcons {
  static const Map<String, IconData> byKey = {
    'shirt': LucideIcons.shirt,
    'tshirt': LucideIcons.shirt,
    'bag': LucideIcons.shoppingBag,
    'handbag': LucideIcons.handbag,
    'sparkles': LucideIcons.sparkles,
    'laptop': LucideIcons.laptop,
    'phone': LucideIcons.smartphone,
    'watch': LucideIcons.watch,
    'headphones': LucideIcons.headphones,
    'tv': LucideIcons.tv,
    'camera': LucideIcons.camera,
    'droplet': LucideIcons.droplet,
    'palette': LucideIcons.palette,
    'scissors': LucideIcons.scissors,
    'spray': LucideIcons.sprayCan,
    'gem': LucideIcons.gem,
    'tablet': LucideIcons.tablet,
    'battery': LucideIcons.batteryCharging,
    'cable': LucideIcons.cable,
    'grid': LucideIcons.layoutGrid,
    'tag': LucideIcons.tag,
  };

  static const Set<String> customKeys = {'jeans', 'shoe'};

  static IconData of(String key) => byKey[key] ?? LucideIcons.tag;
}
