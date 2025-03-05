import 'dart:ui';

import 'package:flutter/material.dart';

extension MinColor on Color {
  static final List<Color> _predefinedColors = [
    // 现有颜色
    MinColor.fromHex("#E5DFF9"),
    MinColor.fromHex("#F6E8EA"),
    MinColor.fromHex("#F9F3D8"),
    MinColor.fromHex("#DDF9F4"),
    MinColor.fromHex("#E0ECF7"),
    MinColor.fromHex("#E5DFF9"),
    MinColor.fromHex("#F5E1F9"), // 浅紫色
    MinColor.fromHex("#F9E1E1"), // 浅粉色
    MinColor.fromHex("#E1F9E1"), // 浅绿色
    MinColor.fromHex("#E1F9F5"), // 浅蓝绿色
    MinColor.fromHex("#E1E1F9"), // 浅蓝色
    MinColor.fromHex("#F9F5E1"), // 浅黄色
    MinColor.fromHex("#F9E1E5"), // 浅玫瑰色
    MinColor.fromHex("#E1F9E5"), // 浅薄荷色
    MinColor.fromHex("#E5E1F9"), // 浅薰衣草色
    MinColor.fromHex("#F9E1EC"), // 浅桃红色

    // 新增颜色
    MinColor.fromHex("#F0E6FF"), // 浅紫罗兰色
    MinColor.fromHex("#FFEBEB"), // 浅珊瑚粉
    MinColor.fromHex("#CCFFCC"), // 浅青色
    MinColor.fromHex("#D1FFFF"), // 浅天蓝色
    MinColor.fromHex("#FFF8DC"), // 浅米色
    // MinColor.fromHex("#E8F8F5"), // 浅薄荷绿
    MinColor.fromHex("#FDF5E6"), // 浅蛋壳黄
    MinColor.fromHex("#FFFAF0"), // 浅象牙白
    MinColor.fromHex("#F5FFFA"), // 浅蜜瓜绿
    MinColor.fromHex("#FFCCE6"), // 浅芭比粉
    MinColor.fromHex("#E6F5FF"), // 浅海水蓝
    MinColor.fromHex("#FEE1FF"), // 浅薰衣草紫
  ];

  static final List<Color> _cardColors = [
    MinColor.fromHex("#4DC3FE"),
    MinColor.fromHex("#22E5A1"),
    MinColor.fromHex("#FF884E"),
    MinColor.fromHex("#9C74FD"),
    MinColor.fromHex("#4C86FE"),
    // 添加一些同风格的颜色
    MinColor.fromHex("#FF6B6B"), // 鲜艳的红色
    MinColor.fromHex("#FFD93D"), // 明亮的黄色
    MinColor.fromHex("#6BCB77"), // 清新的绿色
    MinColor.fromHex("#4D96FF"), // 稍深的蓝色
    MinColor.fromHex("#B388FF"), // 柔和的紫色
  ];

  static Color getCardColor(String name) {
    final hashCode = name.hashCode;
    final index = hashCode.abs() % _cardColors.length;
    return _cardColors[index];
  }

  static Color getCourseColor(String courseName) {
    final hashCode = courseName.hashCode;
    final index = hashCode.abs() % _predefinedColors.length;
    return _predefinedColors[index];
  }

  static Color fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static Color deep(Color color, double factor) {
    // 确保 factor 在 0 到 1 之间
    factor = factor.clamp(0.0, 1.0);

    // 将颜色转换为 HSL 颜色
    HSLColor hslColor = HSLColor.fromColor(color);

    // 调整亮度，使颜色变深
    double newLightness =
        (hslColor.lightness - (factor * hslColor.lightness)).clamp(0.0, 1.0);

    // 创建新的 HSL 颜色
    HSLColor newHslColor = hslColor.withLightness(newLightness);

    // 返回新的颜色
    return newHslColor.toColor();
  }

  static Color light(Color color, double factor) {
    // 确保 factor 在 0 到 1 之间
    factor = factor.clamp(0.0, 1.0);

    // 将颜色转换为 HSL 颜色
    HSLColor hslColor = HSLColor.fromColor(color);

    // 调整亮度，使颜色变浅
    double newLightness =
        (hslColor.lightness + (1 - hslColor.lightness) * factor)
            .clamp(0.0, 1.0);

    // 创建新的 HSL 颜色
    HSLColor newHslColor = hslColor.withLightness(newLightness);

    // 返回新的颜色
    return newHslColor.toColor();
  }
}
