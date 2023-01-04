// To parse this JSON data, do
//
//     final addNewReviewResponse = addNewReviewResponseFromJson(jsonString);

import 'dart:convert';

import 'customer_review_model.dart';

AddNewReviewResponse addNewReviewResponseFromJson(String str) =>
    AddNewReviewResponse.fromJson(json.decode(str));

String addNewReviewResponseToJson(AddNewReviewResponse data) =>
    json.encode(data.toJson());

class AddNewReviewResponse {
  AddNewReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  bool error;
  String message;
  List<CustomerReview> customerReviews;

  factory AddNewReviewResponse.fromJson(Map<String, dynamic> json) =>
      AddNewReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
