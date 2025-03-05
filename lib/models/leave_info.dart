class LeaveResponse {
  String? errcode;
  String? errmsg;
  Page? page;

  LeaveResponse({this.errcode, this.errmsg, this.page});

  factory LeaveResponse.fromJson(Map<String, dynamic> json) {
    return LeaveResponse(
      errcode: json['errcode'],
      errmsg: json['errmsg'],
      page: json['page'] != null ? Page.fromJson(json['page']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errcode': errcode,
      'errmsg': errmsg,
      'page': page?.toJson(),
    };
  }

  @override
  String toString() {
    return 'LeaveResponse{errcode: $errcode, errmsg: $errmsg, page: $page}';
  }
}

class Page {
  int? pageSize;
  int? page;
  int? total;
  int? records;
  List<LeaveApplication>? rows;
  int? start;
  int? viewEnd;
  int? betweenEnd;
  int? viewStart;

  Page({
    this.pageSize,
    this.page,
    this.total,
    this.records,
    this.rows,
    this.start,
    this.viewEnd,
    this.betweenEnd,
    this.viewStart,
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      pageSize: json['pageSize'],
      page: json['page'],
      total: json['total'],
      records: json['records'],
      rows: json['rows'] != null
          ? List<LeaveApplication>.from(
              json['rows'].map((x) => LeaveApplication.fromJson(x)))
          : null,
      start: json['start'],
      viewEnd: json['viewEnd'],
      betweenEnd: json['betweenEnd'],
      viewStart: json['viewStart'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'page': page,
      'total': total,
      'records': records,
      'rows': rows?.map((x) => x.toJson()).toList(),
      'start': start,
      'viewEnd': viewEnd,
      'betweenEnd': betweenEnd,
      'viewStart': viewStart,
    };
  }
}

class LeaveApplication {
  String? id;
  String? studentId;
  String? type;
  String? kssj;
  String? jssj;
  String? reason;
  String? place;
  String? phone;
  String? telephone;
  String? emergencyPhone;
  String? files;
  int? days;
  String? whenCreated;
  String? status;
  String? whenModified;
  String? remark;
  String? sfxj;
  String? xjsj;
  String? istatus;
  String? datastatus;
  String? stepStatus;
  String? stepName;
  int? isapplyapprove;
  String? lcStatus;
  int? rownum;

  LeaveApplication({
    this.id,
    this.studentId,
    this.type,
    this.kssj,
    this.jssj,
    this.reason,
    this.place,
    this.phone,
    this.telephone,
    this.emergencyPhone,
    this.files,
    this.days,
    this.whenCreated,
    this.status,
    this.whenModified,
    this.remark,
    this.sfxj,
    this.xjsj,
    this.istatus,
    this.datastatus,
    this.stepStatus,
    this.stepName,
    this.isapplyapprove,
    this.lcStatus,
    this.rownum,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['id'],
      studentId: json['student_id'],
      type: json['type'],
      kssj: json['kssj'],
      jssj: json['jssj'],
      reason: json['reason'],
      place: json['place'],
      phone: json['phone'],
      telephone: json['telephone'],
      emergencyPhone: json['emergency_phone'],
      files: json['files'],
      days: json['days'],
      whenCreated: json['when_created'],
      status: json['status'],
      whenModified: json['when_modified'],
      remark: json['remark'],
      sfxj: json['sfxj'],
      xjsj: json['xjsj'],
      istatus: json['istatus'],
      datastatus: json['datastatus'],
      stepStatus: json['step_status'],
      stepName: json['step_name'],
      isapplyapprove: json['isapplyapprove'],
      lcStatus: json['lc_status'],
      rownum: json['rownum_'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'type': type,
      'kssj': kssj,
      'jssj': jssj,
      'reason': reason,
      'place': place,
      'phone': phone,
      'telephone': telephone,
      'emergency_phone': emergencyPhone,
      'files': files,
      'days': days,
      'when_created': whenCreated,
      'status': status,
      'when_modified': whenModified,
      'remark': remark,
      'sfxj': sfxj,
      'xjsj': xjsj,
      'istatus': istatus,
      'datastatus': datastatus,
      'step_status': stepStatus,
      'step_name': stepName,
      'isapplyapprove': isapplyapprove,
      'lc_status': lcStatus,
      'rownum_': rownum,
    };
  }
}
