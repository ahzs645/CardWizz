import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MtgSetIcon extends StatelessWidget {
  final String setCode;
  final double size;
  final Color? color;
  final String? rarity;

  const MtgSetIcon({
    super.key,
    required this.setCode,
    this.size = 24,
    this.color,
    this.rarity,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize the set code
    final normalizedSetCode = setCode.toLowerCase().trim();
    
    // Use JPEG or PNG format instead of SVG from Scryfall
    // This is more reliable than the SVG endpoint which is causing errors
    final symbolUrl = 'https://cards.scryfall.io/art_crop/front/symbol/$normalizedSetCode.jpg';
    
    return CachedNetworkImage(
      imageUrl: symbolUrl,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) {
        // Try fallback image URL
        return CachedNetworkImage(
          imageUrl: 'https://gatherer.wizards.com/Handlers/Image.ashx?type=symbol&set=$normalizedSetCode&size=large&rarity=C',
          width: size,
          height: size,
          color: color,
          fit: BoxFit.contain,
          errorWidget: (context, url, error) {
            // If both fail, show a text fallback
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  normalizedSetCode.length > 2 ? normalizedSetCode.substring(0, 2).toUpperCase() : normalizedSetCode.toUpperCase(),
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
