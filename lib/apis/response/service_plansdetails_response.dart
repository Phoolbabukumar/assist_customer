class ServicePlansDetailsResponse {
  List<PlanWithServices>? planWithServices;

  ServicePlansDetailsResponse({this.planWithServices});

  ServicePlansDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['planWithServices'] != null) {
      planWithServices = <PlanWithServices>[];
      json['planWithServices'].forEach((v) {
        planWithServices!.add(PlanWithServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (planWithServices != null) {
      data['planWithServices'] =
          planWithServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanWithServices {
  String? dimensionCheck;
  String? fullPlanName;
  int? countSecond;
  double? discountedPrice;
  String? planName;
  int? countFirst;
  int? noOfVehicles;
  String? includeAnyVehicle;
  double? specialPrice;
  double? amount;
  String? includeOtherVehicle;
  List<PlanService>? planService;
  int? rNPlanID;
  String? term;

  PlanWithServices(
      {this.dimensionCheck,
      this.fullPlanName,
      this.countSecond,
      this.discountedPrice,
      this.planName,
      this.countFirst,
      this.noOfVehicles,
      this.includeAnyVehicle,
      this.specialPrice,
      this.amount,
      this.includeOtherVehicle,
      this.planService,
      this.rNPlanID,
      this.term});

  PlanWithServices.fromJson(Map<String, dynamic> json) {
    dimensionCheck = json['DimensionCheck'];
    fullPlanName = json['FullPlanName'];
    countSecond = json['CountSecond'];
    discountedPrice = json['DiscountedPrice'];
    planName = json['PlanName'];
    countFirst = json['CountFirst'];
    noOfVehicles = json['NoOfVehicles'];
    includeAnyVehicle = json['IncludeAnyVehicle'];
    specialPrice = json['SpecialPrice'];
    amount = json['Amount'];
    includeOtherVehicle = json['IncludeOtherVehicle'];
    if (json['PlanService'] != null) {
      planService = <PlanService>[];
      json['PlanService'].forEach((v) {
        planService!.add(PlanService.fromJson(v));
      });
    }
    rNPlanID = json['RNPlanID'];
    term = json['Term'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DimensionCheck'] = dimensionCheck;
    data['FullPlanName'] = fullPlanName;
    data['CountSecond'] = countSecond;
    data['DiscountedPrice'] = discountedPrice;
    data['PlanName'] = planName;
    data['CountFirst'] = countFirst;
    data['NoOfVehicles'] = noOfVehicles;
    data['IncludeAnyVehicle'] = includeAnyVehicle;
    data['SpecialPrice'] = specialPrice;
    data['Amount'] = amount;
    data['IncludeOtherVehicle'] = includeOtherVehicle;
    if (planService != null) {
      data['PlanService'] = planService!.map((v) => v.toJson()).toList();
    }
    data['RNPlanID'] = rNPlanID;
    data['Term'] = term;
    return data;
  }
}

class PlanService {
  String? servicesCovered;
  String? service;
  double? unit;
  String? description;

  PlanService(
      {this.servicesCovered, this.service, this.unit, this.description});

  PlanService.fromJson(Map<String, dynamic> json) {
    servicesCovered = json['ServicesCovered'];
    service = json['Service'];
    unit = json['Unit'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ServicesCovered'] = servicesCovered;
    data['Service'] = service;
    data['Unit'] = unit;
    data['Description'] = description;
    return data;
  }
}
