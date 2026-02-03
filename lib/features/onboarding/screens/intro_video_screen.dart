import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';


import '../../../router.dart';
import '../../../core/constants/app_colors.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _playVideo();
  }

  Future<void> _playVideo() async {
    _controller = VideoPlayerController.asset('assets/intro/intro.mp4');
    try {
      await _controller.initialize();
      await _controller.setVolume(1.0); // Sound on for intro? Or off? Usually ON for intros.
      await _controller.play();
      
      setState(() {
        _initialized = true;
      });

      // Navigate when video finishes
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _navigateToWelcome();
        }
      });
    } catch (e) {
      // Fallback if video fails
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    if (mounted) {
      context.go(Routes.welcome);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _navigateToWelcome, // Allow tap to skip
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              

          ],
        ),
      ),
    );
  }
}
