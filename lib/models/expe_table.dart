

import 'package:flutter/material.dart';
import 'package:nit_scholar/models/Course_view.dart';

class CourseInfo {
  final String info;

  CourseInfo({required this.info});

  factory CourseInfo.fromJson(String json) => CourseInfo(info: json);

  // 转换为原始字符串格式
  String toJson() => info;

  @override
  String toString() => info.isEmpty ? "没课" : info;
}

class DailySchedule {
  final Map<String, CourseInfo> timeSlots;

  DailySchedule({required this.timeSlots});

  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      timeSlots: json.map((key, value) => MapEntry(
            key,
            CourseInfo.fromJson(value is String ? value : "没课"),
          )),
    );
  }

  // 转换为原始天数据格式
  Map<String, dynamic> toJson() {
    return {
      '1-2节': timeSlots['1-2节']?.toJson() ?? '没课',
      '3-4节': timeSlots['3-4节']?.toJson() ?? '没课',
      '5-6节': timeSlots['5-6节']?.toJson() ?? '没课',
      '7-8节': timeSlots['7-8节']?.toJson() ?? '没课',
      '9-10节': timeSlots['9-10节']?.toJson() ?? '没课',
    };
  }

  @override
  String toString() => timeSlots.toString();
}

class WeeklySchedule {
  final int weekNumber;
  final Map<String, DailySchedule> days;

  WeeklySchedule({required this.weekNumber, required this.days});

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      weekNumber: int.parse(json["周次"]),
      days: {
        "周一": DailySchedule.fromJson(json["周一"]),
        "周二": DailySchedule.fromJson(json["周二"]),
        "周三": DailySchedule.fromJson(json["周三"]),
        "周四": DailySchedule.fromJson(json["周四"]),
        "周五": DailySchedule.fromJson(json["周五"]),
        "周六": DailySchedule.fromJson(json["周六"]),
        "周日": DailySchedule.fromJson(json["周日"]),
      },
    );
  }

  // 转换为原始周数据格式
  Map<String, dynamic> toJson() {
    return {
      '周次': weekNumber.toString(),
      '周一': days['周一']?.toJson(),
      '周二': days['周二']?.toJson(),
      '周三': days['周三']?.toJson(),
      '周四': days['周四']?.toJson(),
      '周五': days['周五']?.toJson(),
      '周六': days['周六']?.toJson(),
      '周日': days['周日']?.toJson(),
    };
  }

  @override
  String toString() => "第$weekNumber周课表: $days";
}

class ExperimentSchedule {
  final List<WeeklySchedule> weeks;

  ExperimentSchedule({required this.weeks});

  factory ExperimentSchedule.fromJson(List<dynamic> json) {
    return ExperimentSchedule(
      weeks: json.map((week) => WeeklySchedule.fromJson(week)).toList(),
    );
  }

  Map<int, Map<String, List<CourseView>>> toListView() {
    Map<int, Map<String, List<CourseView>>> result = {};

    for (var week in weeks) {
      Map<String, List<CourseView>> dayMap = {};

      for (var day in week.days.keys) {
        List<CourseView> courses = [];

        // 获取当天的课程信息
        var dailySchedule = week.days[day]!;
        for (var timeSlot in dailySchedule.timeSlots.keys) {
          var courseInfo = dailySchedule.timeSlots[timeSlot]!;

          // 如果课程信息不为空，则解析并构造 CourseView
          if (courseInfo.info.isNotEmpty && courseInfo.info != "没课") {
            // 解析 CourseInfo 的 info 字符串
            final parts = courseInfo.info.split('课程编号：');
            final courseName = parts[0].trim();
            final remaining = parts[1];

            final classParts = remaining.split('班级：');
            //final courseId = classParts[0].trim();
            final remaining2 = classParts[1];

            final addressParts = remaining2.split('地址：');
            //final className = addressParts[0].trim();
            final remaining3 = addressParts[1];

            final timeParts = remaining3.split('节次：');
            final address = timeParts[0].trim();
            final time = timeParts[1].trim();

            // 构造 CourseView 对象
            final courseView = CourseView(
              courseName,
              address,
              CourseView.getCourseColor(courseName),
              '', // 假设没有教师信息
              time, // 假设节次信息作为 weekinfo
            );

            courses.add(courseView);
          } else {
            // 如果课程信息为空，则添加一个空的 CourseView
            courses.add(CourseView('没课', '', Colors.white, '', ''));
          }
        }

        dayMap[day] = courses;
      }

      result[week.weekNumber] = dayMap;
    }

    return result;
  }

  // 转换为原始总数据格式
  List<Map<String, dynamic>> toJson() {
    return weeks.map((week) => week.toJson()).toList();
  }

  @override
  String toString() => "总课表: $weeks";
}
