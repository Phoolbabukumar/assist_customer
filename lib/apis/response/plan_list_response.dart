/// Created by Sumit Mittal on 28-09-2021.

class PlanListResponse {
  List<PlanListModel> response = [];

  PlanListResponse({required this.response});

  PlanListResponse.fromJson(Map<String, dynamic> json) {
    response = [];
    if (json['PlanList'] != null) {
      json['PlanList'].forEach((v) {
        response.add(PlanListModel.fromJson(v));
      });
    } else {
      response.add(PlanListModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PlanList'] = response.map((v) => v.toJson()).toList();
    return data;
  }
}

class PlanListModel {
  String? npVehicleType;
  String? term;
  double? amount;
  int? rID;
  int? planId;
  String? planName;
  int? retailerID;
  double? discountedPrice;

  PlanListModel(
      { this.npVehicleType,
        this.term,
      this.amount,
      this.rID,
      this.planId,
      this.planName,
        this.discountedPrice,
      this.retailerID});

  PlanListModel.fromJson(Map<String, dynamic> json) {
    npVehicleType = json['npVehicleType'];
    term = json['Term'];
    amount = json['Amount'];
    rID = json['RID'];
    planId = json['PlanID'];
    planName = json['PlanName'];
    retailerID = json['RetailerID'];
    discountedPrice = json['DiscountedPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['npVehicleType'] = npVehicleType;
    data['Term'] = term;
    data['Amount'] = amount;
    data['RID'] = rID;
    data['EXT_id'] = planId;
    data['PlanName'] = planName;
    data['RetailerID'] = retailerID;
    return data;
  }
}
