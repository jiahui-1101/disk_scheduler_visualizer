// 配送请求模型
class DeliveryRequest {
  final int trackNumber;      // 磁道号
  final String houseNumber;   // 门牌号（格式化的）
  bool isDelivered;           // 是否已配送
  bool isCurrentTarget;       // 是否当前目标
  DateTime? deliveryTime;     // 配送时间
  
  DeliveryRequest({
    required this.trackNumber,
    this.isDelivered = false,
    this.isCurrentTarget = false,
    this.deliveryTime,
  }) : houseNumber = '$trackNumber号';
  
  // 格式化时间
  String get formattedDeliveryTime {
    if (deliveryTime == null) return '未配送';
    return '${deliveryTime!.hour}:${deliveryTime!.minute.toString().padLeft(2, '0')}:${deliveryTime!.second.toString().padLeft(2, '0')}';
  }
  
  // 复制对象
  DeliveryRequest copyWith({
    int? trackNumber,
    bool? isDelivered,
    bool? isCurrentTarget,
    DateTime? deliveryTime,
  }) {
    return DeliveryRequest(
      trackNumber: trackNumber ?? this.trackNumber,
      isDelivered: isDelivered ?? this.isDelivered,
      isCurrentTarget: isCurrentTarget ?? this.isCurrentTarget,
      deliveryTime: deliveryTime ?? this.deliveryTime,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeliveryRequest &&
        other.trackNumber == trackNumber &&
        other.isDelivered == isDelivered &&
        other.isCurrentTarget == isCurrentTarget;
  }
  
  @override
  int get hashCode {
    return trackNumber.hashCode ^
        isDelivered.hashCode ^
        isCurrentTarget.hashCode;
  }
  
  @override
  String toString() {
    return 'DeliveryRequest{track: $trackNumber, delivered: $isDelivered, current: $isCurrentTarget}';
  }
}

// 配送批次（一次调度包含多个请求）
class DeliveryBatch {
  final List<DeliveryRequest> requests;
  final DateTime startTime;
  DateTime? endTime;
  
  DeliveryBatch({
    required this.requests,
    required this.startTime,
    this.endTime,
  });
  
  // 获取未完成的请求
  List<DeliveryRequest> get pendingRequests =>
      requests.where((req) => !req.isDelivered).toList();
  
  // 获取已完成的请求
  List<DeliveryRequest> get completedRequests =>
      requests.where((req) => req.isDelivered).toList();
  
  // 获取当前目标请求
  List<DeliveryRequest> get currentTargets =>
      requests.where((req) => req.isCurrentTarget).toList();
  
  // 获取按磁道排序的请求
  List<DeliveryRequest> get sortedRequests =>
      List.from(requests)..sort((a, b) => a.trackNumber.compareTo(b.trackNumber));
  
  // 计算配送时间
  Duration? get deliveryDuration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }
  
  // 标记请求完成
  void markDelivered(int trackNumber, DateTime time) {
    for (var request in requests) {
      if (request.trackNumber == trackNumber && !request.isDelivered) {
        request.isDelivered = true;
        request.isCurrentTarget = false;
        request.deliveryTime = time;
        break;
      }
    }
    
    // 如果所有请求都完成，记录结束时间
    if (pendingRequests.isEmpty && endTime == null) {
      endTime = time;
    }
  }
  
  // 设置当前目标
  void setCurrentTarget(int trackNumber) {
    // 清除所有当前目标
    for (var request in requests) {
      request.isCurrentTarget = false;
    }
    
    // 设置新的当前目标
    for (var request in requests) {
      if (request.trackNumber == trackNumber && !request.isDelivered) {
        request.isCurrentTarget = true;
        break;
      }
    }
  }
  
  // 批量添加请求
  void addRequests(List<int> trackNumbers) {
    for (int trackNumber in trackNumbers) {
      if (!requests.any((req) => req.trackNumber == trackNumber)) {
        requests.add(DeliveryRequest(trackNumber: trackNumber));
      }
    }
  }
  
  // 清除所有请求
  void clearRequests() {
    requests.clear();
  }
}