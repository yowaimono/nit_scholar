import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nit_scholar/models/Course_view.dart';

import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _currentWeek = 1;
  bool _isTheory = true; // 当前是否是理论教学
  bool _showWeekOverrideChip = false;

  int _totalWeek = 20; // 总周数

  late PageController _pageController;

  int _getTotalWeek() {
    final count =
        Provider.of<AppState>(context, listen: false).basicInfo.weeks.length;

    if (count == 0) {
      print('basicInfo.weeks is empty');
      return 20;
    }
    return count;
  }

  @override
  void initState() {
    super.initState();
    _totalWeek = _getTotalWeek();
    _currentWeek = _getWeekIndex(context);
    //
    _pageController = PageController(initialPage: _currentWeek - 1);

    // _currentWeek = 4;
    // 动态初始化当前周次
    // 延迟调用
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _currentWeek = _getWeekIndex(context);
    //   print('当前周次：$_currentWeek');
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _pageController.dispose(); // 确保释放资源
    super.dispose();
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
            print('选择的周次：--------> $week');
            if (_getWeekIndex(context) != week) {
              _showWeekOverrideChip = true;
            } else {
              _showWeekOverrideChip = false;
            }
            setState(() => _currentWeek = week);
            Navigator.pop(context);
          },
          totalWeek: _totalWeek),
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
            side: BorderSide(
              color: MinColor.deep(MinColor.getCourseColor(course.name), 0.3),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: MinColor.getCourseColor(course.name),
          // elevation: 16.0, // 阴影效果
          title: Center(
            child: Text(
              course.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: MinColor.deep(MinColor.getCourseColor(course.name), 0.3),
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: MinColor.getCourseColor(course.name),
              borderRadius: BorderRadius.circular(12.0),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 8.0,
              //     offset: Offset(0, 4),
              //   ),
              // ],
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoRow(Icons.location_on, '地点: ${course.location}',
                    MinColor.deep(MinColor.getCourseColor(course.name), 0.3)),
                // Divider(color: Colors.grey.shade300, height: 1),
                SizedBox(height: 12.0),
                _buildInfoRow(Icons.person, '教师: ${course.teacher}',
                    MinColor.deep(MinColor.getCourseColor(course.name), 0.3)),
                SizedBox(height: 12.0),
                // Divider(color: Colors.grey.shade300, height: 1),
                _buildInfoRow(Icons.date_range, '周次: ${course.weekinfo}',
                    MinColor.deep(MinColor.getCourseColor(course.name), 0.3)),
              ],
            ),
          ),
          // actions: [
          //   Center(
          //     child: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Colors.blue.shade50, Colors.blue.shade100],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //         borderRadius: BorderRadius.circular(20.0),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.blue.shade100,
          //             blurRadius: 6.0,
          //             offset: Offset(2.0, 2.0),
          //           ),
          //         ],
          //       ),
          //       child: TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 16.0, vertical: 8.0),
          //           child: Text(
          //             '关闭',
          //             style: TextStyle(
          //               fontSize: 16.0,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.blue.shade900,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }

