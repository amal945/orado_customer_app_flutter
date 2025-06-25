import 'package:flutter/material.dart';

class RestaurantTile extends StatelessWidget {
  String? name;
  String? rating;
  String? foodType;
  String? distance;
  String? imageUrl;
  bool? isClosed;

   RestaurantTile({
    super.key,
     this.name,
     this.rating,
     this.foodType,
     this.distance,
     this.imageUrl,
     this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade300)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.favorite_border, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('$foodType • $distance', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Text('⭐ $rating', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
