import 'package:flutter/material.dart';
import 'package:my_app/features/products/data/models/product_meta.dart';







class MetaInfo extends StatelessWidget {
  final ProductMeta metaData;

  const MetaInfo({super.key, required this.metaData});

  @override
  Widget build(BuildContext context) {
    // Basic human-readable local date parsing formatter string helper lambda expressions
    String formatDate(String dateString) {
      final date = DateTime.parse(dateString);
      return
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata Title Header Bar
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Product Metadata",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.8),

            // Main Details Row: Text Info Fields left, QR Code right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Text Information Container Block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow("Barcode:", metaData.barcode),
                      const SizedBox(height: 8),
                      _buildMetaRow("Created:", formatDate(metaData.createdAt)),
                      const SizedBox(height: 8),
                      _buildMetaRow("Updated:", formatDate(metaData.updatedAt)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Network Image Layout containing the QR Code reference block
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    // border: Border.solid(color: Colors.grey.shade200, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    metaData.qrCode,
                    width: 75,
                    height: 75,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 75,
                      height: 75,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.qr_code_scanner, color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        width: 75,
                        height: 75,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Small helper layout widget block to uniform your field strings row alignments
  Widget _buildMetaRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
