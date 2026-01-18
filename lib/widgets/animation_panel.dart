import 'package:flutter/material.dart';

class AnimationPanel extends StatelessWidget {
  final List<int> schedule;
  final int currentStep;
  final List<int> requests;
  final int maxTrack;
  final int initialPosition;
  final double animationProgress;
  final bool isAnimating;

  const AnimationPanel({
    super.key,
    required this.schedule,
    required this.currentStep,
    required this.requests,
    required this.maxTrack,
    required this.initialPosition,
    required this.animationProgress,
    required this.isAnimating,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double trackWidth = screenWidth * 0.9;
    double unit = trackWidth / maxTrack;
    
    // Current rider position
    int currentPosition = schedule.isEmpty ? initialPosition : schedule[currentStep];
    double riderX = currentPosition * unit;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🚀 Animation Demo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Status indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAnimating ? Colors.green.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isAnimating ? Colors.green.shade200 : Colors.blue.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isAnimating ? Icons.play_arrow : Icons.pause,
                    color: isAnimating ? Colors.green : Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAnimating ? 'Delivery in progress...' : 'Ready for delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAnimating ? Colors.green : Colors.blue,
                          ),
                        ),
                        Text(
                          'Current Position: House $currentPosition | '
                          'Progress: ${(animationProgress * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Road and rider animation
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  // Background road
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  
                  // Progress bar (blue only, no red background)
                  Positioned(
                    top: 100,
                    left: 0,
                    child: Container(
                      width: riderX.clamp(0, trackWidth), // 确保宽度非负
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  // House markers
                  ..._buildHouseMarkers(unit),
                  
                  // Rider
                  Positioned(
                    top: 70,
                    left: (riderX - 25).clamp(0, trackWidth - 50), // 确保位置在有效范围内
                    child: _buildRider(currentPosition),
                  ),
                  
                  // Delivery path - FIXED: 确保宽度非负
                  ..._buildDeliveryPath(unit),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar at bottom (blue only)
            LinearProgressIndicator(
              value: animationProgress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            
            const SizedBox(height: 8),
            
            // Progress info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Progress: ${currentStep + 1}/${schedule.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Completed: ${_calculateDeliveredCount()}',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHouseMarkers(double unit) {
    List<Widget> markers = [];
    
    for (int request in requests) {
      double x = request * unit;
      bool isDelivered = schedule.contains(request) && 
                         schedule.indexOf(request) < currentStep;
      
      // 确保房屋位置在有效范围内
      double left = (x - 20).clamp(0, double.infinity);
      
      markers.add(
        Positioned(
          top: 40,
          left: left,
          child: Column(
            children: [
              // House number
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDelivered ? Colors.green.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDelivered ? Colors.green : Colors.blue,
                    width: 1,
                  ),
                ),
                child: Text(
                  '$request',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDelivered ? Colors.green.shade800 : Colors.blue.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // House icon
              Icon(
                isDelivered ? Icons.house_siding : Icons.home,
                color: isDelivered ? Colors.green : Colors.blue,
                size: 24,
              ),
            ],
          ),
        ),
      );
    }
    
    return markers;
  }

  Widget _buildRider(int currentPosition) {
    return Column(
      children: [
        // Rider
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.orange,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.delivery_dining,
            size: 36,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        // Current position label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$currentPosition',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDeliveryPath(double unit) {
    List<Widget> pathWidgets = [];
    
    for (int i = 0; i < currentStep && i < schedule.length - 1; i++) {
      double startX = schedule[i] * unit;
      double endX = schedule[i + 1] * unit;
      
      // 修复：确保宽度为正数
      double width = (endX - startX).abs();
      
      // 修复：确保左侧位置为最小值
      double left = startX < endX ? startX : endX;
      
      pathWidgets.add(
        Positioned(
          top: 104,
          left: left,
          child: Container(
            width: width, // 现在这个值是绝对值，总是正数
            height: 2,
            color: Colors.blue.withOpacity(0.6),
          ),
        ),
      );
    }
    
    return pathWidgets;
  }

  int _calculateDeliveredCount() {
    int count = 0;
    for (int request in requests) {
      if (schedule.contains(request) && 
          schedule.indexOf(request) < currentStep) {
        count++;
      }
    }
    return count;
  }
}