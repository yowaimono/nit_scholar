import 'package:flutter/material.dart';
import 'package:nit_scholar/pages/exam_plan_page.dart';
import 'package:nit_scholar/pages/grades_page.dart';
import 'package:nit_scholar/pages/leave_history.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:provider/provider.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinColor.fromHex("#F8F8F8"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildOverview(context),
            SizedBox(height: 16),
            _buildAppButton(context),
            SizedBox(height: 16),
            _buildDailySchedule(),
            SizedBox(height: 16),
            _buildLeaveButton(context),
            SizedBox(height: 16),
            _buildDailyQuote(),
          ],
        ),
      ),
    );
  }

  /// 新的顶部概览卡片：展示问候语、天气提示、今日概览等信息
  Widget _buildOverview(BuildContext context) {
    final userInfo = Provider.of<AppState>(context).personalInfo;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // 左侧：问候语和今日概览
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "早上好，${userInfo.name}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "今天阳光明媚，适合外出走走。",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            // 右侧：天气图标
            Icon(
              Icons.wb_sunny,
              size: 48,
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppButton(BuildContext context) {
    return Container(
      height: 80, // 增加高度，允许按钮内容换行
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 减少水平padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Wrap(
        // 使用 Wrap 组件
        alignment: WrapAlignment.spaceEvenly, // 均匀分布
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildAppButtonItem(
            icon: Icons.add_box_sharp,
            label: '请假记录',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LeaveHistoryPage()));
            },
            color: Colors.green,
          ),
          _buildAppButtonItem(
            icon: Icons.grade_outlined,
            label: '成绩查询',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GradesPage()));
            },
            color: Colors.blue,
          ),
          _buildAppButtonItem(
            icon: Icons.people,
            label: '考试安排',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExamPlanPage()));
            },
            color: Colors.orange,
          ),
          _buildAppButtonItem(
            icon: Icons.next_plan,
            label: '自律日程',
            onPressed: () {
              print('自律日程');
            },
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildAppButtonItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // 增加padding
        child: Column(
          // 使用 Column 垂直排列图标和文字
          mainAxisSize: MainAxisSize.min, // 尽可能小
          children: [
            Icon(icon, size: 20, color: color), // 稍微增大图标
            SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black), // 稍微减小文字
            ),
          ],
        ),
      ),
    );
  }

  /// 日程管理模块：展示当天的任务列表
  Widget _buildDailySchedule() {
    // 示例任务列表，可替换为动态数据
    final List<Map<String, dynamic>> scheduleItems = [
      {'task': '起床 & 晨间拉伸', 'completed': false},
      {'task': '早餐 & 阅读', 'completed': false},
      {'task': '线上课程学习', 'completed': false},
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        // 检查是否所有任务已完成
        final allCompleted = scheduleItems.isNotEmpty &&
            scheduleItems.every((item) => item['completed']);

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "今日任务",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(), // 使用 Spacer 分配剩余空间
                  _buildAppButtonItem(
                      icon: Icons.add_box_sharp,
                      label: '添加',
                      onPressed: () {
                        print('添加任务');
                      },
                      color: Colors.blue)
                ],
              ),
              SizedBox(height: 8),
              if (scheduleItems.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "暂无计划",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                )
              else
                ...scheduleItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item['completed'] = !item['completed'];
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: item['completed']
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: item['completed']
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: item['completed']
                                ? Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['task'],
                            style: TextStyle(
                              fontSize: 14,
                              decoration: item['completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              if (allCompleted)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "你真棒！",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 请假申请按钮
  Widget _buildLeaveButton(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                print('请假申请');
              },
              icon: Icon(Icons.add_box_sharp, size: 24, color: Colors.white),
            ),
            Text(
              '请假申请',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// 每日励志语录模块
  Widget _buildDailyQuote() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.lightBlue[50],
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.format_quote, size: 32, color: Colors.lightBlue),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "每一天都是全新开始，努力向前，让梦想照进现实！",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue[800],
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
