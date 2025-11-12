class EncryptDataResponse {
  int? method;
  List<Items>? items;

  //Null? errors;

  EncryptDataResponse({this.method, this.items /*, this.errors*/
      });

  EncryptDataResponse.fromJson(Map<String, dynamic> json) {
    method = json['Method'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? name;
  String? value;

  Items({this.name, this.value});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'];
  }
}
