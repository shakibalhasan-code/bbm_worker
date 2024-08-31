import 'package:cloud_firestore/cloud_firestore.dart';

class UnsolvedModel {
  String address;
  String fullName;
  String issueCategory;
  String message;
  String note;
  String phoneNumber;
  String productCode;
  String productImage;
  String productName;
  String ticketId;
  String unsolvedDate;
  String update;
  String workerEmail;

  UnsolvedModel({
    required this.address,
    required this.fullName,
    required this.issueCategory,
    required this.message,
    required this.note,
    required this.phoneNumber,
    required this.productCode,
    required this.productImage,
    required this.productName,
    required this.ticketId,
    required this.unsolvedDate,
    required this.update,
    required this.workerEmail,
  });

  factory UnsolvedModel.fromFirestore(Map<String, dynamic> data) {
    return UnsolvedModel(
      address: data['address'] as String,
      fullName: data['fullName'] as String,
      issueCategory: data['issueCategory'] as String,
      message: data['message'] as String,
      note: data['note'] as String,
      phoneNumber: data['phoneNumber'] as String,
      productCode: data['productCode'] as String,
      productImage: data['productImage'] as String,
      productName: data['productName'] as String,
      ticketId: data['ticketId'] as String,
      unsolvedDate: data['unsolvedDate'] as String,
      update: data['update'] as String,
      workerEmail: data['workerEmail'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'fullName': fullName,
      'issueCategory': issueCategory,
      'message': message,
      'note': note,
      'phoneNumber': phoneNumber,
      'productCode': productCode,
      'productImage': productImage,
      'productName': productName,
      'ticketId': ticketId,
      'unsolvedDate': unsolvedDate,
      'update': update,
      'workerEmail': workerEmail,
    };
  }
}
