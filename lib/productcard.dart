import 'package:flutter/material.dart';
import 'package:fuse_app/services/api_service.dart';

class ProductCard extends StatefulWidget {
  final int productId;
  final String name;
  final String imagePath;
  final double oldPrice;
  final double currentPrice;

  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.imagePath,
    required this.oldPrice,
    required this.currentPrice,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isInWishlist = false;
  int? wishlistId; // Store wishlist ID for removing

  @override
  void initState() {
    super.initState();
    checkWishlistStatus();
  }

  Future<void> checkWishlistStatus() async {
    // bool exists = await ApiService.isProductInWishlist(widget.productId);
    // setState(() => isInWishlist = exists);
  }

  Future<void> toggleWishlist() async {
    if (isInWishlist) {
      if (wishlistId != null) {
        await ApiService.removeFromWishlist(wishlistId!);
      }
      setState(() => isInWishlist = false);
    } else {
      await ApiService.addToWishlist(widget.productId);
      setState(() => isInWishlist = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? [] // No shadow in dark mode
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: InkWell(
                    onTap: toggleWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'LKR. ${widget.oldPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    'LKR. ${widget.currentPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
