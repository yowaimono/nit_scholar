import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:nit_scholar/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SelfDisciplineSchedulePage extends StatefulWidget {
  const SelfDisciplineSchedulePage({Key? key}) : super(key: key);

  @override
  State<SelfDisciplineSchedulePage> createState() =>
      _SelfDisciplineSchedulePageState();
}

class _SelfDisciplineSchedulePageState
    extends State<SelfDisciplineSchedulePage> {
  List<Map<String, dynamic>> _scheduleItems = [];
  final Color primaryColor = const Color(0xFF2296F3); // 将您喜欢的颜色定义为 primaryColor

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleString = jsonEncode(_scheduleItems);
    await prefs.setString('self_discipline_schedule', scheduleString);
  }

  Future<void> _loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleString = prefs.getString('self_discipline_schedule');
    if (scheduleString != null) {
      setState(() {
        _scheduleItems =
            (jsonDecode(scheduleString) as List).cast<Map<String, dynamic>>();
      });
    }
  }

  void _addScheduleItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddScheduleItemSheet(
            primaryColor:
                primaryColor, // 将 primaryColor 传递给 AddScheduleItemSheet
            onSave: (newItem) {
              setState(() {
                _scheduleItems.add(newItem);
                _saveSchedule();
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _scheduleItems[index]['completed'] = !_scheduleItems[index]['completed'];
      _saveSchedule();
    });
  }

  void _editScheduleItem(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddScheduleItemSheet(
            primaryColor: primaryColor, // 传递 primaryColor
            initialItem: _scheduleItems[index],
            onSave: (updatedItem) {
              setState(() {
                _scheduleItems[index] = updatedItem;
                _saveSchedule();
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _deleteScheduleItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认删除', style: GoogleFonts.poppins()),
          content: Text('您确定要删除这个日程项吗？', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _scheduleItems.removeAt(index);
                  _saveSchedule();
                });
                Navigator.of(context).pop();
              },
              child: Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自律日程',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: primaryColor)),
        iconTheme: IconThemeData(color: primaryColor), // 修改返回箭头颜色
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: primaryColor),
        //     onPressed: _addScheduleItem,
        //   ),
        // ],
        backgroundColor: Colors.white, // 可以设置 AppBar 背景为白色，突出主题色
        elevation: 1, // 添加一个细微的阴影
      ),
      body: _scheduleItems.isEmpty
          ? Center(
              child: Text(
                '暂无日程，点击右上角添加',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _scheduleItems.length,
              itemBuilder: (context, index) {
                final item = _scheduleItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 2, // 稍微增加卡片阴影
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: Checkbox(
                      value: item['completed'] ?? false,
                      onChanged: (value) => _toggleTaskCompletion(index),
                      activeColor: primaryColor, // 修改复选框激活颜色
                    ),
                    title: Text(
                      item['task'] ?? '',
                      style: TextStyle(
                        decoration: (item['completed'] ?? false)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text('时间: ${item['time'] ?? '未设置'}',
                        style: TextStyle(color: Colors.black54)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey.shade600),
                          onPressed: () => _editScheduleItem(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteScheduleItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        // 使用 FloatingActionButton 作为添加按钮
        onPressed: _addScheduleItem,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 调整 FAB 位置
    );
  }
}

class AddScheduleItemSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialItem;
  final Color primaryColor; // 接收 primaryColor

  const AddScheduleItemSheet(
      {Key? key,
      required this.onSave,
      this.initialItem,
      required this.primaryColor})
      : super(key: key);

  @override
  State<AddScheduleItemSheet> createState() => _AddScheduleItemSheetState();
}

class _AddScheduleItemSheetState extends State<AddScheduleItemSheet> {
  final TextEditingController _taskController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _taskController.text = widget.initialItem!['task'] ?? '';
      final timeParts = (widget.initialItem!['time'] as String?)?.split(':');
      if (timeParts != null && timeParts.length == 2) {
        _selectedTime = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1].substring(0, 2)));
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        // 自定义 TimePicker 主题色
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: widget.primaryColor,
            hintColor: widget.primaryColor,
            colorScheme: ColorScheme.light(primary: widget.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialItem == null ? '添加日程' : '编辑日程',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: widget.primaryColor),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _taskController,
            decoration: InputDecoration(
                labelText: '任务名称', border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('时间:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text('${_selectedTime.format(context)}',
                  style: GoogleFonts.poppins()),
              const Spacer(),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text('选择时间',
                    style: GoogleFonts.poppins(color: widget.primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                widget.onSave({
                  'task': _taskController.text,
                  'time': _selectedTime.format(context),
                  'completed': widget.initialItem?['completed'] ?? false,
                });
              },
              child: Text(widget.initialItem == null ? '保存' : '更新',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
