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
  });

  factory WaitingModel.fromFirestore(Map<String, dynamic>? data, String documentId) {
    return WaitingModel(
      address: data?['address'] ?? '',
      fullName: data?['fullName'] ?? '',
      message: data?['message'] ?? '',
      phoneNumber: data?['phoneNumber'] ?? '',
      productCode: data?['productCode'] ?? '',
      productImage: data?['productImage'] ?? '',
      productName: data?['productName'] ?? '',
      update: data?['update'] ?? '',
      type: data?['issueCategory'] ?? '',
      documentId: documentId,
    );
  }
}
