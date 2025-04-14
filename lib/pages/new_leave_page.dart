import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart' as android;

class NewLeavePage extends StatefulWidget {
  @override
  _NewLeavePageState createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<NewLeavePage> {
  final TextEditingController _reasonController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  // 获取图片的方法，处理权限请求
  Future getImage() async {
    // 检查平台
    bool isAndroid = Platform.isAndroid;

    // 确定要请求的正确权限
    Permission permission = isAndroid ? Permission.photos : Permission.storage;

    // 检查权限状态
    var status = await permission.status;

    if (status.isGranted) {
      // 权限已授予，继续选择图片
      _pickImage();
    } else if (status.isDenied) {
      // 请求权限
      status = await permission.request();

      if (status.isGranted) {
        // 请求后权限授予，继续选择图片
        _pickImage();
      } else if (status.isPermanentlyDenied) {
        // 权限永久拒绝，显示对话框打开设置
        _showPermissionSettingsDialog();
      } else {
        // 权限拒绝，显示SnackBar
        _showPermissionDeniedSnackbar();
      }
    } else if (status.isPermanentlyDenied) {
      // 权限永久拒绝，显示对话框打开设置
      _showPermissionSettingsDialog();
    } else {
      // 处理其他权限状态（如果需要）
      print("意外的权限状态: $status");
      _showPermissionDeniedSnackbar(); // 兜底方案
    }
  }

  // 实际选择图片的方法
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('未选择图片。');
      }
    });
  }

  // 显示打开应用设置的对话框
  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("存储权限请求"),
          content: Text("要从您的图库中选择图片，请在应用设置中授予存储权限。"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("打开设置"),
              onPressed: () {
                openAppSettings(); // 打开应用设置
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 显示权限拒绝的SnackBar
  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('需要存储权限才能选择图片。'),
        duration: Duration(seconds: 3), // 显示更长时间
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('请假申请', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 实现提交逻辑 (上传图片, 发送理由)
              print('理由: ${_reasonController.text}');
              print('图片路径: ${_image?.path}');
              Navigator.pop(context); // 返回上一页
            },
            child: Text('提交',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '请假理由',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '请填写请假理由...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 24),
            Text(
              '上传附件 (可选)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: getImage, // 使用修改后的 getImage 方法
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                width: double.infinity,
                height: 200,
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload,
                              size: 48, color: Colors.grey[400]),
                          SizedBox(height: 8),
                          Text(
                            '点击上传图片',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
