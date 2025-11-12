class PlanDetailsMembershipListModel {
  String? isVerified;
  String? vehicleType;
  String? retailerName;
  String? contractDate;
  String? isCompleted;
  String? modelName;
  String? newEndDate;
  int? retailerID;
  double? discountedPrice;
  String? expiryDate;
  String? make;
  String? newStartDate;
  String? planName;
  String? isRenewed;
  int? customerID;
  String? memberSince;
  String? phone;
  int? eXTID;
  String? status;
  String? lastName;
  String? newTerm;
  String? remCalloutsText;
  String? membershipNo;
  String? firstName;
  String? year;
  String? term;
  String? regoNumber;
  String? email;
  String? eXTLoginName;
  dynamic planID;
  String? activationDate;
  String? vehicleDetailSingle;
  String? availableForRenewal;
  String? newMembershipNo;
  List<dynamic>? vehicleDetails;
  int? contractID;

  PlanDetailsMembershipListModel(
      {this.isVerified,
      this.vehicleType,
      this.retailerName,
      this.contractDate,
      this.isCompleted,
      this.modelName,
      this.newEndDate,
      this.retailerID,
      this.discountedPrice,
      this.expiryDate,
      this.make,
      this.newStartDate,
      this.planName,
      this.isRenewed,
      this.customerID,
      this.memberSince,
      this.phone,
      this.eXTID,
      this.status,
      this.lastName,
      this.newTerm,
      this.remCalloutsText,
      this.membershipNo,
      this.firstName,
      this.year,
      this.term,
      this.regoNumber,
      this.email,
      this.eXTLoginName,
      this.planID,
      this.activationDate,
      this.newMembershipNo,
      this.vehicleDetailSingle,
      this.availableForRenewal,
      this.vehicleDetails,
      this.contractID});

  PlanDetailsMembershipListModel.fromJson(Map<String, dynamic> json) {
    isVerified = json['isVerified'];
    vehicleType = json['npVehicleType'];
    retailerName = json['RetailerName'];
    contractDate = json['ContractDate'];
    isCompleted = json['isCompleted'];
    modelName = json['ModelName'];
    newEndDate = json['NewEndDate'];
    retailerID = json['RetailerID'];
    discountedPrice = json['DiscountedPrice'];
    expiryDate = json['ExpiryDate'];
    make = json['Make'];
    newStartDate = json['NewStartDate'];
    planName = json['PlanName'];
    isRenewed = json['isRenewed'];
    customerID = json['CustomerID'];
    memberSince = json['MemberSince'];
    phone = json['Phone'];
    eXTID = json['EXT_ID'];
    status = json['Status'];
    lastName = json['LastName'];
    newTerm = json['NewTerm'];
    remCalloutsText = json['RemCalloutsText'];
    membershipNo = json['MembershipNo'];
    firstName = json['FirstName'];
    year = json['Year'];
    term = json['Term'];
    regoNumber = json['RegoNumber'];
    email = json['Email'];
    eXTLoginName = json['EXT_LoginName'];
    planID = json['PlanID'];
    activationDate = json['ActivationDate'];
    availableForRenewal = json['AvailableForRenewal'];
    vehicleDetails = json['VehicleDetails'];
    vehicleDetailSingle = json['VehicleDetailSingle'];
    newMembershipNo = json['NewMembershipNo'];
    contractID = json['ContractID'];
  }
}
