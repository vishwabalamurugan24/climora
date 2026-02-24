import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopNowPlayingPanel extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;

  const DesktopNowPlayingPanel({
    super.key,
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border(
          left: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NOW PLAYING',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Icon(Icons.equalizer_rounded, color: primaryColor, size: 20),
            ],
          ),

          const SizedBox(height: 48),

          // Album Art
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?auto=format&fit=crop&q=80&w=1000',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title & Artist
          Text(
            'Solar Wind Echo',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Climora Ambient AI',
            style: GoogleFonts.spaceGrotesk(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 40),

          // Waveform (Simulated)
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(15, (index) {
                return _WaveformBar(
                  color: primaryColor,
                  height: [
                    20,
                    40,
                    50,
                    30,
                    60,
                    45,
                    55,
                    25,
                    40,
                    20,
                    50,
                    30,
                    45,
                    35,
                    20,
                  ][index].toDouble(),
                  delay: index * 0.05,
                );
              }),
            ),
          ),

          const SizedBox(height: 40),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shuffle_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pause_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.repeat_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Progress
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1:45',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '4:32',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12,
                  ),
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                  thumbColor: Colors.white,
                ),
                child: Slider(value: 0.4, onChanged: (v) {}),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Volume and Footer
          Row(
            children: [
              const Icon(
                Icons.volume_down_rounded,
                color: Colors.white24,
                size: 16,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: SliderComponentShape.noThumb,
                    activeTrackColor: Colors.white60,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Slider(value: 0.75, onChanged: (v) {}),
                ),
              ),
              const Icon(
                Icons.volume_up_rounded,
                color: Colors.white24,
                size: 16,
              ),
            ],
          ),

          const Spacer(),

          // Footer Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterBtn(icon: Icons.devices_rounded, label: 'OUTPUT'),
              const SizedBox(width: 24),
              _FooterBtn(icon: Icons.queue_music_rounded, label: 'QUEUE'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveformBar extends StatefulWidget {
  final Color color;
  final double height;
  final double delay;

  const _WaveformBar({
    required this.color,
    required this.height,
    required this.delay,
  });

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
      begin: widget.height * 0.3,
      end: widget.height,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.repeat(reverse: true);
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
      builder: (context, _) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 3,
        height: _animation.value,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _FooterBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FooterBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 14),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white24,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
