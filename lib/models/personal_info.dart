class PersonalInfo {
  final String name; // 姓名
  final String id; // 学号
  final String gender; // 性别
  final String college; // 学院
  final String major; // 专业
  final String className; // 班级
  final String origin; // 生源地

  // 默认构造函数，提供默认值
  PersonalInfo({
    this.name = '',
    this.id = '',
    this.gender = '',
    this.college = '',
    this.major = '',
    this.className = '',
    this.origin = '',
  });

  // 工厂构造函数，从 JSON 解析
  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    // 清理 JSON 数据中的空格（包括全角空格）
    final cleanedJson = _cleanJson(json);

    // 从 "姓名和学号" 字段中提取姓名和学号
    final nameAndId = cleanedJson['姓名和学号'] ?? '';
    final parts = nameAndId.split('-');
    final name = parts.isNotEmpty ? parts.first.trim() : '';
    final id = parts.length > 1 ? parts.last.trim() : '';

    // 解析 "其他信息" 字段
    final otherInfo = cleanedJson['其他信息'] as List<dynamic>? ?? [];
    String college = '';
    String major = '';
    String className = '';
    String origin = '';

    for (final info in otherInfo) {
      if (info is String) {
        // 清理键中的全角空格和半角空格
        final cleanedInfo = info.replaceAll(RegExp(r'\s+'), ''); // 移除所有空白字符
        if (cleanedInfo.contains('学院：')) {
          college = cleanedInfo.replaceAll('学院：', '').trim();
        } else if (cleanedInfo.contains('专业：')) {
          major = cleanedInfo.replaceAll('专业：', '').trim();
        } else if (cleanedInfo.contains('班级：')) {
          className = cleanedInfo.replaceAll('班级：', '').trim();
        } else if (cleanedInfo.contains('生源地：')) {
          origin = cleanedInfo.replaceAll('生源地：', '').trim();
        }
      }
    }

    return PersonalInfo(
      name: name,
      id: id,
      gender: cleanedJson['性别'] ?? '',
      college: college,
      major: major,
      className: className,
      origin: origin,
    );
  }

  // 清理 JSON 数据中的空格（包括全角空格）
  static Map<String, dynamic> _cleanJson(Map<String, dynamic> json) {
    final cleanedJson = <String, dynamic>{};
    json.forEach((key, value) {
      // 清理键中的空格（包括全角空格）
      final cleanedKey = key.replaceAll(RegExp(r'\s+'), '');

      // 清理值中的空格（如果是字符串）
      dynamic cleanedValue = value;
      if (value is String) {
        cleanedValue = value.replaceAll(RegExp(r'\s+'), '');
      } else if (value is List) {
        // 如果值是列表，递归清理每个元素
        cleanedValue = value.map((item) {
          if (item is String) {
            return item.replaceAll(RegExp(r'\s+'), '');
          }
          return item;
        }).toList();
      }

      cleanedJson[cleanedKey] = cleanedValue;
    });
    return cleanedJson;
  }

  // 将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      '姓名和学号': '$name-$id',
      '性别': gender,
      '其他信息': [
        '生源地：$origin',
        '学院：$college',
        '专业：$major',
        '班级：$className',
      ],
    };
  }

  @override
  String toString() {
    return 'PersonalInfo{name: $name, id: $id, gender: $gender, college: $college, major: $major, className: $className, origin: $origin}';
  }
}
