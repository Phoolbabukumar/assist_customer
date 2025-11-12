class BuyPlanPaymentResponse {
  String? lastName;
  String? invoiceNumber;
  String? planAmount;
  String? firstName;
  String? postalCode;
  String? membershipNo;
  String? city;
  String? invoiceReference;
  String? state;
  String? email;
  String? address;
  String? formActionURL;

  BuyPlanPaymentResponse(
      {this.lastName,
      this.invoiceNumber,
      this.planAmount,
      this.firstName,
      this.postalCode,
      this.membershipNo,
      this.city,
      this.invoiceReference,
      this.state,
      this.address,
      this.email,
      this.formActionURL});

  BuyPlanPaymentResponse.fromJson(Map<String, dynamic> json) {
    lastName = json['LastName'];
    invoiceNumber = json['InvoiceNumber'];
    planAmount = json['PlanAmount'];
    firstName = json['FirstName'];
    postalCode = json['PostalCode'];
    membershipNo = json['MembershipNo'];
    city = json['City'];
    invoiceReference = json['InvoiceReference'];
    state = json['State'];
    address = json['Address'];
    email = json['Email'];
    formActionURL = json['FormActionURL'];
  }
}
