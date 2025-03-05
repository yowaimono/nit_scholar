class ExamInfo {
  final String examId; // 考试ID
  final String courseId; // 课程ID
  final String examCode; // 考试代码
  final String courseCode; // 课程代码
  final String courseName; // 课程名称
  final String examTime; // 考试时间
  final String classroomName; // 教室名称
  final String examCampus; // 考试校区
  final String campusName; // 校区名称
  final String teacherName; // 教师姓名
  final String teacherId; // 教师ID
  final int rowNumber; // 行号

  ExamInfo({
    required this.examId,
    required this.courseId,
    required this.examCode,
    required this.courseCode,
    required this.courseName,
    required this.examTime,
    required this.classroomName,
    required this.examCampus,
    required this.campusName,
    required this.teacherName,
    required this.teacherId,
    required this.rowNumber,
  });

  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      examId: json['kw0410id'] ?? '',
      courseId: json['kw0413id'] ?? '',
      examCode: json['ksccmc'] ?? '',
      courseCode: json['kch'] ?? '',
      courseName: json['kskcmc'] ?? '',
      examTime: json['kssj'] ?? '',
      classroomName: json['js_mc'] ?? '',
      examCampus: json['ksxq'] ?? '',
      campusName: json['xqmc'] ?? '',
      teacherName: json['jsxm'] ?? '',
      teacherId: json['jsid'] ?? '',
      rowNumber: json['rownum_']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kw0410id': examId,
      'kw0413id': courseId,
      'ksccmc': examCode,
      'kch': courseCode,
      'kskcmc': courseName,
      'kssj': examTime,
      'js_mc': classroomName,
      'ksxq': examCampus,
      'xqmc': campusName,
      'jsxm': teacherName,
      'jsid': teacherId,
      'rownum_': rowNumber,
    };
  }
}

class ExamInfoResponse {
  final List<ExamInfo> exams; // 考试信息列表
  final int totalExams; // 总考试数

  ExamInfoResponse({
    required this.exams,
    required this.totalExams,
  });

  factory ExamInfoResponse.fromJson(Map<String, dynamic> json) {
    List<ExamInfo> exams = (json['data'] as List<dynamic>)
        .map((exam) => ExamInfo.fromJson(exam))
        .toList();
    return ExamInfoResponse(
      exams: exams,
      totalExams: json['count']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': exams.map((exam) => exam.toJson()).toList(),
      'count': totalExams,
    };
  }
}