// 辅助方法：构建信息行
  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20.0),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.0, color: color),
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
    // final currentSemester = _getCurrentSemester();
    print('总周数：$_totalWeek');
    final appState = Provider.of<AppState>(context);
    _totalWeek = _getTotalWeek();
    print('总周数：$_totalWeek');

    // 获取当前周次
    final calculatedCurrentWeek = _getWeekIndex(context);
    print('currentWeek: $calculatedCurrentWeek');

    // 拿到课表，两个都拿
    final _tSchedule = appState.schedule.toListView();
    final _eSchedule = appState.expeSchedule.toListView();
    print('理论课表：$_tSchedule');
    print('实验课表：$_eSchedule');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MinColor.fromHex("#F9F9F9"),
        automaticallyImplyLeading: false,
        // elevation: 8.0, // 阴影效果，让边框更明显
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black54, // 边框颜色
            width: 0.3, // 边框宽度
          ),
        ),
        title: Column(
          children: [
            Text(
              _isTheory ? '理论教学' : '实验教学',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MinColor.fromHex("#333333")),
            ),
            Text(
              '第 $_currentWeek 周',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
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
      body: Stack(
        // 使用 Stack 以便在右下角添加提示
        children: [
          PageView.builder(
            itemCount: _totalWeek, // 总周数，例如 16 周
            controller: _pageController, // 设置初始页面
            onPageChanged: (index) {
              setState(() {
                _currentWeek = index + 1; // 假设从第 1 周开始
                print('周次改变：$_currentWeek');

                // 检查当前周次是否与 _getWeekIndex 不一致
                if (_getWeekIndex(context) != index + 1) {
                  _showWeekOverrideChip = true;
                } else {
                  _showWeekOverrideChip = false;
                }
              });
            },
            itemBuilder: (context, index) {
              return _buildWeeklyPage(
                  currentWeek: _currentWeek + 1,
                  schedule: _isTheory
                      ? _tSchedule
                      : _eSchedule); // 渲染第 (index + 1) 周的课表
            },
          ),
          // 右下角提示
          Positioned(
            right: 5,
            bottom: 16,
            child: AnimatedOpacity(
              opacity: _showWeekOverrideChip ? 1.0 : 0.0, // 控制提示的显示
              duration: const Duration(milliseconds: 300), // 动画时长
              child: SizedBox(
                width: 120.0, // 设置宽度
                height: 40.0, // 设置高度
                child: ActionChip(
                  label: const Text(
                    '切换本周',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // 获取当前周次
                    print('切换本周');
                    final targetWeek = _getWeekIndex(context);
                    final targetPage = targetWeek - 1; // 转换为 PageView 的页码
                    
                    // 跳转到目标页面
                    _pageController.jumpToPage(targetPage);

                    // 更新当前周次
                    setState(() {
                      _currentWeek = targetWeek;
                    });
                  },
                  backgroundColor: Colors.blue.shade500,
                  elevation: 4,
                  pressElevation: 8, // 按压时的阴影效果
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeeklyPage(
      {required int currentWeek,
      required Map<int, Map<String, List<CourseView>>> schedule}) {
    final weekDates = _getWeekDates(currentWeek: currentWeek); // 获取当前周的日期
    print("weekDates: $weekDates");
    return Column(
      children: [
        _buildWeekHeader(
          weekDates: weekDates, // 传入当前周的日期
          currentWeek: currentWeek, // 当前周次
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeColumn(),
                Expanded(
                  child: _buildCourseGrid(schedule, currentWeek),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getWeekDates({required int currentWeek}) {
    var WeekDays = <String>[];
    //获取开始时间结束时间
    final dateInfo =
        Provider.of<AppState>(context, listen: false).basicInfo.dateInfo;
    final startDateTime = dateInfo.startDate;
    // 计算currentWeek周的七天日期
    final daysSinceStart = (currentWeek - 1) * 7;
    final weekStart = startDateTime.add(Duration(days: daysSinceStart));
    for (var i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStr = '${day.day}';
      WeekDays.add(dayStr);
    }
    return WeekDays;
  }

  int _getMonth(int currentWeek) {
    int month;
    final dateInfo =
        Provider.of<AppState>(context, listen: false).basicInfo.dateInfo;
    final startDateTime = dateInfo.startDate;
    // 拿到currentWeek在第几个月
    final daysSinceStart = (currentWeek - 1) * 7;
    final weekStart = startDateTime.add(Duration(days: daysSinceStart));
    month = weekStart.month;
    return month;
  }

  Widget _buildWeekHeader(
      {required List<String> weekDates, required int currentWeek}) {
    final now = DateTime.now();
    final month = _getMonth(currentWeek);
    final weekDays = ['一', '二', '三', '四', '五', '六', '日'];
    final currentDay = '0${now.day}';

    return Container(
      color: MinColor.fromHex("#F9F9F9"),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$month', style: const TextStyle(fontSize: 12)),
                    const Text('月', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: List.generate(7, (index) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(weekDays[index],
                              style: const TextStyle(fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: weekDates[index] == currentDay
                                  ? Colors.blue.shade100
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              weekDates[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: weekDates[index] == currentDay
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
          // Text('第 $currentWeek 周',
          //     style:
          //         const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 35,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: MinColor.fromHex("#F9F9F9")),
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

  Widget _buildCourseGrid(
      Map<int, Map<String, List<CourseView>>> schedule, int currentWeek) {
    final weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    return Row(
      // 将 CourseGrid 包装为 Row，列优先布局
      children: weekDays
          .map((day) => Expanded(
                // 每一列代表一天
                child: Column(
                  children: List.generate(6, (index) {
                    // 固定渲染六个格子
                    final courses = schedule[currentWeek]?[day] ?? [];
                    final course = (index < courses.length)
                        ? courses[index]
                        : CourseView(
                            '没课', '', MinColor.fromHex("#F9F9F9"), '', '');
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
          borderRadius: BorderRadius.circular(8),
          border: course.name != '没课'
              ? Border.all(
                  color: MinColor.deep(course.color, 0.3),
                )
              : null,
          color: course.name != '没课' ? course.color : Colors.transparent,
          // boxShadow: course.name != '没课'
          //     ? [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 4,
          //           offset: const Offset(0, 2),
          //         ),
          //       ]
          //     : null,
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
                        "${course.location}@${course.name}\n${course.teacher}\n${course.weekinfo}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinColor.deep(course.color, 0.3),
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
  final totalWeek;

  const _WeekSelectionPanel({
    required this.currentWeek,
    required this.onWeekSelected,
    required this.totalWeek,
  });

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 5; // 每行显示的数量
    final itemCount = totalWeek; // 总数量
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
                onPressed: () {
                  onWeekSelected(index + 1);
                },
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
