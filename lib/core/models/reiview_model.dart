import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String productCode;
  final String productImage;
  final String productName;
  final String customerName;
  final String endedDate;
  final String message;
  final String address;
  final String type;
  final String workerName;
  final String workerEmail;
  final String workerImage;
  final String workerPhone;
  final String review;

  ReviewModel({
    required this.productCode,
    required this.productImage,
    required this.productName,
    required this.customerName,
    required this.endedDate,
    required this.message,
    required this.address,
    required this.type,
    required this.workerName,
    required this.workerEmail,
    required this.workerImage,
    required this.workerPhone,
    required this.review,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return ReviewModel(
      productCode: data['productCode'] ?? '',
      productImage: data['productImage'] ?? '',
      productName: data['productName'] ?? '',
      customerName: data['customerName'] ?? '',
      endedDate: data['endedDate'] ?? '',
      message: data['message'] ?? '',
      address: data['address'] ?? '',
      type: data['type'] ?? '',
      workerName: data['workerName'] ?? '',
      workerEmail: data['workerEmail'] ?? '',
      workerImage: data['workerImage'] ?? '',
      workerPhone: data['workerPhone'] ?? '',
      review: data['review'] ?? '',
    );
  }
}
