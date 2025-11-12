import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

class OtpResponse {
  OtpResponse({
    required this.otpToVerify,
    required this.phone,
    required this.customerId,
    required this.statusCode,
    required this.oldPhone,
  });

  String otpToVerify;
  String phone;
  int customerId;
  int statusCode;
  String oldPhone;

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(

    otpToVerify: json["OTPToVerify"],
    phone: json["Phone"],
    customerId: json["CustomerID"],
    statusCode: json["StatusCode"],
    oldPhone: json["OldPhone"],
  );

}
