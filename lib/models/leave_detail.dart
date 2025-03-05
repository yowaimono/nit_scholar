class LeaveDetail {
  List<String>? qzrq;
  Form? form;
  StepsInfo? stepsInfo;

  LeaveDetail({this.qzrq, this.form, this.stepsInfo});

  factory LeaveDetail.fromJson(Map<String, dynamic> json) {
    return LeaveDetail(
      qzrq: json['qzrq'] != null ? List<String>.from(json['qzrq']) : null,
      form: json['form'] != null ? Form.fromJson(json['form']) : null,
      stepsInfo: json['steps_info'] != null
          ? StepsInfo.fromJson(json['steps_info'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qzrq': qzrq,
      'form': form?.toJson(),
      'steps_info': stepsInfo?.toJson(),
    };
  }
}

class Form {
  String? xh;
  String? studentId;
  String? xm;
  String? xb;
  String? mz;
  String? xy;
  String? zy;
  String? bjmc;
  String? nj;
  String? type;
  String? kssj;
  String? jssj;
  String? days;
  String? place;
  String? reason;
  String? phone;
  Files? files;
  String? businessId;
  String? remark;
  String? dxsj;

  Form({
    this.xh,
    this.studentId,
    this.xm,
    this.xb,
    this.mz,
    this.xy,
    this.zy,
    this.bjmc,
    this.nj,
    this.type,
    this.kssj,
    this.jssj,
    this.days,
    this.place,
    this.reason,
    this.phone,
    this.files,
    this.businessId,
    this.remark,
    this.dxsj,
  });

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      xh: json['xh'],
      studentId: json['studentId'],
      xm: json['xm'],
      xb: json['xb'],
      mz: json['mz'],
      xy: json['xy'],
      zy: json['zy'],
      bjmc: json['bjmc'],
      nj: json['nj'],
      type: json['type'],
      kssj: json['kssj'],
      jssj: json['jssj'],
      days: json['days'],
      place: json['place'],
      reason: json['reason'],
      phone: json['phone'],
      files: json['files'] != null ? Files.fromJson(json['files']) : null,
      businessId: json['businessId'],
      remark: json['remark'],
      dxsj: json['dxsj'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xh': xh,
      'studentId': studentId,
      'xm': xm,
      'xb': xb,
      'mz': mz,
      'xy': xy,
      'zy': zy,
      'bjmc': bjmc,
      'nj': nj,
      'type': type,
      'kssj': kssj,
      'jssj': jssj,
      'days': days,
      'place': place,
      'reason': reason,
      'phone': phone,
      'files': files?.toJson(),
      'businessId': businessId,
      'remark': remark,
      'dxsj': dxsj,
    };
  }
}

class Files {
  String? errcode;
  String? path;
  String? fileName;
  String? fileSize;
  String? errmsg;

  Files({
    this.errcode,
    this.path,
    this.fileName,
    this.fileSize,
    this.errmsg,
  });

  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
      errcode: json['errcode'],
      path: json['path'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      errmsg: json['errmsg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errcode': errcode,
      'path': path,
      'fileName': fileName,
      'fileSize': fileSize,
      'errmsg': errmsg,
    };
  }
}

class StepsInfo {
  String? errcode;
  String? errmsg;
  List<StepsInfoData>? data;

  StepsInfo({this.errcode, this.errmsg, this.data});

  factory StepsInfo.fromJson(Map<String, dynamic> json) {
    return StepsInfo(
      errcode: json['errcode'],
      errmsg: json['errmsg'],
      data: json['data'] != null
          ? List<StepsInfoData>.from(
              json['data'].map((x) => StepsInfoData.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errcode': errcode,
      'errmsg': errmsg,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class StepsInfoData {
  String? id;
  String? stepName;
  String? defId;
  String? shjsId;
  String? issq;
  int? bzxh;
  String? whenCreated;
  String? whenModified;
  String? backStep;
  String? currentStep;
  String? status;
  String? instanceId;
  String? stepResult;
  String? stepStatus;
  String? spyj;

  StepsInfoData({
    this.id,
    this.stepName,
    this.defId,
    this.shjsId,
    this.issq,
    this.bzxh,
    this.whenCreated,
    this.whenModified,
    this.backStep,
    this.currentStep,
    this.status,
    this.instanceId,
    this.stepResult,
    this.stepStatus,
    this.spyj,
  });

  factory StepsInfoData.fromJson(Map<String, dynamic> json) {
    return StepsInfoData(
      id: json['id'],
      stepName: json['step_name'],
      defId: json['def_id'],
      shjsId: json['shjs_id'],
      issq: json['issq'],
      bzxh: json['bzxh'],
      whenCreated: json['when_created'],
      whenModified: json['when_modified'],
      backStep: json['back_step'],
      currentStep: json['current_step'],
      status: json['status'],
      instanceId: json['instance_id'],
      stepResult: json['step_result'],
      stepStatus: json['step_status'],
      spyj: json['spyj'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'step_name': stepName,
      'def_id': defId,
      'shjs_id': shjsId,
      'issq': issq,
      'bzxh': bzxh,
      'when_created': whenCreated,
      'when_modified': whenModified,
      'back_step': backStep,
      'current_step': currentStep,
      'status': status,
      'instance_id': instanceId,
      'step_result': stepResult,
      'step_status': stepStatus,
      'spyj': spyj,
    };
  }
}
