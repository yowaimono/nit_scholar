// 定义单个课程成绩的类
class CourseGrade {
  final String cj0708id;
  final String xnxqid;
  final String kch;
  final String kcMc;
  final String ksdw;
  final String xqmc;
  final double xf;
  final int zxs;
  final String ksfs;
  final String kcsx;
  final String xqstr;
  final int zcj;
  final String zcjstr;
  final int kz;
  final String kcxzmc;
  final String xs0101id;
  final String jx0404id;
  final double jd;
  final String ksxz;
  final int rownum;

  CourseGrade({
    required this.cj0708id,
    required this.xnxqid,
    required this.kch,
    required this.kcMc,
    required this.ksdw,
    required this.xqmc,
    required this.xf,
    required this.zxs,
    required this.ksfs,
    required this.kcsx,
    required this.xqstr,
    required this.zcj,
    required this.zcjstr,
    required this.kz,
    required this.kcxzmc,
    required this.xs0101id,
    required this.jx0404id,
    required this.jd,
    required this.ksxz,
    required this.rownum,
  });

  factory CourseGrade.fromJson(Map<String, dynamic> json) {
    return CourseGrade(
      cj0708id: json['cj0708id'] ?? '',
      xnxqid: json['xnxqid'] ?? '',
      kch: json['kch'] ?? '',
      kcMc: json['kc_mc'] ?? '',
      ksdw: json['ksdw'] ?? '',
      xqmc: json['xqmc'] ?? '',
      xf: json['xf']?.toDouble() ?? 0.0,
      zxs: json['zxs']?.toInt() ?? 0,
      ksfs: json['ksfs'] ?? '',
      kcsx: json['kcsx'] ?? '',
      xqstr: json['xqstr'] ?? '',
      zcj: json['zcj']?.toInt() ?? 0,
      zcjstr: json['zcjstr'] ?? '',
      kz: json['kz']?.toInt() ?? 0,
      kcxzmc: json['kcxzmc'] ?? '',
      xs0101id: json['xs0101id'] ?? '',
      jx0404id: json['jx0404id'] ?? '',
      jd: json['jd']?.toDouble() ?? 0.0,
      ksxz: json['ksxz'] ?? '',
      rownum: json['rownum_']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cj0708id': cj0708id,
      'xnxqid': xnxqid,
      'kch': kch,
      'kc_mc': kcMc,
      'ksdw': ksdw,
      'xqmc': xqmc,
      'xf': xf,
      'zxs': zxs,
      'ksfs': ksfs,
      'kcsx': kcsx,
      'xqstr': xqstr,
      'zcj': zcj,
      'zcjstr': zcjstr,
      'kz': kz,
      'kcxzmc': kcxzmc,
      'xs0101id': xs0101id,
      'jx0404id': jx0404id,
      'jd': jd,
      'ksxz': ksxz,
      'rownum_': rownum,
    };
  }
}

// 定义整个响应数据的类
class CourseGradesResponse {
  final List<CourseGrade> data;
  final int count;
  final String tjsj;
  final String pjxfjdts;
  final int isXsckpscj;

  CourseGradesResponse({
    required this.data,
    required this.count,
    required this.tjsj,
    required this.pjxfjdts,
    required this.isXsckpscj,
  });

  factory CourseGradesResponse.fromJson(Map<String, dynamic> json) {
    List<CourseGrade> data = (json['data'] as List<dynamic>)
        .map((course) => CourseGrade.fromJson(course))
        .toList();
    return CourseGradesResponse(
      data: data,
      count: json['count']?.toInt() ?? 0,
      tjsj: json['tjsj'] ?? '',
      pjxfjdts: json['pjxfjdts'] ?? '',
      isXsckpscj: json['isXsckpscj']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((course) => course.toJson()).toList(),
      'count': count,
      'tjsj': tjsj,
      'pjxfjdts': pjxfjdts,
      'isXsckpscj': isXsckpscj,
    };
  }
}
