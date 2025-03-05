import 'package:flutter/material.dart';
import 'package:nit_scholar/models/exam_info.dart';

import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:provider/provider.dart';

class ExamPlanPage extends StatefulWidget {
  const ExamPlanPage({super.key});

  @override
  State<ExamPlanPage> createState() => _ExamPlanPageState();
}

class _ExamPlanPageState extends State<ExamPlanPage> {
  // 假数据

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    List<ExamInfo> exams = appState.examSchedule.exams; // 从服务器获取考试数据

    List<ExamInfo> exams_test = [
      ExamInfo(
        examId: "1",
        courseId: "C101",
        examCode: "E101",
        courseCode: "CS101",
        courseName: "计算机基础",
        examTime: "2025-02-01 08:00~10:00", // 已结束
        classroomName: "教学楼A101",
        examCampus: "南校区",
        campusName: "主校区",
        teacherName: "张老师",
        teacherId: "T001",
        rowNumber: 1,
      ),
      ExamInfo(
        examId: "2",
        courseId: "C102",
        examCode: "E102",
        courseCode: "MATH101",
        courseName: "高等数学",
        examTime: "2025-02-07 09:00~11:00", // 进行中（假设当前时间为 2025-02-07 10:00）
        classroomName: "教学楼B202",
        examCampus: "北校区",
        campusName: "主校区",
        teacherName: "李老师",
        teacherId: "T002",
        rowNumber: 2,
      ),
      ExamInfo(
        examId: "3",
        courseId: "C103",
        examCode: "E103",
        courseCode: "PHYS101",
        courseName: "大学物理",
        examTime: "2025-02-08 14:00~16:00", // 1天后
        classroomName: "实验楼C303",
        examCampus: "南校区",
        campusName: "主校区",
        teacherName: "王老师",
        teacherId: "T003",
        rowNumber: 3,
      ),
      ExamInfo(
        examId: "4",
        courseId: "C104",
        examCode: "E104",
        courseCode: "ENG101",
        courseName: "大学英语",
        examTime: "2025-02-10 15:00~17:00", // 3天后
        classroomName: "语言楼D404",
        examCampus: "西校区",
        campusName: "主校区",
        teacherName: "赵老师",
        teacherId: "T004",
        rowNumber: 4,
      ),
      ExamInfo(
        examId: "5",
        courseId: "C105",
        examCode: "E105",
        courseCode: "HIST101",
        courseName: "中国历史",
        examTime: "2025-02-11 18:00~20:00", // 4天后
        classroomName: "人文楼E505",
        examCampus: "东校区",
        campusName: "主校区",
        teacherName: "孙老师",
        teacherId: "T005",
        rowNumber: 5,
      ),
      ExamInfo(
        examId: "6",
        courseId: "C106",
        examCode: "E106",
        courseCode: "BIO101",
        courseName: "生物科学",
        examTime: "2025-02-12 07:30~09:30", // 5天后
        classroomName: "理科楼F606",
        examCampus: "北校区",
        campusName: "主校区",
        teacherName: "周老师",
        teacherId: "T006",
        rowNumber: 6,
      ),
      ExamInfo(
        examId: "7",
        courseId: "C107",
        examCode: "E107",
        courseCode: "CHEM101",
        courseName: "基础化学",
        examTime: "2025-02-06 10:00~12:00", // 进行中（假设当前时间为 2025-02-06 11:00）
        classroomName: "化学楼G707",
        examCampus: "南校区",
        campusName: "主校区",
        teacherName: "吴老师",
        teacherId: "T007",
        rowNumber: 7,
      ),
      ExamInfo(
        examId: "8",
        courseId: "C108",
        examCode: "E108",
        courseCode: "ART101",
        courseName: "艺术鉴赏",
        examTime: "2025-02-09 13:30~15:30", // 2天后
        classroomName: "艺术楼H808",
        examCampus: "西校区",
        campusName: "主校区",
        teacherName: "郑老师",
        teacherId: "T008",
        rowNumber: 8,
      ),
      ExamInfo(
        examId: "9",
        courseId: "C109",
        examCode: "E109",
        courseCode: "ECON101",
        courseName: "宏观经济学",
        examTime: "2025-02-13 08:00~10:00", // 6天后
        classroomName: "商学院I909",
        examCampus: "东校区",
        campusName: "主校区",
        teacherName: "何老师",
        teacherId: "T009",
        rowNumber: 9,
      ),
      ExamInfo(
        examId: "10",
        courseId: "C110",
        examCode: "E110",
        courseCode: "PSY101",
        courseName: "心理学导论",
        examTime: "2025-02-14 14:00~16:00", // 7天后
        classroomName: "心理学楼J1010",
        examCampus: "北校区",
        campusName: "主校区",
        teacherName: "许老师",
        teacherId: "T010",
        rowNumber: 10,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MinColor.fromHex('#FFFFFF'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black54, // 边框颜色
            width: 0.3, // 边框宽度
          ),
        ),
        title: const Text(
          '考试安排',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final exam = exams[index];
          final status = _getExamStatus(exam.examTime); // 获取考试状态
          final statusColor = _getStatusColor(status); // 获取状态颜色

          return Card(
            color: MinColor.getCardColor(exam.courseName),
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {
                _showExamDetails(context, exam);
              },
              child: ListTile(
                  title: Text(
                    exam.courseName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 蓝色文本
                    ),
                  ),
                  subtitle: Text(
                    '考试时间: ${exam.examTime}\n教室: ${exam.classroomName}',
                    style: TextStyle(
                        color: Colors.white, // 深灰色文本
                        fontWeight: FontWeight.w800),
                  ),
                  trailing: Container(
                      width: 65,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        // 透明色
                        color: Colors.white.withOpacity(0.5), // 设置半透明的白色
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ))),
            ),
          );
        },
      ),
    );
  }

  // 获取考试状态
  String _getExamStatus(String examTime) {
    final examTimeParts = examTime.split(' ');
    final dateParts = examTimeParts[0].split('-');
    final timeParts = examTimeParts[1].split('~');
    final startTimeParts = timeParts[0].split(':');
    final endTimeParts = timeParts[1].split(':');

    final startTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );

    final endTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );

    final now = DateTime.now();

    if (now.isAfter(endTime)) {
      return '已结束';
    } else if (now.isBefore(startTime)) {
      final difference = startTime.difference(now);
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;

      if (days > 0) {
        // 如果时间差大于一天
        return '$days day';
      } else if (hours > 0) {
        // 如果时间差大于一小时但小于一天
        return '${hours}h${minutes}m';
      } else {
        // 如果时间差小于一小时
        return '$minutes m';
      }
    } else {
      return '进行中';
    }
  }

  // 获取状态颜色
  Color _getStatusColor(String status) {
    if (status.contains('已结束')) {
      return Colors.red; // 灰色
    } else if (status.contains('进行中')) {
      return Colors.blue; // 蓝色
    } else {
      return Colors.green; // 绿色
    }
  }

  void _showExamDetails(BuildContext context, ExamInfo exam) {
    // 解析考试时间
    final examTimeParts = exam.examTime.split(' ');
    final dateParts = examTimeParts[0].split('-');
    final timeParts = examTimeParts[1].split('~');
    final startTimeParts = timeParts[0].split(':');
    final endTimeParts = timeParts[1].split(':');

    final startTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );

    final endTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );

    final now = DateTime.now();

    String timeStatus = '';
    if (now.isAfter(endTime)) {
      timeStatus = '考试已结束';
    } else if (now.isBefore(startTime)) {
      final difference = startTime.difference(now);
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      timeStatus = '距离考试还有 $days 天 $hours 小时 $minutes 分钟';
    } else {
      timeStatus = '考试正在进行中';
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor:
              MinColor.light(MinColor.getCardColor(exam.courseName), 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: MinColor.deep(
                          MinColor.getCardColor(exam.courseName), 0.3),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '考试详情',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: MinColor.deep(
                              MinColor.getCardColor(exam.courseName), 0.3)),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 内容
                _buildSimpleDetailItem(
                    '课程名称', exam.courseName, exam.courseName),
                _buildSimpleDetailItem('考试时间', exam.examTime, exam.courseName),
                _buildSimpleDetailItem(
                    '教室名称', exam.classroomName, exam.courseName),
                _buildSimpleDetailItem(
                    '考试校区', exam.examCampus, exam.courseName),
                _buildSimpleDetailItem(
                    '校区名称', exam.campusName, exam.courseName),
                _buildSimpleDetailItem(
                    '教师姓名', exam.teacherName, exam.courseName),
                SizedBox(height: 16),

                // 考试状态提示
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: MinColor.light(
                            MinColor.getCardColor(exam.courseName), 0.3),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        timeStatus,
                        style: TextStyle(
                          fontSize: 14,
                          color: MinColor.light(
                              MinColor.getCardColor(exam.courseName), 0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // // 底部装饰
                // Align(
                //   alignment: Alignment.center,
                //   child: Icon(
                //     Icons.sentiment_very_satisfied,
                //     color: Colors.blue.shade200,
                //     size: 24,
                //   ),
                // ),

                // 关闭按钮
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '关闭',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: MinColor.deep(
                            MinColor.getCardColor(exam.courseName), 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 简洁风的每一项内容
  Widget _buildSimpleDetailItem(String label, String value, String courseName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: MinColor.deep(MinColor.getCardColor(courseName), 0.3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: MinColor.deep(MinColor.getCardColor(courseName), 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
