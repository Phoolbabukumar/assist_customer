class ProfileResponse {
  String? vehicleDetail;
  String? retailerNumber;
  String? email;
  String? planName;
  String? firstName;
  String? rego;
  String? phone;
  int? year;
  String? address;
  int? remainingCallouts;
  String? profilePicData;
  String? lastName;
  String? customerMembershipNos;
  String? customerPicURL;
  String? city;
  String? state;
  String? contactYou;
  String? postalCode;

  ProfileResponse(
      {required this.vehicleDetail,
      required this.retailerNumber,
      required this.email,
      required this.planName,
      required this.firstName,
      required this.rego,
      required this.phone,
      required this.year,
      required this.remainingCallouts,
      required this.profilePicData,
      required this.lastName,
      required this.customerMembershipNos,
      required this.customerPicURL,
      required this.address,
      required this.city,
      required this.state,
      required this.contactYou,
      required this.postalCode});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    vehicleDetail = json['VehicleDetail'];
    retailerNumber = json['RetailerNumber'];
    email = json['Email'];
    planName = json['PlanName'];
    firstName = json['FirstName'];
    rego = json['Rego'];
    phone = json['Phone'];
    year = json['Year'];
    remainingCallouts = json['RemainingCallouts'];
    profilePicData = json['ProfilePicData'];
    lastName = json['LastName'];
    customerMembershipNos = json['CustomerMembershipNo'];
    customerPicURL = json['CustomerPicURL'];
    address = json['Address'];
    city = json['City'];
    state = json['State'];
    contactYou = json['ContactYou'];
    postalCode = json['PostalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VehicleDetail'] = vehicleDetail;
    data['RetailerNumber'] = retailerNumber;
    data['Email'] = email;
    data['PlanName'] = planName;
    data['FirstName'] = firstName;
    data['Rego'] = rego;
    data['Phone'] = phone;
    data['Year'] = year;
    data['RemainingCallouts'] = remainingCallouts;
    data['ProfilePicData'] = profilePicData;
    data['LastName'] = lastName;
    data['CustomerPicURL'] = customerPicURL;
    data['CustomerMembershipNo'] = customerMembershipNos;
    data['City'] = city;
    data['State'] = state;
    data['PostalCode'] = postalCode;
    return data;
  }
}
