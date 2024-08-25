class DoneTaskModel {
  String address;
  String fullName;
  String message;
  String phoneNumber;
  String productCode;
  String productImage;
  String productName;
  String update;
  String type;
  String date;
  String ticketId;
  var rating;
  String review;

  DoneTaskModel({
    required this.address,
    required this.fullName,
    required this.message,
    required this.phoneNumber,
    required this.productCode,
    required this.productImage,
    required this.productName,
    required this.update,
    required this.type,
    required this.date,
    required this.ticketId,
    required this.rating,
    required this.review
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
      type: data['type'] ?? '',
      date: data['selectedDate'] ?? '',
      ticketId: data['ticketId'] ?? '',
      rating: data['rating'] ?? 0,
      review: data['review'] ?? ''
    );
  }
}
