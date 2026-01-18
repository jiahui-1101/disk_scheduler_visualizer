import 'package:flutter/material.dart';
import '../constants.dart';

class RiderWidget extends StatefulWidget {
  final int position;
  final double trackWidth;
  final int maxTrack;
  final bool isMoving;
  final bool isDelivering;
  final String direction;
  final double size;
  final Function(int)? onPositionChange;
  final bool showInfo;

  const RiderWidget({
    super.key,
    required this.position,
    required this.trackWidth,
    required this.maxTrack,
    this.isMoving = false,
    this.isDelivering = false,
    this.direction = 'north',
    this.size = AppConstants.riderSize,
    this.onPositionChange,
    this.showInfo = true,
  });

  @override
  State<RiderWidget> createState() => _RiderWidgetState();
}

class _RiderWidgetState extends State<RiderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _moveController;
  late Animation<double> _moveAnimation;
  late AnimationController _deliverController;
  late Animation<double> _deliverAnimation;
  double _currentPosition = 0.0;
  String _currentDirection = 'north';

  @override
  void initState() {
    super.initState();
    
    _currentPosition = widget.position.toDouble();
    _currentDirection = widget.direction;
    
    _moveController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    
    _moveAnimation = Tween<double>(
      begin: _currentPosition,
      end: _currentPosition,
    ).animate(
      CurvedAnimation(
        parent: _moveController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {
          _currentPosition = _moveAnimation.value;
        });
        if (widget.onPositionChange != null) {
          widget.onPositionChange!(_currentPosition.toInt());
        }
      });
    
    _deliverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _deliverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _deliverController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(RiderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 如果位置变化，启动移动动画
    if (oldWidget.position != widget.position) {
      _animateToPosition(widget.position);
    }
    
    // 如果方向变化，更新方向
    if (oldWidget.direction != widget.direction) {
      setState(() {
        _currentDirection = widget.direction;
      });
    }
    
    // 如果开始配送，启动配送动画
    if (!oldWidget.isDelivering && widget.isDelivering) {
      _startDeliveryAnimation();
    }
  }

  void _animateToPosition(int newPosition) {
    _moveAnimation = Tween<double>(
      begin: _currentPosition,
      end: newPosition.toDouble(),
    ).animate(
      CurvedAnimation(
        parent: _moveController,
        curve: Curves.easeInOut,
      ),
    );
    
    _moveController.reset();
    _moveController.forward();
  }

  void _startDeliveryAnimation() {
    _deliverController.reset();
    _deliverController.forward().then((_) {
      _deliverController.reverse();
    });
  }

  double _calculateXPosition() {
    final double unit = widget.trackWidth / widget.maxTrack;
    return _currentPosition * unit - widget.size / 2;
  }

  IconData _getDirectionIcon() {
    if (_currentDirection == 'north') {
      return Icons.north;
    } else {
      return Icons.south;
    }
  }

  Color _getRiderColor() {
    if (widget.isDelivering) {
      return Colors.red;
    } else if (widget.isMoving) {
      return Colors.orange;
    } else {
      return AppConstants.riderColor;
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _deliverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _deliverAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _deliverAnimation.value,
          child: Positioned(
            left: _calculateXPosition(),
            top: 60,
            child: Column(
              children: [
                // 方向指示器
                if (widget.isMoving)
                  Icon(
                    _getDirectionIcon(),
                    color: _getRiderColor(),
                    size: 20,
                  ),
                
                const SizedBox(height: 4),
                
                // 骑手主体
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.riderShadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: _getRiderColor(),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        size: widget.size,
                        color: _getRiderColor(),
                      ),
                      
                      // 配送动画效果
                      if (widget.isDelivering)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // 位置标签
                if (widget.showInfo)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRiderColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getRiderColor(),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: _getRiderColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_currentPosition.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getRiderColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // 状态标签
                if (widget.isDelivering)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '配送中...',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}