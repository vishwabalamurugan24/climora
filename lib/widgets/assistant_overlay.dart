import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/assistant_service.dart';

class AssistantOverlay extends StatefulWidget {
  final Widget child;
  const AssistantOverlay({super.key, required this.child});

  @override
  State<AssistantOverlay> createState() => _AssistantOverlayState();
}

class _AssistantOverlayState extends State<AssistantOverlay>
    with SingleTickerProviderStateMixin {
  final AssistantService _service = AssistantService();
  late AnimationController _controller;
  AssistantStatus _status = AssistantStatus.idle;
  String _lastCommand = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _service.statusStream.listen((status) {
      if (mounted) {
        setState(() => _status = status);
      }
    });

    _service.commandStream.listen((command) {
      if (mounted) {
        setState(() => _lastCommand = command);
      }
    });

    // Start background listening
    _service.startListening();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_status != AssistantStatus.idle)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildOverlayUI(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOverlayUI() {
    Color orbColor = const Color(0xFFC2B180);
    String message = "Listening...";

    if (_status == AssistantStatus.processing) {
      orbColor = Colors.cyanAccent;
      message = "Understanding...";
    } else if (_status == AssistantStatus.responding) {
      orbColor = Colors.greenAccent;
      message = "Syncing with your mood...";
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: orbColor.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Group: Mic & Text
              Row(
                children: [
                  // Pulsating Mic Icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: orbColor.withValues(alpha: 0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: orbColor.withValues(
                                    alpha: 0.2 * _controller.value,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 4 * _controller.value,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: orbColor.withValues(alpha: 0.3),
                          ),
                          color: orbColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.mic, color: orbColor, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          color: orbColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _lastCommand.isEmpty
                            ? '"Hey Climora..." '
                            : '"$_lastCommand"',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Right Group: Waveform
              SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(5, (index) {
                    return _WaveformBar(color: orbColor, delay: index * 0.1);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaveformBar extends StatefulWidget {
  final Color color;
  final double delay;
  const _WaveformBar({required this.color, required this.delay});

  @override
  State<_WaveformBar> createState() => _WaveformBarState();
}

class _WaveformBarState extends State<_WaveformBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(
      begin: 4,
      end: 24,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: _animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      },
    );
  }
}

// Minimal placeholder for DeferPointer if not available
class DeferPointer extends StatelessWidget {
  final Widget child;
  const DeferPointer({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}
