class OnTaskModel {
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
  final String ticketId;


  OnTaskModel({
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
    required this.selectedTime,
    required this.ticketId
  });

  factory OnTaskModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return OnTaskModel(
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
      selectedTime: data['selectedTime'],
        ticketId : data['ticketId']
    );
  }
}
