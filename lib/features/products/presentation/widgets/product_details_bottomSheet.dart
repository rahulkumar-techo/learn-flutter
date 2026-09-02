import 'package:flutter/material.dart';
import 'package:my_app/features/products/presentation/widgets/section_surface.dart';

class ProductDetailsBottomsheet extends StatelessWidget {
  const ProductDetailsBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionSurface(
      child: Container(
        // Clean padding around your row action items
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: const BoxDecoration(
      
          borderRadius: BorderRadius.vertical(top: Radius.circular(20),bottom: Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Centers elements vertically in the Row
          spacing: 12.0, // Space between Add to Cart and Buy Now buttons
          children: [
            
            // 1. Add to Cart Button (Expanded shares the screen width equally)
            Expanded(
              child: Material(
                color: Colors.black12, // Translucent contrast layer over yellow
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {}, // Triggers splash animation feedback loop
                  splashColor: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    // Ensures the action text sits centered on your tap target layer
                    child: Text(
                      "Add to Cart",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
      
            // 2. Buy Now Button
            Expanded(
              child: Material(
                color: Colors.black, // Dark high-contrast configuration
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      "Buy Now",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
