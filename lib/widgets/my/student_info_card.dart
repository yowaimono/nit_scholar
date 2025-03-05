import 'package:flutter/material.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
// 假设 AppState 提供者在此路径
import 'package:provider/provider.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final personalInfo = appState.personalInfo;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   '学生信息',
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black, // 使用深色主题
          //   ),
          // ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "姓名",
            personalInfo.name,
            icon: Icons.person,
          ),
          _buildInfoRow(
            "学号",
            personalInfo.id,
            icon: Icons.format_list_numbered,
          ),
          _buildInfoRow(
            "性别",
            personalInfo.gender,
            icon: Icons.male,
          ),
          _buildInfoRow(
            "学院",
            personalInfo.college,
            icon: Icons.school,
          ),
          _buildInfoRow(
            "班级",
            personalInfo.className,
            icon: Icons.group,
          ),
          _buildInfoRow(
            "专业",
            personalInfo.major,
            icon: Icons.work,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {IconData icon = Icons.info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: MinColor.fromHex("#5680EC"), // 使用蓝色为主题色
            size: 24,
          ),
          const SizedBox(width: 12), // 增加图标和文本之间的间距
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label：',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700], // 深灰色
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black, // 黑色文本
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
}
