class JobTitlesModelListResponse {
  List<JobTitlesModel> response =[];

  JobTitlesModelListResponse({required this.response});

  JobTitlesModelListResponse.fromJson(Map<String, dynamic> json) {
    if (json['Services'] != null) {
      response = <JobTitlesModel>[];
      json['Services'].forEach((v) {
        response.add(JobTitlesModel.fromJson(v));
      });
    }else {
      response.add(JobTitlesModel.fromJson(json));
    }
  }
}

class JobTitlesModel {
  String? servicesCovered;
  String? service;
  num? unit;
  String? description;
  String? availableOnApp;

  JobTitlesModel({this.servicesCovered, this.service, this.unit, this.description});

  JobTitlesModel.fromJson(Map<String, dynamic> json) {
    servicesCovered = json['ServicesCovered'];
    service = json['Service'];
    unit = json['Unit'];
    description = json['Description'];
    availableOnApp = json['AvailableToApp'];
  }
}
