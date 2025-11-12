class VehicleListByPhoneResponse {
  List<VehicleListModel>? response = [];

  VehicleListByPhoneResponse({this.response});

  VehicleListByPhoneResponse.fromJson(Map<String, dynamic> json) {
    response = <VehicleListModel>[];
    if (json['vehicleList'] != null) {
      json['vehicleList'].forEach((v) {
        response!.add(VehicleListModel.fromJson(v));
      });
    } else {
      response!.add(VehicleListModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['vehicleList'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleListModel {
  String? vehicleDetail;
  String? status;
  int? customerID;
  int? vehicleID;
  String? jobNo;
  String? vehicleWithMembership;
  int? contractID;

  VehicleListModel(
      {this.vehicleDetail,
      this.status,
      this.customerID,
      this.vehicleID,
      this.vehicleWithMembership,
      this.jobNo,
      this.contractID});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    vehicleDetail = json['VehicleDetail'];
    status = json['Status'];
    customerID = json['CustomerID'];
    vehicleID = json['VehicleID'];
    vehicleWithMembership = "${json['VehicleDetail']} ${json['VehicleID']}";
    contractID = json['ContractID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VehicleDetail'] = vehicleDetail;
    data['Status'] = status;
    data['CustomerID'] = customerID;
    data['VehicleID'] = vehicleID;
    data['JobNo'] = jobNo;
    data['ContractID'] = contractID;
    return data;
  }
}
