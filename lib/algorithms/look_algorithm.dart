import 'base_scheduler.dart';

class LookAlgorithm extends BaseScheduler {  // 改为 extends
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
      
      // 掉头向左移动（不到达边界）
      if (left.isNotEmpty) {
        for (int i = left.length - 1; i >= 0; i--) {
          schedule.add(left[i]);
        }
      }
    } else {
      // 先向左移动服务所有请求
      for (int i = left.length - 1; i >= 0; i--) {
        schedule.add(left[i]);
      }
      
      // 掉头向右移动（不到达边界）
      if (right.isNotEmpty) {
        for (int request in right) {
          schedule.add(request);
        }
      }
    }
    
    return schedule;
  }
  
  @override
  String get description => 'LOOK算法：磁头移动方向上服务所有请求，在最后一个请求处掉头，不到达磁盘边界';
  
  @override
  String get complexity => 'O(n log n)';
}