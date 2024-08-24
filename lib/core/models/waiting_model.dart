class WaitingModel {
  String? address;
  String? fullName;
  String? message;
  String? phoneNumber;
  String? productCode;
  String? productImage;
  String? productName;
  String? update;
  String? type;
  String documentId;
    String ticketNumber;

  WaitingModel({
    required this.address,
    required this.fullName,
    required this.message,
    required this.phoneNumber,
    required this.productCode,
    required this.productImage,
    required this.productName,
    required this.update,
    required this.type,
    required this.documentId,
    required this.ticketNumber
  });

  factory WaitingModel.fromFirestore(Map<String, dynamic>? data, String documentId) {
    return WaitingModel(
      address: data?['address'] ?? 'Empty',
      fullName: data?['fullName'] ?? 'Empty',
      message: data?['message'] ?? 'Empty',
      phoneNumber: data?['phoneNumber'] ?? 'Empty',
      productCode: data?['productCode'] ?? 'Empty',
      productImage: data?['productImage'] ?? 'Empty',
      productName: data?['productName'] ?? 'Empty',
      update: data?['update'] ?? 'Empty',
      type: data?['issueCategory'] ?? 'Empty',
      documentId: documentId,
      ticketNumber: data?['ticketId'] ??'Empty'
    );
  }
}
