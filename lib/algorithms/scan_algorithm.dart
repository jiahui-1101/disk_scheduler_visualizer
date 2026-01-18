import 'base_scheduler.dart';

class ScanAlgorithm extends BaseScheduler {  // 改为 extends
  @override
  List<int> schedule({
    required List<int> requests,
    required int initialPosition,
    required String direction,
    required int maxTrack,
  }) {
    List<int> schedule = [initialPosition];
    List<int> sortedRequests = List.from(requests)..sort();
    
    // 分离左右请求
    List<int> left = sortedRequests.where((r) => r < initialPosition).toList();
    List<int> right = sortedRequests.where((r) => r >= initialPosition).toList();
    
    if (direction == 'north') {
      // 先向右移动（向大磁道号）
      for (int request in right) {
        schedule.add(request);
      }
      
      // 到达边界后掉头
      if (left.isNotEmpty) {
        // 先到最右端
        schedule.add(maxTrack);
        // 然后向左移动
        for (int i = left.length - 1; i >= 0; i--) {
          schedule.add(left[i]);
        }
      }
    } else {
      // 先向左移动（向小磁道号）
      for (int i = left.length - 1; i >= 0; i--) {
        schedule.add(left[i]);
      }
      
      // 到达边界后掉头
      if (right.isNotEmpty) {
        // 先到最左端
        schedule.add(0);
        // 然后向右移动
        for (int request in right) {
          schedule.add(request);
        }
      }
    }
    
    return schedule;
  }
  
  @override
  String get description => 'SCAN算法（电梯算法）：磁头从一端移动到另一端，服务途中的所有请求，到达边界后掉头';
  
  @override
  String get complexity => 'O(n log n)';
}