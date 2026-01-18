import 'base_scheduler.dart';

class CLookAlgorithm extends BaseScheduler {  // 改为 extends
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
      
      // 跳回最小请求处继续向右
      if (left.isNotEmpty) {
        // 跳回最小的请求
        schedule.add(left.first);
        // 服务剩余的请求
        for (int i = 1; i < left.length; i++) {
          schedule.add(left[i]);
        }
      }
    } else {
      // 先向左移动服务所有请求
      for (int i = left.length - 1; i >= 0; i--) {
        schedule.add(left[i]);
      }
      
      // 跳回最大请求处继续向左
      if (right.isNotEmpty) {
        // 跳回最大的请求
        schedule.add(right.last);
        // 服务剩余的请求
        for (int i = right.length - 2; i >= 0; i--) {
          schedule.add(right[i]);
        }
      }
    }
    
    return schedule;
  }
  
  @override
  String get description => 'C-LOOK算法：磁头单向移动，服务完所有请求后跳回另一端继续同向移动，不访问空区域';
  
  @override
  String get complexity => 'O(n log n)';
}