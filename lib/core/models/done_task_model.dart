class DoneTaskModel {
  final String address;
  final String fullName;
  final String message;
  final String phoneNumber;
  final String productCode;
  final String productImage;
  final String productName;
  final String update;

  DoneTaskModel({
    required this.address,
    required this.fullName,
    required this.message,
    required this.phoneNumber,
    required this.productCode,
    required this.productImage,
    required this.productName,
    required this.update,
  });

  factory DoneTaskModel.fromFirestore(Map<String, dynamic> data) {
    return DoneTaskModel(
      address: data['address'] ?? '',
      fullName: data['fullName'] ?? '',
      message: data['message'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      productCode: data['productCode'] ?? '',
      productImage: data['productImage'] ?? '',
      productName: data['productName'] ?? '',
      update: data['update'] ?? '',
    );
  }
}
