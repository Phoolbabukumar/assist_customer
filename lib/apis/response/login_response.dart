class LoginResponse {
  String? isForRenewal;
  String? phone;
  String? pass;
  int? uID;
  String? isRenewed;
  int? statusCode;
  String? isDeactivated;

  LoginResponse(
      {this.isForRenewal,
        this.phone,
        this.pass,
        this.uID,
        this.isRenewed,
        this.statusCode,
        this.isDeactivated});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    isForRenewal = json['isForRenewal'];
    phone = json['Phone'];
    pass = json['Pass'];
    uID = json['UID'];
    isRenewed = json['isRenewed'];
    statusCode = json['StatusCode'];
    isDeactivated = json['isDeactivated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isForRenewal'] = isForRenewal;
    data['Phone'] = phone;
    data['Pass'] = pass;
    data['UID'] = uID;
    data['isRenewed'] = isRenewed;
    data['StatusCode'] = statusCode;
    data['isDeactivated'] = isDeactivated;
    return data;
  }
}

