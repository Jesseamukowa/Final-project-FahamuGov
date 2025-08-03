import 'package:flutter/material.dart';

class ChatroomState extends StatefulWidget {
  const ChatroomState({super.key});

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<ChatroomState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.red.withOpacity(0.15),
              Colors.green.withOpacity(0.1),
              Colors.white.withOpacity(0.95),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Community Chat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Spacer(),
                    // Notification bell with subtle animation
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _fadeAnimation.value * 0.1,
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                            onPressed: () {
                              // Future notification functionality
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Large Chat Icon with subtle glow effect
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.white, Colors.grey[50]!],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CustomPaint(
                                      painter: ChatBubblePainter(),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 40),

                              // Main Message
                              Text(
                                'Community Chat',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontFamily: 'Poppins',
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                'coming soon...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              SizedBox(height: 32),

                              // Description Text
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'Connect with fellow Kenyans to discuss civic matters, share ideas, and build a stronger democracy together.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),

                              SizedBox(height: 48),

                              // Feature Preview Cards
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildFeatureCard(
                                        icon: Icons.groups_outlined,
                                        title: 'Group Discussions',
                                        subtitle: 'Join topic-based rooms',
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFeatureCard(
                                        icon: Icons.verified_user_outlined,
                                        title: 'Safe Space',
                                        subtitle: 'Moderated conversations',
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildFeatureCard(
                                        icon: Icons.trending_up_outlined,
                                        title: 'Real-time Updates',
                                        subtitle: 'Stay informed instantly',
                                        color: Colors.orange,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFeatureCard(
                                        icon: Icons.emoji_events_outlined,
                                        title: 'Civic Rewards',
                                        subtitle: 'Earn participation points',
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Action Area
              Container(
                margin: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Notify Me Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _showNotifyDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.green.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_active, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Notify Me When Ready',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Learn More Link
                    TextButton(
                      onPressed: () {
                        _showLearnMoreDialog();
                      },
                      child: Text(
                        'Learn more about FahamuGov',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showNotifyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.green[600]),
              SizedBox(width: 8),
              Text(
                'Get Notified',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'We\'ll send you a notification as soon as Community Chat is available. Stay tuned for exciting civic discussions!',
            style: TextStyle(fontFamily: 'Roboto', height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Maybe Later',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'You\'ll be notified when Community Chat launches!',
                    ),
                    backgroundColor: Colors.green[600],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Notify Me'),
            ),
          ],
        );
      },
    );
  }

  void _showLearnMoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'About FahamuGov',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FahamuGov empowers Kenyan youth to:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              _buildBulletPoint('🏛️ Learn about government processes'),
              _buildBulletPoint('💰 Track public budget spending'),
              _buildBulletPoint('🎥 Watch civic education content'),
              _buildBulletPoint('💬 Engage in meaningful discussions'),
              _buildBulletPoint('🗳️ Participate in democracy'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Roboto', fontSize: 14, height: 1.3),
      ),
    );
  }
}

// Custom painter for the chat bubble icon
class ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Main bubble
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 24, size.height - 24),
      Radius.circular(16),
    );
    path.addRRect(rect);

    // Tail of the speech bubble
    path.moveTo(20, size.height - 16);
    path.lineTo(12, size.height - 8);
    path.lineTo(28, size.height - 16);

    canvas.drawPath(path, paint);

    // Add dots inside the bubble
    final dotPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2 - 4;

    canvas.drawCircle(Offset(centerX - 12, centerY), 3, dotPaint);
    canvas.drawCircle(Offset(centerX, centerY), 3, dotPaint);
    canvas.drawCircle(Offset(centerX + 12, centerY), 3, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
