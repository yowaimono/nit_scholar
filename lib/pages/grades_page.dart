import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nit_scholar/pages/leave_history.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:nit_scholar/widgets/grades/custom_refresh.dart';
import 'package:provider/provider.dart';
import 'package:nit_scholar/models/course_grade.dart';
import 'package:nit_scholar/models/course_response.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  static final List<Color> _predefinedColors = [
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
  ];

  static Color _getCourseColor(String courseName) {
    final hashCode = courseName.hashCode;
    final index = hashCode.abs() % _predefinedColors.length;
    return _predefinedColors[index];
  }

  static String _getCurrentSemester() {
    // TODO: 实现获取当前学期的方法
    // 获取当前时间
    // 根据当前时间判断当前学期
    // 如果当前属于上半年2-8，则是current_year - 1 - current_year-2 学期
    // 如果当前属于下半年9-12，则是current_year-current_year+1 - 1 学期
    final now = DateTime.now();
    final current_year = now.year;
    final current_month = now.month;
    if (current_month >= 2 && current_month <= 8) {
      return '${current_year - 1}-${current_year}-2';
    } else if (current_month >= 9 && current_month <= 12 ||
        current_month == 1) {
      return '${current_year}-${current_year + 1}-1';
    }
    return '${current_year}-${current_year + 1}-1';
  }

  bool _isListView = true;
  String _currentSemester = '全部';

  void _toggleViewMode() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  void _changeSemester(String newSemester) {
    setState(() {
      _currentSemester = newSemester;
    });
  }

  // Color _getColorFromCourseName(String courseName) {
  //   return _getCourseColor(courseName);
  // }

  void _showGradeDetails(BuildContext context, CourseGrade grade) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // 设置对话框的形状
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // 对话框圆角
            side: BorderSide(
                color: MinColor.deep(MinColor.getCourseColor(grade.kcMc), 0.3),
                width: 2),
          ),

          elevation: 10, // 提升一点阴影，增强立体感
          backgroundColor: MinColor.getCourseColor(grade.kcMc), // 纯白色背景
          child: Container(
            width: 320, // 固定宽度，模拟一页纸的尺寸
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 蓝色书签装饰
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: MinColor.deep(
                          MinColor.getCourseColor(grade.kcMc), 0.3), // 蓝色书签
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      // border: Border.all(
                      //     color: MinColor.deep(
                      //         MinColor.getCourseColor(grade.kcMc), 0.3),
                      //     width: 2),
                    ),
                    child: const Icon(
                      Icons.bookmark_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 标题
                Text(
                  grade.kcMc,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MinColor.deep(
                        MinColor.getCourseColor(grade.kcMc), 0.3), // 蓝色标题
                    fontFamily: 'Lobster', // 如果需要手写风字体
                  ),
                ),
                const SizedBox(height: 8),
                // 纸张纹理装饰
                Container(
                  width: double.infinity,
                  height: 2,
                  color: MinColor.deep(
                      MinColor.getCourseColor(grade.kcMc), 0.3), // 模拟纸张蓝色纹理
                ),
                const SizedBox(height: 16),
                // 课程信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("课程代码: ${grade.kch}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("开课单位: ${grade.ksdw}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("学分: ${grade.xf}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("学时: ${grade.zxs}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("考试方式: ${grade.ksfs ?? '未知'}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("课程属性: ${grade.kcsx}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("成绩: ${grade.zcj}",
                        style: TextStyle(
                            color: grade.zcj > 60
                                ? MinColor.deep(
                                    MinColor.getCourseColor(grade.kcMc), 0.5)
                                : Colors.red[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("绩点: ${grade.jd}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                    Text("考试性质: ${grade.ksxz}",
                        style: TextStyle(
                            color: MinColor.deep(
                                MinColor.getCourseColor(grade.kcMc), 0.3))),
                  ],
                ),
                // const SizedBox(height: 24),
                // // 关闭按钮
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //     child: const Text(
                //       '关闭',
                //       style: TextStyle(
                //         color: Colors.blue, // 蓝色文字
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomBarChart(List<CourseGrade> grades) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        final score = grade.zcj?.toDouble() ?? 0.0;
        final color = MinColor.deep(MinColor.getCourseColor(grade.kcMc), 0.3);

        return InkWell(
          onTap: () => _showGradeDetails(context, grade),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 课程名称
                SizedBox(
                  width: 70,
                  child: Text(
                    grade.kcMc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // 分数条
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          width: (MediaQuery.of(context).size.width - 150) *
                              (score / 100),
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withOpacity(0.7),
                                color,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              score.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: score > 60 ? Colors.white : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // 打勾或打叉
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: score >= 60 ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    score >= 60 ? Icons.check : Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradeCard(CourseGrade grade) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: MinColor.deep(MinColor.getCourseColor(grade.kcMc), 0.3),
            width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      color: MinColor.getCourseColor(grade.kcMc),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showGradeDetails(context, grade);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  grade.kcMc,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        MinColor.deep(MinColor.getCourseColor(grade.kcMc), 0.3),
                    fontFamily: 'DancingScript', // 卡通风字体
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.grade,
                color: grade.zcj > 60 ? Colors.yellow[700] : Colors.redAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "${grade.zcj}",
                style: grade.zcj > 60
                    ? TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: MinColor.deep(
                            MinColor.getCourseColor(grade.kcMc), 0.5),
                        fontStyle: FontStyle.italic,
                        fontFamily: 'DancingScript', // 卡通风字体
                      )
                    : const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: 'DancingScript', // 卡通风字体
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterMenu(List<String> semesters) {
    return PopupMenuButton<String>(
      offset: Offset(0, 50), // 向下移动 20 个单位
      icon: Icon(
        Icons.calendar_month_sharp, // 卡通风格的图标
        color: Colors.black54, // 更活泼的图标颜色
      ),
      color: MinColor.fromHex("#F5F5F5"), // 浅蓝色背景
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 更圆润的圆角
        // side: BorderSide(
        //   color: Colors.white, // 白色边框，增强卡通感
        //   width: 2.0,
        // ),
      ),
      elevation: 8, // 增加阴影效果，使卡片更具立体感
      itemBuilder: (context) => semesters.map((semester) {
        return PopupMenuItem<String>(
          value: semester,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                semester,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (semesters.indexOf(semester) != semesters.length - 1)
                const SizedBox(height: 8.0), // 添加上间距
              const Divider(
                height: 1,
                color: Colors.grey, // 自定义颜色
                thickness: 0.5, // 自定义粗细
              ),
              const SizedBox(height: 8.0), // 添加下间距
            ],
          ),
        );
      }).toList(),
      onSelected: _changeSemester,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final courseGrades = _currentSemester == '全部'
        ? appState.allGrades.data
        : appState.allGrades.data
            .where((grade) => grade.xnxqid == _currentSemester)
            .toList();
    // 反转
    courseGrades.sort((a, b) => b.zcj.compareTo(a.zcj));
    final app_semesters = appState.basicInfo.semesterInfo;
    final semesters = [...app_semesters, "全部"];
    List<String> reversedList = semesters.reversed.toList();
    final current_index = reversedList.indexOf(_getCurrentSemester());
    final curremt = _getCurrentSemester();
    print("current: $curremt");
    if (current_index != -1) {
      // 把后面的截掉
      print("current_index: $current_index");
      reversedList.removeRange(current_index + 1, reversedList.length);
    }

    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black54, // 边框颜色
            width: 0.3, // 边框宽度
          ),
        ),
        backgroundColor: MinColor.fromHex("#F9F9F9"), // 更改背景颜色
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.bar_chart_outlined : Icons.list,
                color: Colors.black54),
            onPressed: _toggleViewMode,
          ),
          _buildSemesterMenu(reversedList),
        ],
        // 可选：添加渐变背景
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.blue, Colors.purple],
        //       begin: Alignment.centerLeft,
        //       end: Alignment.centerRight,
        //     ),
        //   ),
        // ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // 如果需要，可以在这里触发数据刷新
          print("刷新数据");
          final appState = Provider.of<AppState>(context, listen: false);
          await appState.login();

          bool isSuccess = await appState.fetchAndSaveAllGrades();
          if (isSuccess) {
            print("刷新成功");
          } else {
            print("刷新失败");
          }
        },
        child: CustomRefreshIndicator(
          builder: (context, child, controller) {
            return Stack(
              children: [
                child,
                if (controller.isRefreshing)
                  Center(
                    child: CustomPaint(
                      painter: CartoonCirclePainter(controller.value),
                      child: SizedBox(width: 100, height: 100),
                    ),
                  ),
              ],
            );
          },
          child: !_isListView
              ? ListView.builder(
                  itemCount: courseGrades.length,
                  itemBuilder: (context, index) {
                    return _buildGradeCard(courseGrades[index]);
                  },
                )
              : _buildCustomBarChart(courseGrades),
        ),
      ),

      // body: RefreshIndicator(
      //   onRefresh: () async {
      //     // 如果需要，可以在这里触发数据刷新
      //     print("刷新数据");
      //     final appState = Provider.of<AppState>(context, listen: false);
      //     await appState.login();

      //     bool isSuccess = await appState.fetchAndSaveAllGrades();
      //     if (isSuccess) {
      //       print("刷新成功");
      //     } else {
      //       print("刷新失败");
      //     }
      //   },
      //   child: _isListView
      //       ? ListView.builder(
      //           itemCount: courseGrades.length,
      //           itemBuilder: (context, index) {
      //             return _buildGradeCard(courseGrades[index]);
      //           },
      //         )
      //       : _buildCustomBarChart(courseGrades),
      // ),
    );
  }
}
