class RenewCouponCodeApiResponse {
  double? discountedPrice;
  int? customerID;
  String? totalDiscount;
  int? contractID;
  String? discountCode;
  String? statusMessage;
  int? statusCode;

  RenewCouponCodeApiResponse(
      {this.discountedPrice,
      this.customerID,
      this.totalDiscount,
      this.contractID,
      this.discountCode,
      this.statusMessage,
      this.statusCode});

  RenewCouponCodeApiResponse.fromJson(Map<String, dynamic> json) {
    discountedPrice = json['DiscountedPrice'];
    customerID = json['CustomerID'];
    totalDiscount = json['TotalDiscount'];
    contractID = json['ContractID'];
    discountCode = json['DiscountCode'];
    statusMessage = json['StatusMessage'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DiscountedPrice'] = discountedPrice;
    data['CustomerID'] = customerID;
    data['TotalDiscount'] = totalDiscount;
    data['ContractID'] = contractID;
    data['DiscountCode'] = discountCode;
    data['StatusMessage'] = statusMessage;
    data['StatusCode'] = statusCode;
    return data;
  }
}
