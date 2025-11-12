class VehicleListResponse {
  List<Vehicles>? vehicles;
  String? statusMessage;
  int? statusCode;

  VehicleListResponse({this.vehicles, this.statusMessage, this.statusCode});

  VehicleListResponse.fromJson(Map<String, dynamic> json) {
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicles.fromJson(v));
      });
    }
    statusMessage = json['StatusMessage'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    data['StatusMessage'] = statusMessage;
    data['StatusCode'] = statusCode;
    return data;
  }
}

class Vehicles {
  double? vehicleWidth;
  String? vehicleMake;
  ModelInfo? modelInfo;
  String? vehicleType;
  double? vehicleLength;
  String? npVehicleType;
  int? vehicleID;
  String? make;
  String? model;
  String? vehicleDetailQuoted;
  double? vehicleWeight;
  String? vehicleModel;
  String? bodyType;
  double? vehicleHeight;
  String? year;
  String? isActive;
  Make? vehicleInfo;
  String? rego;
  String? bodyTypes;
  String? colour;
  String? vehicleDetail;

  Vehicles(
      {this.vehicleWidth,
      this.vehicleMake,
      this.modelInfo,
      this.vehicleType,
      this.vehicleLength,
      this.npVehicleType,
      this.vehicleID,
      this.make,
      this.model,
      this.vehicleDetailQuoted,
      this.vehicleWeight,
      this.vehicleModel,
      this.bodyType,
      this.vehicleHeight,
      this.year,
      this.isActive,
      this.vehicleInfo,
      this.rego,
      this.bodyTypes,
      this.colour,
      this.vehicleDetail});

  Vehicles.fromJson(Map<String, dynamic> json) {
    vehicleWidth = json['VehicleWidth'];
    vehicleMake = json['VehicleMake'];
    modelInfo = json['ModelInfo'] != null
        ? ModelInfo.fromJson(json['ModelInfo'])
        : null;
    vehicleType = json['VehicleType'];
    vehicleLength = json['VehicleLength'];
    npVehicleType = json['npVehicleType'];
    vehicleID = json['VehicleID'];
    make = json['Make'];
    model = json['Model'];
    vehicleDetailQuoted = json['VehicleDetailQuoted'];
    vehicleWeight = json['VehicleWeight'];
    vehicleModel = json['VehicleModel'];
    bodyType = json['BodyType'];
    vehicleHeight = json['VehicleHeight'];
    year = json['Year'];
    isActive = json['isActive'];
    vehicleInfo =
        json['VehicleInfo'] != null ? Make.fromJson(json['VehicleInfo']) : null;
    rego = json['Rego'];
    bodyTypes = json['BodyTypes'];
    colour = json['Colour'];
    vehicleDetail = json['VehicleDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VehicleWidth'] = vehicleWidth;
    data['VehicleMake'] = vehicleMake;
    if (modelInfo != null) {
      data['ModelInfo'] = modelInfo!.toJson();
    }
    data['VehicleType'] = vehicleType;
    data['VehicleLength'] = vehicleLength;
    data['npVehicleType'] = npVehicleType;
    data['VehicleID'] = vehicleID;
    data['Make'] = make;
    data['Model'] = model;
    data['VehicleDetailQuoted'] = vehicleDetailQuoted;
    data['VehicleWeight'] = vehicleWeight;
    data['VehicleModel'] = vehicleModel;
    data['BodyType'] = bodyType;
    data['VehicleHeight'] = vehicleHeight;
    data['Year'] = year;
    data['isActive'] = isActive;
    if (vehicleInfo != null) {
      data['VehicleInfo'] = vehicleInfo!.toJson();
    }
    data['Rego'] = rego;
    data['BodyTypes'] = bodyTypes;
    data['Colour'] = colour;
    data['VehicleDetail'] = vehicleDetail;
    return data;
  }
}

class ModelInfo {
  String? type;
  String? vehicleMake;
  String? bodyType;
  int? modelID;
  Make? make;
  String? modelName;

  ModelInfo(
      {this.type,
      this.vehicleMake,
      this.bodyType,
      this.modelID,
      this.make,
      this.modelName});

  ModelInfo.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    vehicleMake = json['VehicleMake'];
    bodyType = json['BodyType'];
    modelID = json['ModelID'];
    make = json['Make'] != null ? Make.fromJson(json['Make']) : null;
    modelName = json['ModelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['VehicleMake'] = vehicleMake;
    data['BodyType'] = bodyType;
    data['ModelID'] = modelID;
    if (make != null) {
      data['Make'] = make!.toJson();
    }
    data['ModelName'] = modelName;
    return data;
  }
}

class Make {
  int? makeID;
  String? make;

  Make({this.makeID, this.make});

  Make.fromJson(Map<String, dynamic> json) {
    makeID = json['MakeID'];
    make = json['Make'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MakeID'] = makeID;
    data['Make'] = make;
    return data;
  }
}
