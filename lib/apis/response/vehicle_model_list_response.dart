class VehicleModelListResponse {
  List<VehicleModelListModel> response = [];

  VehicleModelListResponse({required this.response});

  VehicleModelListResponse.fromJson(Map<String, dynamic> json) {
    if (json['models'] != null) {
      json['models'].forEach((v) {
        response.add(VehicleModelListModel.fromJson(v));
      });
    } else {
      response.add(VehicleModelListModel.fromJson(json));
    }
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['models'] = response.map((v) => v.toJson()).toList();
    return data;
  }
}

class VehicleModelListModel {
  String? vehicleMake;
  String? type;
  int? modelID;
  String? modelName;

  VehicleModelListModel(
      {required this.vehicleMake,
      required this.type,
      required this.modelID,
      required this.modelName});

  VehicleModelListModel.fromJson(Map<String, dynamic> json) {
    vehicleMake = json['VehicleMake'];
    type = json['Type'];
    modelID = json['ModelID'];
    modelName = json['ModelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VehicleMake'] = vehicleMake;
    data['Type'] = type;
    data['ModelID'] = modelID;
    data['ModelName'] = modelName;
    return data;
  }
}
