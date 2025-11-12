class BuyPlanResponse {
  double? vehicleLength;
  String? planName;
  String? source;
  String? planAmount;
  String? expiryDate;
  String? term;
  int? customerId;
  String? membershipNo;
  double? vehicleWidth;
  String? contractDate;
  int? contractId;
  String? customerAccess;
  double? vehicleWeight;
  String? statusMessage;
  double? vehicleHeight;
  String? isDeactivated;

  BuyPlanResponse({
    required this.vehicleLength,
    this.planName,
    this.source,
    this.planAmount,
    this.expiryDate,
    this.term,
    this.customerId,
    this.membershipNo,
    required this.vehicleWidth,
    this.contractDate,
    this.contractId,
    this.customerAccess,
    required this.vehicleWeight,
    this.statusMessage,
    required this.vehicleHeight,
    this.isDeactivated,
  });

  BuyPlanResponse.fromJson(Map<String, dynamic> json) {
    vehicleLength = json['VehicleLength']??0.0;
    planName = json['PlanName'];
    source = json['Source'];
    planAmount = json['PlanAmount'];
    expiryDate = json['ExpiryDate'];
    term = json['Term'];
    customerId = json['CustomerID'];
    membershipNo = json['MembershipNo'];
    vehicleWidth = json['VehicleWidth']??0.0;
    contractDate = json['ContractDate'];
    contractId = json['ContractID'];
    customerAccess = json['CustomerAccess'];
    vehicleWeight = json['VehicleWeight']??0.0;
    statusMessage = json['StatusMessage'];
    vehicleHeight = json['VehicleHeight']??0.0;
    isDeactivated = json['isDeactivated'];
  }
}
