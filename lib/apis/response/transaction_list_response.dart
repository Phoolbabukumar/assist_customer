class TransactionListResponse {
  List<TransactionListModel> response = [];

  TransactionListResponse({required this.response});

  TransactionListResponse.fromJson(Map<String, dynamic> json) {
    if (json['Transactions'] != null) {
      json['Transactions'].forEach((v) {
        response.add(TransactionListModel.fromJson(v));
      });
    } else {
      response.add(TransactionListModel.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Transactions'] = response.map((v) => v.toJson()).toList();
    return data;
  }
}

class TransactionListModel {
  int? customerID;
  String? transactionStatus;
  String? invoiceNumber;
  String? phone;
  String? invoiceReference;
  String? transactionDateTime;
  double? totalAmount;
  String? membershipNo;
  String? transactionID;

  TransactionListModel(
      {this.customerID,
      this.transactionStatus,
      this.invoiceNumber,
      this.phone,
      this.invoiceReference,
      this.transactionDateTime,
      this.totalAmount,
      this.membershipNo,
      this.transactionID});

  TransactionListModel.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    transactionStatus = json['TransactionStatus'];
    invoiceNumber = json['InvoiceNumber'];
    phone = json['Phone'];
    invoiceReference = json['InvoiceReference'];
    transactionDateTime = json['TransactionDateTime'];
    totalAmount = json['TotalAmount'];
    membershipNo = json['MembershipNo'];
    transactionID = json['TransactionID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerID'] = customerID;
    data['TransactionStatus'] = transactionStatus;
    data['InvoiceNumber'] = invoiceNumber;
    data['Phone'] = phone;
    data['InvoiceReference'] = invoiceReference;
    data['TransactionDateTime'] = transactionDateTime;
    data['TotalAmount'] = totalAmount;
    data['MembershipNo'] = membershipNo;
    data['TransactionID'] = transactionID;
    return data;
  }
}
