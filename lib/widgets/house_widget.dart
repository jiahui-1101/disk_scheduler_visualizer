import 'package:flutter/material.dart';
import '../models/delivery_request.dart';
import '../constants.dart';

class HouseWidget extends StatefulWidget {
  final DeliveryRequest request;
  final double size;
  final bool showNumber;
  final bool animateDelivery;
  final VoidCallback? onTap;
  final bool showHighlight;

  const HouseWidget({
    super.key,
    required this.request,
    this.size = AppConstants.houseSize,
    this.showNumber = true,
    this.animateDelivery = false,
    this.onTap,
    this.showHighlight = false,
  });

  @override
  State<HouseWidget> createState() => _HouseWidgetState();
}

class _HouseWidgetState extends State<HouseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _colorAnimation = ColorTween(
      begin: AppConstants.housePendingColor,
      end: AppConstants.houseCompletedColor,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(HouseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 如果请求状态变化且需要动画
    if (oldWidget.request.isDelivered != widget.request.isDelivered &&
        widget.animateDelivery &&
        widget.request.isDelivered) {
      _startDeliveryAnimation();
    }
    
    // 如果当前目标状态变化
    if (oldWidget.request.isCurrentTarget != widget.request.isCurrentTarget) {
      setState(() {});
    }
  }

  void _startDeliveryAnimation() {
    if (_isAnimating) return;
    
    _isAnimating = true;
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        _isAnimating = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getHouseColor() {
    if (widget.request.isDelivered) {
      return AppConstants.houseCompletedColor;
    } else if (widget.request.isCurrentTarget) {
      return AppConstants.houseCurrentColor;
    } else {
      return AppConstants.housePendingColor;
    }
  }

  IconData _getHouseIcon() {
    if (widget.request.isDelivered) {
      return Icons.house_siding; // 已完成配送的房屋
    } else if (widget.request.isCurrentTarget) {
      return Icons.home_work; // 当前目标的房屋
    } else {
      return Icons.home; // 普通待配送房屋
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value * (3.1415926535 / 180),
              child: Column(
                children: [
                  // 门牌号
                  if (widget.showNumber)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _colorAnimation.value ?? _getHouseColor(),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getHouseColor(),
                          width: 1,
                        ),
                        boxShadow: widget.showHighlight
                            ? [
                                BoxShadow(
                                  color: AppConstants.houseHighlightColor
                                      .withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        widget.request.houseNumber,
                        style: TextStyle(
                          fontSize: widget.size * 0.25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  // 房屋图标
                  Stack(
                    children: [
                      Icon(
                        _getHouseIcon(),
                        size: widget.size,
                        color: _colorAnimation.value ?? _getHouseColor(),
                      ),
                      
                      // 配送状态指示器
                      if (widget.request.isDelivered)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // 状态标签
                  if (widget.request.isCurrentTarget)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.houseCurrentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppConstants.houseCurrentColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '配送中',
                        style: TextStyle(
                          fontSize: widget.size * 0.15,
                          color: AppConstants.houseCurrentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 房屋标记组（用于显示多个房屋）
class HouseMarkerGroup extends StatelessWidget {
  final List<DeliveryRequest> requests;
  final double trackWidth;
  final int maxTrack;
  final double houseSize;
  final Function(DeliveryRequest)? onHouseTap;
  final bool showNumbers;

  const HouseMarkerGroup({
    super.key,
    required this.requests,
    required this.trackWidth,
    required this.maxTrack,
    this.houseSize = AppConstants.houseSize,
    this.onHouseTap,
    this.showNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    final double unit = trackWidth / maxTrack;
    
    return Stack(
      children: requests.map((request) {
        double left = request.trackNumber * unit - houseSize / 2;
        
        return Positioned(
          left: left,
          top: 0,
          child: HouseWidget(
            request: request,
            size: houseSize,
            showNumber: showNumbers,
            animateDelivery: true,
            onTap: onHouseTap != null ? () => onHouseTap!(request) : null,
          ),
        );
      }).toList(),
    );
  }
}