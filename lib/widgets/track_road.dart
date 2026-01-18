import 'package:flutter/material.dart';
import '../constants.dart';  // 改为相对路径导入
import 'house_widget.dart';
import 'rider_widget.dart';
import '../models/delivery_request.dart';

class TrackRoad extends StatefulWidget {
  final int maxTrack;
  final int currentPosition;
  final List<DeliveryRequest> requests;
  final bool showMarkers;
  final double height;
  final double padding;
  final bool showPath;
  final List<int>? path;
  final int currentStep;
  final Function(int)? onTrackTap;
  final bool showRider;
  final bool riderIsMoving;
  final bool riderIsDelivering;
  final String riderDirection;

  const TrackRoad({
    super.key,
    required this.maxTrack,
    required this.currentPosition,
    required this.requests,
    this.showMarkers = true,
    this.height = AppConstants.trackHeight,
    this.padding = AppConstants.trackPadding,
    this.showPath = true,
    this.path,
    this.currentStep = 0,
    this.onTrackTap,
    this.showRider = true,
    this.riderIsMoving = false,
    this.riderIsDelivering = false,
    this.riderDirection = 'north',
  });

  @override
  State<TrackRoad> createState() => _TrackRoadState();
}

class _TrackRoadState extends State<TrackRoad> {
  double _trackWidth = 0;
  late List<DeliveryRequest> _sortedRequests;

  @override
  void initState() {
    super.initState();
    _sortedRequests = List.from(widget.requests)
      ..sort((a, b) => a.trackNumber.compareTo(b.trackNumber));
  }

  @override
  void didUpdateWidget(TrackRoad oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.requests != widget.requests) {
      _sortedRequests = List.from(widget.requests)
        ..sort((a, b) => a.trackNumber.compareTo(b.trackNumber));
    }
  }

  double _getXPosition(int trackNumber) {
    final double unit = _trackWidth / widget.maxTrack;
    return trackNumber * unit;
  }

  List<Widget> _buildTrackMarkers() {
    if (!widget.showMarkers) return [];
    
    final List<Widget> markers = [];
    
    for (int marker in AppConstants.trackMarkers) {
      if (marker <= widget.maxTrack) {
        double x = _getXPosition(marker);
        
        markers.add(
          Positioned(
            left: x - 15,
            top: widget.height - 20,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 10,
                  color: AppConstants.trackLineColor,
                ),
                Text(
                  '$marker',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppConstants.trackLineColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    
    return markers;
  }

  List<Widget> _buildPathLines() {
    if (!widget.showPath || widget.path == null || widget.path!.length < 2) {
      return [];
    }
    
    final List<Widget> lines = [];
    
    for (int i = 0; i < widget.currentStep && i < widget.path!.length - 1; i++) {
      double startX = _getXPosition(widget.path![i]);
      double endX = _getXPosition(widget.path![i + 1]);
      
      // 创建路径线
      lines.add(
        Positioned(
          left: startX,
          top: widget.height / 2,
          child: Container(
            width: (endX - startX).abs(),
            height: AppConstants.pathStrokeWidth,
            color: i < widget.currentStep - 1
                ? AppConstants.pathCompletedColor
                : AppConstants.pathColor,
            child: CustomPaint(
              painter: _PathArrowPainter(
                direction: endX > startX ? 'right' : 'left',
                isActive: i == widget.currentStep - 1,
              ),
            ),
          ),
        ),
      );
      
      // 路径点标记
      lines.add(
        Positioned(
          left: startX - 4,
          top: widget.height / 2 - 4,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == 0 ? Colors.green : AppConstants.pathCompletedColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
      );
    }
    
    // 最后一个点的标记
    if (widget.currentStep < widget.path!.length) {
      double lastX = _getXPosition(widget.path![widget.currentStep]);
      
      lines.add(
        Positioned(
          left: lastX - 4,
          top: widget.height / 2 - 4,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.currentStep == 0
                  ? Colors.green
                  : AppConstants.pathColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
      );
    }
    
    return lines;
  }

  List<Widget> _buildTrackLines() {
    final List<Widget> lines = [];
    const int divisions = 20;
    final int step = widget.maxTrack ~/ divisions;
    
    for (int i = 0; i <= divisions; i++) {
      int track = i * step;
      if (track > widget.maxTrack) break;
      
      double x = _getXPosition(track);
      
      lines.add(
        Positioned(
          left: x,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: const Color.fromRGBO(128, 128, 128, 0.3),
          ),
        ),
      );
    }
    
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _trackWidth = constraints.maxWidth - 2 * widget.padding;
        
        return Container(
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: widget.padding),
          child: GestureDetector(
            onTapDown: (details) {
              if (widget.onTrackTap != null) {
                double unit = _trackWidth / widget.maxTrack;
                int track = (details.localPosition.dx / unit).round();
                track = track.clamp(0, widget.maxTrack);
                widget.onTrackTap!(track);
              }
            },
            child: Stack(
              children: [
                // 轨道背景
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFEEEEEE),
                        Color(0xFFE0E0E0),
                        Color(0xFFEEEEEE),
                      ],
                    ),
                    border: Border.all(
                      color: AppConstants.trackColor,
                      width: 2,
                    ),
                  ),
                ),
                
                // 轨道线
                ..._buildTrackLines(),
                
                // 路径线
                ..._buildPathLines(),
                
                // 房屋标记
                HouseMarkerGroup(
                  requests: _sortedRequests,
                  trackWidth: _trackWidth,
                  maxTrack: widget.maxTrack,
                  houseSize: AppConstants.houseSize,
                  onHouseTap: widget.onTrackTap != null
                      ? (request) => widget.onTrackTap!(request.trackNumber)
                      : null,
                  showNumbers: true,
                ),
                
                // 骑手
                if (widget.showRider)
                  RiderWidget(
                    position: widget.currentPosition,
                    trackWidth: _trackWidth,
                    maxTrack: widget.maxTrack,
                    isMoving: widget.riderIsMoving,
                    isDelivering: widget.riderIsDelivering,
                    direction: widget.riderDirection,
                    size: AppConstants.riderSize,
                    showInfo: true,
                  ),
                
                // 轨道标记
                ..._buildTrackMarkers(),
                
                // 当前进度指示器
                Positioned(
                  left: _getXPosition(widget.currentPosition) - 10,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color.fromRGBO(255, 255, 0, 0.3),
                          Colors.transparent,
                        ],
                      ),
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

// 路径箭头绘制器
class _PathArrowPainter extends CustomPainter {
  final String direction;
  final bool isActive;

  _PathArrowPainter({
    required this.direction,
    this.isActive = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? AppConstants.pathColor : AppConstants.pathCompletedColor
      ..style = PaintingStyle.fill;
    
    // 绘制箭头
    const double arrowSize = 8;
    
    if (direction == 'right' && size.width > arrowSize * 2) {
      // 向右箭头
      final path = Path();
      path.moveTo(size.width - arrowSize, size.height / 2);
      path.lineTo(size.width - arrowSize * 2, size.height / 2 - arrowSize / 2);
      path.lineTo(size.width - arrowSize * 2, size.height / 2 + arrowSize / 2);
      path.close();
      
      canvas.drawPath(path, paint);
    } else if (direction == 'left' && size.width > arrowSize * 2) {
      // 向左箭头
      final path = Path();
      path.moveTo(arrowSize, size.height / 2);
      path.lineTo(arrowSize * 2, size.height / 2 - arrowSize / 2);
      path.lineTo(arrowSize * 2, size.height / 2 + arrowSize / 2);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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