import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  late List<CivicReel> _reels;
  late Map<int, VideoPlayerController> _controllers;
  int _currentIndex = 0;
  bool _isVisible = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _reels = _getMockReels();
    _controllers = {};

    _initializeControllers();

    // Auto-hide overlay after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    // Initialize controllers for current and adjacent videos
    for (int i = 0; i < _reels.length; i++) {
      if (i >= _currentIndex - 1 && i <= _currentIndex + 1) {
        _initializeController(i);
      }
    }
  }

  void _initializeController(int index) {
    if (_controllers.containsKey(index)) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_reels[index].videoUrl),
    );

    _controllers[index] = controller;

    controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
        if (index == _currentIndex) {
          controller.play();
          controller.setLooping(true);
        }
      }
    });
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) return;

    // Pause previous video
    _controllers[_currentIndex]?.pause();

    setState(() {
      _currentIndex = index;
    });

    // Initialize controllers for adjacent videos
    _initializeController(index - 1);
    _initializeController(index);
    _initializeController(index + 1);

    // Play current video
    if (_controllers[index]?.value.isInitialized == true) {
      _controllers[index]?.play();
    }

    // Dispose controllers that are too far away
    _controllers.removeWhere((key, controller) {
      if ((key - index).abs() > 2) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  void _togglePlayPause() {
    final controller = _controllers[_currentIndex];
    if (controller?.value.isInitialized == true) {
      setState(() {
        if (controller!.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      });
    }
  }

  void _toggleOverlayVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });

    // Auto-hide overlay after 3 seconds
    if (_isVisible) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: _reels.length,
            itemBuilder: (context, index) {
              final reel = _reels[index];
              final controller = _controllers[index];

              return GestureDetector(
                onTap: _toggleOverlayVisibility,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Video Player
                    _buildVideoPlayer(controller, reel, index == _currentIndex),

                    // Overlay with controls and info
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: _buildReelOverlay(reel, controller),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top gradient for status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),

          // App title
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Row(
                children: [
                  Icon(Icons.account_balance, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'FahamuGov Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_reels.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(
    VideoPlayerController? controller,
    CivicReel reel,
    bool isActive,
  ) {
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail placeholder with Kenyan flag colors
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF006B3C).withOpacity(0.3), // Kenyan green
                    Colors.black.withOpacity(0.8),
                    Color(0xFFCE1126).withOpacity(0.3), // Kenyan red
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 16),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF006B3C),
                      ),
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Loading civic content...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }

  Widget _buildReelOverlay(CivicReel reel, VideoPlayerController? controller) {
    final isPlaying = controller?.value.isPlaying ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Play/Pause button in center
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: AnimatedOpacity(
                opacity: isPlaying ? 0.0 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
                ),
              ),
            ),
          ),

          // Right side actions
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: _formatViews(reel.likes),
                  onTap: () => _likeReel(reel),
                ),
                SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  onTap: () => _showComments(reel),
                ),
                SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () => _shareReel(reel),
                ),
                SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  label: 'Save',
                  onTap: () => _saveReel(reel),
                ),
              ],
            ),
          ),

          // Bottom info
          Positioned(
            left: 16,
            right: 80,
            bottom: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF006B3C), // Kenyan green
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    reel.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Title
                Text(
                  reel.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 8),

                // Creator and stats
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF006B3C),
                      child: Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reel.creator,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${_formatViews(reel.views)} views',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatDuration(reel.duration),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Description
                Text(
                  reel.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Progress bar
          if (controller?.value.isInitialized == true)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: VideoProgressIndicator(
                controller!,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Color(0xFF006B3C),
                  bufferedColor: Colors.white.withOpacity(0.3),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _shareReel(CivicReel reel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${reel.title}'),
        backgroundColor: Color(0xFF006B3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _likeReel(CivicReel reel) {
    setState(() {
      reel.likes += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked: ${reel.title}'),
        backgroundColor: Color(0xFFCE1126),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveReel(CivicReel reel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: ${reel.title}'),
        backgroundColor: Color(0xFF006B3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showComments(CivicReel reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(),

            // Comments placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.comment_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Join the civic discussion!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Comments coming soon to FahamuGov',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utility methods
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }

  // Mock data
  List<CivicReel> _getMockReels() {
    return [
      CivicReel(
        id: '1',
        title: 'How Bills Become Laws in Kenya',
        description:
            'Learn the step-by-step process of how a bill becomes law in the Kenyan Parliament. Understanding this process helps you engage better with democracy.',
        videoUrl: 'https://youtu.be/_Xalal2phpA',
        creator: 'Civic Education Kenya',
        category: 'Government Process',
        duration: 180,
        views: 15420,
        likes: 892,
      ),
      CivicReel(
        id: '2',
        title: 'Your Rights as a Kenyan Citizen',
        description:
            'Understanding your fundamental rights and freedoms under the Kenyan Constitution. Know your rights, exercise them responsibly.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        creator: 'Rights Awareness Kenya',
        category: 'Constitutional Rights',
        duration: 240,
        views: 23150,
        likes: 1340,
      ),
      CivicReel(
        id: '3',
        title: 'County vs National Government',
        description:
            'Understanding the difference between county and national government functions. Learn about devolution and how it affects you.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        creator: 'Devolution Explained',
        category: 'Devolution',
        duration: 195,
        views: 18750,
        likes: 967,
      ),
      CivicReel(
        id: '4',
        title: 'How to Participate in Public Forums',
        description:
            'A guide to participating in county public participation forums. Your voice matters in governance - learn how to make it heard.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        creator: 'Civic Engagement Hub',
        category: 'Public Participation',
        duration: 210,
        views: 12890,
        likes: 743,
      ),
      CivicReel(
        id: '5',
        title: 'Understanding the Budget Process',
        description:
            'How government budgets are made and how you can influence them. Learn about budget cycles and public participation opportunities.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        creator: 'Budget Transparency Kenya',
        category: 'Budget & Finance',
        duration: 165,
        views: 9876,
        likes: 521,
      ),
      CivicReel(
        id: '6',
        title: 'Electoral Process in Kenya',
        description:
            'Understanding how elections work in Kenya - from registration to voting. Be an informed voter and participate in democracy.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        creator: 'Electoral Education',
        category: 'Elections',
        duration: 220,
        views: 31250,
        likes: 1876,
      ),
    ];
  }
}

// Data model class
class CivicReel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String creator;
  final String category;
  final int duration;
  final int views;
  int likes;

  CivicReel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.creator,
    required this.category,
    required this.duration,
    required this.views,
    required this.likes,
  });
}
