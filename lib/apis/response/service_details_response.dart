class ServiceDetailsResponse {
  List<ServiceDetailModel> response=[];

  ServiceDetailsResponse({required this.response});

  ServiceDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['Services'] != null) {
      json['Services'].forEach((v) {
        response.add(ServiceDetailModel.fromJson(v));
      });
    }
    else{
      response.add(ServiceDetailModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Services'] = response.map((v) => v.toJson()).toList();
    return data;
  }
}

class ServiceDetailModel {
  String? servicesCovered;
  double? unit;
  String? service;

  ServiceDetailModel({required this.servicesCovered, required this.unit, required this.service});

  ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    servicesCovered = json['ServicesCovered'];
    unit = json['Unit'];
    service = json['Service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ServicesCovered'] = servicesCovered;
    data['Unit'] = unit;
    data['Service'] = service;
    return data;
  }
}
