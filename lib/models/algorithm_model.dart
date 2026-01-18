class AlgorithmResult {
  final String name;
  final List<int> schedule;
  final int totalDistance;
  final String description;
  final String complexity;

  AlgorithmResult({
    required this.name,
    required this.schedule,
    required this.totalDistance,
    required this.description,
    required this.complexity,
  });
}

class DeliveryRequest {
  final int trackNumber;
  bool isDelivered;
  
  DeliveryRequest(this.trackNumber, {this.isDelivered = false});
}