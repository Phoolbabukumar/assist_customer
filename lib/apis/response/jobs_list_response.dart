class JobListResponse {
  List<OmJobsView>? omJobsView;
  String? statusMessage;
  int? statusCode;

  JobListResponse({this.omJobsView, this.statusMessage, this.statusCode});

  JobListResponse.fromJson(Map<String, dynamic> json) {
    if (json['Jobs'] != null) {
      omJobsView = <OmJobsView>[];
      json['Jobs'].forEach((v) {
        omJobsView!.add(OmJobsView.fromJson(v));
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

class OmJobsView {
  int? durationInCurrentStatus;
  int? customerID;
  String? retailerName;
  String? title;
  String? statusWithTime;
  String? jobNo;
  String? status;
  String? customerLatitude;
  String? membershipNo;
  int? durationHours;
  String? serviceRequestDate;
  int? durationMinute;

  OmJobsView(
      {this.durationInCurrentStatus,
      this.customerID,
      this.retailerName,
      this.title,
      this.statusWithTime,
      this.jobNo,
      this.status,
      this.customerLatitude,
      this.membershipNo,
      this.durationHours,
      this.serviceRequestDate,
      this.durationMinute});

  OmJobsView.fromJson(Map<String, dynamic> json) {
    durationInCurrentStatus = json['DurationInCurrentStatus'];
    customerID = json['customerID'];
    retailerName = json['RetailerName'];
    title = json['Title'];
    statusWithTime = json['StatusWithTime'];
    jobNo = json['JobNo'];
    status = json['Status'];
    customerLatitude = json['CustomerLatitude'];
    membershipNo = json['MembershipNo'];
    durationHours = json['DurationHours'];
    serviceRequestDate = json['ServiceRequestDate'];
    durationMinute = json['DurationMinute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DurationInCurrentStatus'] = durationInCurrentStatus;
    data['customerID'] = customerID;
    data['RetailerName'] = retailerName;
    data['Title'] = title;
    data['StatusWithTime'] = statusWithTime;
    data['JobNo'] = jobNo;
    data['Status'] = status;
    data['CustomerLatitude'] = customerLatitude;
    data['MembershipNo'] = membershipNo;
    data['DurationHours'] = durationHours;
    data['ServiceRequestDate'] = serviceRequestDate;
    data['DurationMinute'] = durationMinute;
    return data;
  }
}
