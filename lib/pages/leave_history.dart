import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nit_scholar/models/leave_info.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class LeaveHistoryPage extends StatefulWidget {
  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      bool isSuccess = await appState.loginStudent();
      if (isSuccess) {
        await appState.fetchAndSaveLeaveInfo();
      }
      appState.notifyListeners();
    } catch (e) {
      print('异常登录学工系统或获取请假信息: $e');
    }
    setState(() {});
  }

  /// 根据请假类型返回对应的颜色
  Color getLeaveTypeColor(String? type) {
    return MinColor.getCardColor(type ?? '未知类型');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final leaveInfo = appState.leaveInfo.page?.rows;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "请假历史",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: (leaveInfo == null || leaveInfo.isEmpty)
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open,
                            size: 80, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          "暂无请假记录",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: leaveInfo.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    _buildLeaveItem(leaveInfo[index], context),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 跳转到新建请假申请页面
          print('新建请假申请');
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLeaveItem(LeaveApplication leave, BuildContext context) {
    // 如果存在附件图片，则解析图片地址
    final files = leave.files != null ? jsonDecode(leave.files!) : null;
    final imagePath = files != null ? files['path'] : null;
    // 获取当前请假类型对应的颜色
    final typeColor = MinColor.getCardColor(leave.type ?? '未知类型');

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth; // 获取卡片宽度
        final imageHeight = 100.0; // 固定图片高度

        return Container(
          decoration: BoxDecoration(
            color: MinColor.light(
                MinColor.getCardColor(leave.type ?? '未知类型'), 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧彩色装饰条，根据请假类型的颜色
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              // 主体内容区域
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题行：请假类型和请假天数
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            leave.type ?? '未知类型',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: typeColor, // 使用请假类型的颜色
                            ),
                          ),
                          Text(
                            "${leave.days} 天",
                            style: TextStyle(
                              fontSize: 16,
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(MinColor.getCardColor(leave.type ?? '未知类型'),
                          Icons.access_time, "${leave.kssj} - ${leave.jssj}"),
                      SizedBox(height: 4),
                      // 限制文本最多显示两行
                      SizedBox(
                        height: 40, // 固定高度，确保卡片高度一致
                        child: _buildInfoRow(
                          MinColor.getCardColor(leave.type ?? '未知类型'),
                          Icons.note,
                          leave.reason ?? '无说明',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 如果存在图片附件，则在右侧显示缩略图
              if (imagePath != null)
                GestureDetector(
                  onTap: () {
                    // 点击图片时全屏显示
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imageUrl:
                              "http://xgxt.nit.edu.cn:8080/resource/showImg?path=$imagePath",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        "http://xgxt.nit.edu.cn:8080/resource/showImg?path=$imagePath",
                        width: imageHeight,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: imageHeight,
                          height: imageHeight,
                          color: Colors.grey[200],
                          child:
                              Icon(Icons.broken_image, color: Colors.grey[400]),
                        ),
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

  /// 信息行组件：图标 + 文本（支持多行显示）
  Widget _buildInfoRow(Color color, IconData icon, String text,
      {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// 全屏显示图片的 Widget
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
