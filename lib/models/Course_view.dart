import 'package:flutter/material.dart';
import 'package:nit_scholar/utils/color_util.dart';

class CourseView {
  final String name;
  final String location;
  final Color color;
  final String teacher;
  final String weekinfo;

  // static final List<Color> _predefinedColors = [
  //   MinColor.fromHex("#E5DFF9"),
  //   MinColor.fromHex("#F6E8EA"),
  //   MinColor.fromHex("#F9F3D8"),
  //   MinColor.fromHex("#DDF9F4"),
  //   MinColor.fromHex("#E0ECF7"),
  //   MinColor.fromHex("#E5DFF9"),
  //   MinColor.fromHex("#F5E1F9"), // 浅紫色
  //   MinColor.fromHex("#F9E1E1"), // 浅粉色
  //   MinColor.fromHex("#E1F9E1"), // 浅绿色
  //   MinColor.fromHex("#E1F9F5"), // 浅蓝绿色
  //   MinColor.fromHex("#E1E1F9"), // 浅蓝色
  //   MinColor.fromHex("#F9F5E1"), // 浅黄色
  //   MinColor.fromHex("#F9E1E5"), // 浅玫瑰色
  //   MinColor.fromHex("#E1F9E5"), // 浅薄荷色
  //   MinColor.fromHex("#E5E1F9"), // 浅薰衣草色
  //   MinColor.fromHex("#F9E1EC"), // 浅桃红色
  // ];

  static Color getCourseColor(String courseName) {
    return MinColor.getCourseColor(courseName);
  }

  @override
  String toString() {
    return '$name';
  }

  CourseView(this.name, this.location, this.color, this.teacher, this.weekinfo);

  factory CourseView.fromString(String input) {
    // 假设输入的字符串格式是固定的
    final parts = input.split('课程编号：');
    final courseName = parts[0].trim();
    final remaining = parts[1];

    final classParts = remaining.split('班级：');
    //final courseId = classParts[0].trim();
    final remaining2 = classParts[1];

    final addressParts = remaining2.split('地址：');
    final className = addressParts[0].trim();
    final remaining3 = addressParts[1];

    final timeParts = remaining3.split('节次：');
    final address = timeParts[0].trim();
    final time = timeParts[1].trim();

    final color = getCourseColor(courseName);

    return CourseView(
      courseName,
      address,
      color,
      className, // 假设没有教师信息
      time, // 假设节次信息作为weekinfo
    );
  }
}
