class PaymentResponse {
  String? accessCode;
  String? authorisationCode;
  String? responseCode;
  String? responseMessage;
  String? invoiceNumber;
  String? invoiceReference;
  int? totalAmount;
  int? transactionID;
  bool? transactionStatus;
  String? tokenCustomerID;

  PaymentResponse(
      {this.accessCode,
      this.authorisationCode,
      this.responseCode,
      this.responseMessage,
      this.invoiceNumber,
      this.invoiceReference,
      this.totalAmount,
      this.transactionID,
      this.transactionStatus,
      this.tokenCustomerID});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    accessCode = json['AccessCode'];
    authorisationCode = json['AuthorisationCode'];
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    invoiceNumber = json['InvoiceNumber'];
    invoiceReference = json['InvoiceReference'];
    totalAmount = json['TotalAmount'];
    transactionID = json['TransactionID'];
    transactionStatus = json['TransactionStatus'];
    tokenCustomerID = json['TokenCustomerID'];
  }
}
