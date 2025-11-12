class PlansByVehicleTypeResponse {
  List<PlanDataModel>? response=[];

  PlansByVehicleTypeResponse({this.response});

  PlansByVehicleTypeResponse.fromJson(Map<String, dynamic> json) {
    if (json['PlanList'] != null) {

      json['PlanList'].forEach((v) {
        response!.add(PlanDataModel.fromJson(v));
      });
    }else{
      response!.add(PlanDataModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (response != null) {
      data['PlanList'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanDataModel {
  double? amount;
  String? term;
  int? rID;
  String? planName;
  int? planID;
  int? retailerID;
  String? npVehicleType;

  PlanDataModel(
      {this.amount,
        this.term,
        this.rID,
        this.planName,
        this.planID,
        this.retailerID,
        this.npVehicleType});

  PlanDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    term = json['Term'];
    rID = json['RID'];
    planName = json['PlanName'];
    planID = json['PlanID'];
    retailerID = json['RetailerID'];
    npVehicleType = json['npVehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Amount'] = amount;
    data['Term'] = term;
    data['RID'] = rID;
    data['PlanName'] = planName;
    data['PlanID'] = planID;
    data['RetailerID'] = retailerID;
    data['npVehicleType'] = npVehicleType;
    return data;
  }
}
