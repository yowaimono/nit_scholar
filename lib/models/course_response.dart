// 定义单个课程的类

import 'package:nit_scholar/models/Course_view.dart';

class Course {
  final String timeSlot;
  final String courseName;
  final String teacher;
  final String location;
  final String weekInfo;

  Course({
    required this.timeSlot,
    required this.courseName,
    required this.teacher,
    required this.location,
    required this.weekInfo,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      timeSlot: json['time_slot'] ?? '',
      courseName: json['course_name'] ?? '',
      teacher: json['teacher'] ?? '',
      location: json['location'] ?? '',
      weekInfo: json['week_info'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time_slot': timeSlot,
      'course_name': courseName,
      'teacher': teacher,
      'location': location,
      'week_info': weekInfo,
    };
  }
}

// 定义一周的课程安排
class WeekSchedule {
  final Map<String, List<Course>> days;

  WeekSchedule({required this.days});

  factory WeekSchedule.fromJson(Map<String, dynamic> json) {
    Map<String, List<Course>> days = {};
    json.forEach((day, courses) {
      days[day] = (courses as List<dynamic>)
          .map((course) => Course.fromJson(course))
          .toList();
    });
    return WeekSchedule(days: days);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    days.forEach((day, courses) {
      json[day] = courses.map((course) => course.toJson()).toList();
    });
    return json;
  }
}

// 定义整个课程表
class Schedule {
  final List<WeekSchedule> weeks;

  Schedule({required this.weeks});

  Map<int, Map<String, List<CourseView>>> toListView() {
    Map<int, Map<String, List<CourseView>>> result = {};
    for (int i = 0; i < weeks.length; i++) {
      Map<String, List<CourseView>> dayCourses = {};
      for (String day in weeks[i].days.keys) {
        List<CourseView> courseViews = [];
        for (Course course in weeks[i].days[day]!) {
          courseViews.add(CourseView(
            course.courseName,
            course.location,
            CourseView.getCourseColor(course.courseName),
            course.teacher,
            course.weekInfo,
          ));
        }
        dayCourses[day] = courseViews;
      }
      result[i + 1] = dayCourses;
    }
    return result;
  }

  factory Schedule.fromJson(List<dynamic> json) {
    List<WeekSchedule> weeks = json
        .map((week) => WeekSchedule.fromJson(week as Map<String, dynamic>))
        .toList();
    return Schedule(weeks: weeks);
  }

  List<Map<String, dynamic>> toJson() {
    return weeks.map((week) => week.toJson()).toList();
  }
}
