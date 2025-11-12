class VehicleMakeListResponse {
  List<MakeListModel> response = [];

  VehicleMakeListResponse({required this.response});

  VehicleMakeListResponse.fromJson(Map<String, dynamic> json) {
    if (json['makeList'] != null) {
      json['makeList'].forEach((v) {
        response.add(MakeListModel.fromJson(v));
      });
    } else {
      response.add(MakeListModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makeList'] = response.map((v) => v.toJson()).toList();
    return data;
  }
}

class MakeListModel {
  int? makeID;
  String? make;

  MakeListModel({this.makeID, this.make});

  MakeListModel.fromJson(Map<String, dynamic> json) {
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
