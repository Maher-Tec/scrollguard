import 'package:flutter/material.dart';

/// Small offline platform marks used for monitored app identity.
class SocialPlatformLogo extends StatelessWidget {
  final String name;
  final double size;

  const SocialPlatformLogo({super.key, required this.name, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.26);
    switch (name.toLowerCase()) {
      case 'youtube':
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Container(
              width: size,
              height: size * 0.70,
              decoration: BoxDecoration(
                color: const Color(0xFFFF0033),
                borderRadius: BorderRadius.circular(size * 0.20),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: size * 0.58,
              ),
            ),
          ),
        );
      case 'instagram':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFFD776),
                Color(0xFFFA3E67),
                Color(0xFFCB17B9),
                Color(0xFF7135CF),
              ],
            ),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: size * 0.68,
          ),
        );
      case 'tiktok':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: radius,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(-size * 0.07, -size * 0.02),
                child: Icon(
                  Icons.music_note_rounded,
                  color: const Color(0xFF25F4EE),
                  size: size * 0.70,
                ),
              ),
              Transform.translate(
                offset: Offset(size * 0.06, size * 0.04),
                child: Icon(
                  Icons.music_note_rounded,
                  color: const Color(0xFFFE2C55),
                  size: size * 0.70,
                ),
              ),
              Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: size * 0.70,
              ),
            ],
          ),
        );
      case 'facebook':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF1877F2),
            borderRadius: radius,
          ),
          child: Icon(
            Icons.facebook_rounded,
            color: Colors.white,
            size: size * 0.82,
          ),
        );
      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: radius,
          ),
          child: Icon(
            Icons.apps_rounded,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: size * 0.58,
          ),
        );
    }
  }
}
