class SemesterInfoModel {
  final List<String> semesterInfo; // 学期信息列表
  final List<String> weeks; // 周次信息
  final DateInfo dateInfo; // 开始日期和结束日期信息

  // 默认构造函数，带默认值
  SemesterInfoModel({
    this.semesterInfo = const [], // 默认值为空列表
    this.weeks = const [], // 默认值为空列表
    DateInfo? dateInfo, // 可选参数
  }) : dateInfo = dateInfo ?? DateInfo(); // 如果未提供 dateInfo，则使用默认值

  // 从 JSON 转换为 SemesterInfoModel
  factory SemesterInfoModel.fromJson(Map<String, dynamic> json) {
    return SemesterInfoModel(
      semesterInfo: List<String>.from(json['semester_info'] ?? []),
      weeks: List<String>.from(json['weeks'] ?? []),
      dateInfo: json['date_info'] != null
          ? DateInfo.fromJson(json['date_info'])
          : DateInfo(),
    );
  }

  // 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'semester_info': semesterInfo,
      'weeks': weeks,
      'date_info': dateInfo.toJson(),
    };
  }
}

class DateInfo {
  final DateTime startDate; // 开始日期
  final DateTime endDate; // 结束日期

  // 默认构造函数，带默认值
  DateInfo({
    DateTime? startDate, // 可选参数
    DateTime? endDate, // 可选参数
  })  : startDate = startDate ?? DateTime(1970, 1, 1), // 默认开始日期为1970-01-01
        endDate = endDate ?? DateTime(1970, 1, 1); // 默认结束日期为1970-01-01

  // 从 JSON 转换为 DateInfo
  factory DateInfo.fromJson(Map<String, dynamic> json) {
    return DateInfo(
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime(1970, 1, 1),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime(1970, 1, 1),
    );
  }

  // 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
