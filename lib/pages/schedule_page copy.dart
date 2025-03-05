import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nit_scholar/models/Course_view.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:provider/provider.dart';

class Course {
  final String name;
  final String location;
  final Color color;
  final String teacher;
  final String weekinfo;

  Course(this.name, this.location, this.color, this.teacher, this.weekinfo);
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _currentWeek = 1;
  bool _isTheory = true; // 当前是否是理论教学

  @override
  void initState() {
    super.initState();
    // 动态初始化当前周次
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentWeek = _getWeekIndex(context);
      print('当前周次：$_currentWeek');
      setState(() {});
    });
  }

  // 根据课程名称获取颜色
  // 根据课程名称获取颜色（静态方法）

  // 修改后的时间轴，仅保留课程时间段
  final _ExpetimeSlots = [
    {'label': '1-2', 'start': '08:30', 'end': '10:05'},
    {'label': '3-4', 'start': '10:30', 'end': '12:00'},
    {'label': '5-6', 'start': '14:00', 'end': '15:35'},
    {'label': '7-8', 'start': '15:55', 'end': '17:30'},
    {'label': '9-10', 'start': '19:00', 'end': '20:30'},
  ];

  final _timeSlots = [
    {'label': '1-2', 'start': '08:30', 'end': '10:05'},
    {'label': '3-4', 'start': '10:30', 'end': '12:00'},
    {'label': '5-6', 'start': '14:00', 'end': '15:35'},
    {'label': '7-8', 'start': '15:55', 'end': '17:30'},
    {'label': '9-10', 'start': '19:00', 'end': '20:30'},
    {'label': '11-12', 'start': '20:45', 'end': '22:15'},
  ];

  // 理论教学数据
  // final Map<int, Map<String, List<Course>>> _theorySchedule = {
  //   15: {
  //     '周一': [
  //       Course('软件工程', '(北B306)', _getCourseColor('软件工程'), '李老师', '1-2'),
  //       Course(
  //           '概率论与数理统计', '(南C103)', _getCourseColor('概率论与数理统计'), '王老师', '1-2'),
  //     ],
  //     '周二': [
  //       Course('计算机网络', '(北B402)', _getCourseColor('计算机网络'), '李老师', '3-4'),
  //       Course('机器学习', '(南B309)', _getCourseColor('机器学习'), '李老师', '3-4'),
  //     ],
  //     // 其他天数据...
  //   },
  // };

  // // 实验教学数据
  // final Map<int, Map<String, List<Course>>> _experimentSchedule = {
  //   15: {
  //     '周一': [
  //       Course('软件工程实验', '(北B306)', _getCourseColor('软件工程实验'), '李老师', '1-2'),
  //       Course('概率论实验', '(南C103)', _getCourseColor('概率论实验'), '王老师', '1-2'),
  //     ],
  //     '周二': [
  //       Course('计算机网络实验', '(北B402)', _getCourseColor('计算机网络实验'), '李老师', '3-4'),
  //       Course('机器学习实验', '(南B309)', _getCourseColor('机器学习实验'), '李老师', '1-2'),
  //     ],
  //     // 其他天数据...
  //   },
  // };

  // 获取当前学期
  String _getCurrentSemester() {
    final now = DateTime.now();
    final currentYear = now.year;
    final firstSemesterStart = DateTime(currentYear, 9, 1);
    final secondSemesterStart = DateTime(currentYear + 1, 2, 1);
    final summerStart = DateTime(currentYear + 1, 7, 1);

    if (now.isAfter(firstSemesterStart) && now.isBefore(secondSemesterStart)) {
      return '${currentYear}-${currentYear + 1} 第1学期';
    } else if (now.isAfter(secondSemesterStart) && now.isBefore(summerStart)) {
      return '${currentYear}-${currentYear + 1} 第2学期';
    } else {
      return '${currentYear}-${currentYear + 1} 假期';
    }
  }

  void _showWeekSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _WeekSelectionPanel(
        currentWeek: _currentWeek,
        onWeekSelected: (week) {
          setState(() => _currentWeek = week);
          Navigator.pop(context);
        },
      ),
    );
  }

  static int _getWeekIndex(BuildContext context) {
    final now = DateTime.now();
    final appState = Provider.of<AppState>(context, listen: false);
    // 确保已经被初始化

    final dateInfo = appState.basicInfo.dateInfo;

    // 确保 semesterInfo 是有效的

    final startDateTime = dateInfo.startDate;
    final endDateTime = dateInfo.endDate;

    print('startDateTime: $startDateTime');
    print('endDateTime: $endDateTime');

    // final startDateTime = DateTime.parse(start);
    // final endDateTime = DateTime.parse(end);

    // 如果当前日期早于开学日期，返回第 1 周
    if (now.isBefore(startDateTime)) {
      return 1;
    }

    // 如果当前日期晚于或等于放假日期，返回最后一周
    if (now.isAfter(endDateTime) || now.isAtSameMomentAs(endDateTime)) {
      final totalDays = endDateTime.difference(startDateTime).inDays;
      final totalWeeks = (totalDays / 7).ceil();
      return totalWeeks;
    }

    // 如果当前日期在学期期间，计算当前是第几周
    final daysSinceStart = now.difference(startDateTime).inDays;
    final currentWeek = (daysSinceStart / 7).floor() + 1;

    return currentWeek;
  }

  void _showCourseDetails(BuildContext context, CourseView course) {
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
          elevation: 16.0, // 阴影效果
          title: Center(
            child: Text(
              course.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoRow(Icons.location_on, '地点: ${course.location}'),
                Divider(color: Colors.grey.shade300, height: 1),
                _buildInfoRow(Icons.person, '教师: ${course.teacher}'),
                Divider(color: Colors.grey.shade300, height: 1),
                _buildInfoRow(Icons.date_range, '周次: ${course.weekinfo}'),
              ],
            ),
          ),
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 6.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      '关闭',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 辅助方法：构建信息行
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20.0),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // 切换理论教学和实验教学
  void _toggleSchedule() {
    setState(() {
      _isTheory = !_isTheory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSemester = _getCurrentSemester();

    final appState = Provider.of<AppState>(context);
    _currentWeek = _getWeekIndex(context);
    // print('1schedule: ${appState.schedule.toJson()}');
    // print('2schedule: ${appState.expeSchedule.toJson()}');
    print('currentWeek: ${_getWeekIndex(context)}');
    // 拿到课表，两个都拿
    final _tSchedule = appState.schedule.toListView();
    final _eSchedule = appState.expeSchedule.toListView();
    print('理论课表：$_tSchedule');
    print('实验课表：$_eSchedule');
    // final _eSchedule = appState.ex;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              _isTheory ? '理论教学' : '实验教学',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              currentSemester,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            color: Colors.black54,
            onPressed: _toggleSchedule,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_sharp),
            color: Colors.black54,
            onPressed: () => _showWeekSelector(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeekHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeColumn(),
                  Expanded(
                    child: _buildCourseGrid(
                      _isTheory ? _tSchedule : _eSchedule,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  // 获取这周的七天的日期
  List<String> _getWeekDates() {
    // 按当前周判断
    // 拿到开学日期和放假日期
    final appState = Provider.of<AppState>(context);
    final dateInfo = appState.basicInfo.dateInfo;
    final startDateTime = dateInfo.startDate;
    final endDateTime = dateInfo.endDate;

    final currentWeek = _currentWeek;
    // 拿到这周七天的日期
    final weekDays = List.generate(7, (index) {
      final day =
          startDateTime.add(Duration(days: index + 7 * (currentWeek - 1)));
      return day.toString().substring(8, 10);
    });
    return weekDays;

    // final now = DateTime.now();
    // final weekday = now.weekday;
    // final start = now.subtract(Duration(days: weekday - 1));
    // // final end = start.add(Duration(days: 6));
    // var list = List.generate(
    //     7,
    //     (index) =>
    //         start.add(Duration(days: index)).toString().substring(0, 10));
    // list = list.map((date) => date.substring(8, 10)).toList();
    // return list;
  }

  Widget _buildWeekHeader() {
    final now = DateTime.now();
    final month = "${now.month}月";
    final weekDays = ['一', '二', '三', '四', '五', '六', '日'];
    final dates = _getWeekDates(); // 假设返回 ["1", "2", ..., "7"]

    final currentDay = '0${now.day}'; // 假设当前日期是 3 号

    print("currentDay: $currentDay");

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              // 左侧月份列
              SizedBox(
                width: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month.substring(0, 1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '月',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // 右侧七天等分布局
              Expanded(
                child: Row(
                  children: List.generate(7, (index) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 星期文本
                          Text(
                            weekDays[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          // 日期文本
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: dates[index] == currentDay
                                  ? Colors.blue.shade100
                                  : Colors.transparent, // 只有当前日期有背景颜色
                              borderRadius: BorderRadius.circular(8.0), // 圆角效果
                            ),
                            child: Text(
                              dates[index].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: dates[index] == currentDay
                                    ? Colors.blue.shade900
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 35,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: _isTheory
            ? _timeSlots
                .map((timeSlot) => Container(
                      height: 150, // 增加高度
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeSlot['label']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeSlot['start']!,
                            style: const TextStyle(fontSize: 8),
                          ),
                          Text(
                            timeSlot['end']!,
                            style: const TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ))
                .toList()
            : _ExpetimeSlots.map((timeSlot) => Container(
                  height: 150, // 增加高度
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeSlot['label']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeSlot['start']!,
                        style: const TextStyle(fontSize: 8),
                      ),
                      Text(
                        timeSlot['end']!,
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                )).toList(),
      ),
    );
  }

  Widget _buildCourseGrid(Map<int, Map<String, List<CourseView>>> schedule) {
    final weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    return Row(
      // 将 CourseGrid 包装为 Row，列优先布局
      children: weekDays
          .map((day) => Expanded(
                // 每一列代表一天
                child: Column(
                  children: List.generate(6, (index) {
                    // 固定渲染六个格子
                    final courses = schedule[_currentWeek]?[day] ?? [];
                    final course = (index < courses.length)
                        ? courses[index]
                        : CourseView('没课', '', Colors.white, '', '');
                    return SizedBox(
                      height: 150, // 每节课的高度
                      child: _buildCourseCell(course),
                    );
                  }),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCourseCell(CourseView course) {
    return GestureDetector(
      // 直接返回 GestureDetector，移除 Expanded
      onTap: (course.name != '没课')
          ? () => _showCourseDetails(context, course)
          : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: course.name != '没课' ? course.color : Colors.transparent,
          boxShadow: course.name != '没课'
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: (course.name == '没课')
            ? null
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // 此处 Expanded 是合法的，因为父级 Column 是 Flex 布局
                      child: AutoSizeText(
                        "${course.name}${course.location}\n${course.teacher}\n${course.weekinfo}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _WeekSelectionPanel extends StatelessWidget {
  final int currentWeek;
  final ValueChanged<int> onWeekSelected;

  const _WeekSelectionPanel({
    required this.currentWeek,
    required this.onWeekSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 5; // 每行显示的数量
    const itemCount = 20; // 总数量
    const itemHeight = 60.0; // 缩小按钮高度
    const verticalSpacing = 12.0; // 增加垂直间距
    const horizontalSpacing = 12.0; // 增加水平间距

    final rowCount = (itemCount / crossAxisCount).ceil();
    final panelHeight =
        80.0 + (rowCount * itemHeight) + ((rowCount - 1) * verticalSpacing);

    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      height: panelHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '选择周次',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // 增大标题字体
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: verticalSpacing, // 垂直间距
                crossAxisSpacing: horizontalSpacing, // 水平间距
                childAspectRatio: 1, // 保持按钮为正方形
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentWeek == index + 1
                      ? Colors.blue.shade500
                      : Colors.blue.shade50, // 更柔和的背景色
                  foregroundColor: currentWeek == index + 1
                      ? Colors.white
                      : Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // 圆角调整
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 8), // 缩小内边距
                  elevation: 2, // 降低阴影强度
                  shadowColor: Colors.blue.shade100, // 更柔和的阴影颜色
                ),
                onPressed: () => onWeekSelected(index + 1),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // 缩小字体
                    color: currentWeek == index + 1
                        ? Colors.white
                        : Colors.blue.shade800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
