import 'base_scheduler.dart';

class CScanAlgorithm extends BaseScheduler {  // 改为 extends
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
      // 先向右移动服务所有请求
      for (int request in right) {
        schedule.add(request);
      }
      
      // 到边界后直接跳回起点，继续向右
      if (left.isNotEmpty) {
        schedule.add(maxTrack);
        schedule.add(0); // 跳回起点
        for (int request in left) {
          schedule.add(request);
        }
      }
    } else {
      // 先向左移动服务所有请求
      for (int i = left.length - 1; i >= 0; i--) {
        schedule.add(left[i]);
      }
      
      // 到边界后直接跳回终点，继续向左
      if (right.isNotEmpty) {
        schedule.add(0);
        schedule.add(maxTrack); // 跳回终点
        for (int i = right.length - 1; i >= 0; i--) {
          schedule.add(right[i]);
        }
      }
    }
    
    return schedule;
  }
  
  @override
  String get description => 'C-SCAN算法（循环扫描）：磁头单向移动，到达边界后直接跳回另一端继续同向移动';
  
  @override
  String get complexity => 'O(n log n)';
}