class UpcommingModel {
  final String address;
  final String fullName;
  final String message;
  final String phoneNumber;
  final String productCode;
  final String productImage;
  final String productName;
  final String update;
  final String type;
  final String documentId;
  final String selectedDate;
  final String selectedTime;


  UpcommingModel({
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
    required this.selectedDate,
    required this.selectedTime
  });

  factory UpcommingModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UpcommingModel(
        address: data['address'] ?? '',
        fullName: data['fullName'] ?? '',
        message: data['message'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        productCode: data['productCode'] ?? '',
        productImage: data['productImage'] ?? '',
        productName: data['productName'] ?? '',
        update: data['update'] ?? '',
        type: data['issueCategory'] ?? '',
        documentId: documentId,
        selectedDate: data['selectedDate'],
        selectedTime: data['selectedTime']
    );
  }
}
