class GetJobsByJobIdResponse {
  List<JobDataResponse>? omJobsView;
  String? statusMessage;
  int? statusCode;

  GetJobsByJobIdResponse(
      {this.omJobsView, this.statusMessage, this.statusCode});

  GetJobsByJobIdResponse.fromJson(Map<String, dynamic> json) {
    if (json['Jobs'] != null) {
      omJobsView = <JobDataResponse>[];
      json['Jobs'].forEach((v) {
        omJobsView!.add(JobDataResponse.fromJson(v));
      });
    }
    statusMessage = json['StatusMessage'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (omJobsView != null) {
      data['Jobs'] = omJobsView!.map((v) => v.toJson()).toList();
    }
    data['StatusMessage'] = statusMessage;
    data['StatusCode'] = statusCode;
    return data;
  }
}

class JobDataResponse {
  int? durationInCurrentStatus;
  int? customerID;
  String? retailerName;
  int? towDistance;
  String? isCompleted;
  String? title;
  String? customerPhone;
  String? statusWithTime;
  String? jobNo;
  int? jobRating;
  String? customerAddress;
  String? status;
  int? rid;
  String? membershipNo;
  String? customerLatitude;
  int? durationHours;
  String? rego;
  String? sendFeedbackEmail;
  String? customerLongitude;
  int? durationMinute;
  String? vehicleDetail;

  JobDataResponse(
      {this.durationInCurrentStatus,
      this.customerID,
      this.retailerName,
      this.towDistance,
      this.isCompleted,
      this.title,
      this.customerPhone,
      this.statusWithTime,
      this.jobNo,
      this.jobRating,
      this.customerAddress,
      this.status,
      this.rid,
      this.membershipNo,
      this.customerLatitude,
      this.durationHours,
      this.rego,
      this.sendFeedbackEmail,
      this.customerLongitude,
      this.durationMinute,
      this.vehicleDetail});

  JobDataResponse.fromJson(Map<String, dynamic> json) {
    durationInCurrentStatus = json['DurationInCurrentStatus'];
    customerID = json['customerID'];
    retailerName = json['RetailerName'];
    towDistance = json['TowDistance'];
    isCompleted = json['isCompleted'];
    title = json['Title'];
    customerPhone = json['CustomerPhone'];
    statusWithTime = json['StatusWithTime'];
    jobNo = json['JobNo'];
    jobRating = json['JobRating'];
    customerAddress = json['CustomerAddress'];
    status = json['Status'];
    rid = json['rid'];
    membershipNo = json['MembershipNo'];
    customerLatitude = json['CustomerLatitude'];
    durationHours = json['DurationHours'];
    rego = json['Rego'];
    sendFeedbackEmail = json['SendFeedbackEmail'];
    customerLongitude = json['CustomerLongitude'];
    durationMinute = json['DurationMinute'];
    vehicleDetail = json['VehicleDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DurationInCurrentStatus'] = durationInCurrentStatus;
    data['customerID'] = customerID;
    data['RetailerName'] = retailerName;
    data['TowDistance'] = towDistance;
    data['isCompleted'] = isCompleted;
    data['Title'] = title;
    data['CustomerPhone'] = customerPhone;
    data['StatusWithTime'] = statusWithTime;
    data['JobNo'] = jobNo;
    data['JobRating'] = jobRating;
    data['CustomerAddress'] = customerAddress;
    data['Status'] = status;
    data['rid'] = rid;
    data['MembershipNo'] = membershipNo;
    data['CustomerLatitude'] = customerLatitude;
    data['DurationHours'] = durationHours;
    data['Rego'] = rego;
    data['SendFeedbackEmail'] = sendFeedbackEmail;
    data['CustomerLongitude'] = customerLongitude;
    data['DurationMinute'] = durationMinute;
    data['VehicleDetail'] = vehicleDetail;
    return data;
  }
}
