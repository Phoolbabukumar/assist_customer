class CouponCodeApiResponse {
  String? planAmount;
  String? isForRenewal;
  int? customerId;
  String? totalDiscount;
  int? contractId;
  String? customerAccess;
  String? discountCode;
  String? isRenewed;
  int? status;
  String? statusMessage;
  String? isDeactivated;

  CouponCodeApiResponse({
    this.planAmount,
    this.isForRenewal,
    this.customerId,
    this.totalDiscount,
    this.contractId,
    this.customerAccess,
    this.discountCode,
    this.isRenewed,
    this.status,
    this.statusMessage,
    this.isDeactivated,
  });

  factory CouponCodeApiResponse.fromJson(Map<String, dynamic> json) {
    return CouponCodeApiResponse(
      planAmount: json['PlanAmount'] as String?,
      isForRenewal: json['isForRenewal'] as String?,
      customerId: json['CustomerID'] as int?,
      totalDiscount: json['TotalDiscount'] as String?,
      contractId: json['ContractID'] as int?,
      customerAccess: json['CustomerAccess'] as String?,
      discountCode: json['DiscountCode'] as String?,
      isRenewed: json['isRenewed'] as String?,
      status: json['StatusCode'] as int?,
      statusMessage: json['StatusMessage'] as String?,
      isDeactivated: json['isDeactivated'] as String?,
    );
  }
}
