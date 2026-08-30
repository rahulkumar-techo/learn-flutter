import 'package:flutter/material.dart';

class ProductReview {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  // Factory constructor maps backend JSON key pairs safely
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      reviewerName: json['reviewerName'] ?? 'Anonymous',
      reviewerEmail: json['reviewerEmail'] ?? '',
    );
  }
}




class ReviewCard extends StatelessWidget {
  final ProductReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Dynamic generation of an user initials circle avatar placeholder string
    final String initial = review.reviewerName.isNotEmpty 
        ? review.reviewerName[0].toUpperCase() 
        : 'U';

    // Simple manual layout formatter (e.g. "30/04/2025")
    final String formattedDate = "${review.date.day.toString().padLeft(2, '0')}/"
        "${review.date.month.toString().padLeft(2, '0')}/"
        "${review.date.year}";

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Layer: Avatar, Reviewer Info & Date Tag
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        review.reviewerEmail,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Star Generation Block Row
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < review.rating ? Colors.amber : Colors.grey.shade300,
                );
              }),
            ),
            const SizedBox(height: 8),

            // Review Body Text Content Layer
            Text(
              review.comment,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
