abstract class BaseScheduler {
  List<int> schedule({
    required List<int> requests,
    required int initialPosition,
    required String direction,
    required int maxTrack,
  });
  
  // 移除抽象方法，使用具体实现
  int calculateTotalDistance(List<int> schedule) {
    if (schedule.length < 2) return 0;
    
    int total = 0;
    for (int i = 0; i < schedule.length - 1; i++) {
      total += (schedule[i + 1] - schedule[i]).abs();
    }
    return total;
  }
  
  String get description;
  String get complexity;
}