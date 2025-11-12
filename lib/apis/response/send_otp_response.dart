class SendOTPResponse {
  String? countryCode;
  String? oTPToVerify;
  String? oTP;
  String? phone;
  int? customerID;
  int? statusCode;
  String? oldPhone;

  SendOTPResponse(
      {required this.countryCode,
      required this.oTPToVerify,
      required this.oTP,
      required this.phone,
      required this.customerID,
      required this.statusCode,
      required this.oldPhone});

  SendOTPResponse.fromJson(Map<String, dynamic> json) {
    countryCode = json['CountryCode'];
    oTPToVerify = json['OTPToVerify'];
    oTP = json['OTP'];
    phone = json['Phone'];
    customerID = json['CustomerID'];
    statusCode = json['StatusCode'];
    oldPhone = json['OldPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CountryCode'] = countryCode;
    data['OTPToVerify'] = oTPToVerify;
    data['OTP'] = oTP;
    data['Phone'] = phone;
    data['CustomerID'] = customerID;
    data['OldPhone'] = oldPhone;
    return data;
  }
}
