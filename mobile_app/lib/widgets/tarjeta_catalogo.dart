import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        color: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.26),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                cacheWidth: 300,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Icon(Icons.local_florist,
                        color: Theme.of(context).iconTheme.color, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
