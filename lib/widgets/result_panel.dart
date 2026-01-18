import 'package:flutter/material.dart';

class ResultPanel extends StatelessWidget {
  final String algorithm;
  final List<int> schedule;
  final int totalDistance;
  final String averageSeekTime;

  const ResultPanel({
    super.key,
    required this.algorithm,
    required this.schedule,
    required this.totalDistance,
    required this.averageSeekTime,
  });

  @override
  Widget build(BuildContext context) {
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
              '📊 Algorithm Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Key metrics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem(
                    icon: Icons.alt_route,
                    title: 'Total Distance',
                    value: '$totalDistance tracks',
                    color: Colors.blue,
                  ),
                  _buildMetricItem(
                    icon: Icons.schedule,
                    title: 'Avg Seek Time',
                    value: '$averageSeekTime ms',
                    color: Colors.green,
                  ),
                  _buildMetricItem(
                    icon: Icons.list,
                    title: 'Steps',
                    value: '${schedule.length}',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Schedule sequence
            const Text(
              '🔄 Schedule Sequence',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: schedule.asMap().entries.map((entry) {
                    int index = entry.key;
                    int track = entry.value;
                    bool isStart = index == 0;
                    
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isStart ? Colors.green.shade100 : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isStart ? Colors.green : Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (isStart) ...[
                                const Icon(Icons.play_arrow, size: 14, color: Colors.green),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                '$track',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isStart ? Colors.green.shade800 : Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < schedule.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Algorithm description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        '$algorithm Algorithm',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getAlgorithmDescription(algorithm),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _getAlgorithmDescription(String algorithm) {
    switch (algorithm) {
      case 'SCAN':
        return 'Elevator Algorithm: Moves from one end to the other, serving all requests along the way, then reverses direction at the boundary. Suitable for heavy workloads.';
      case 'C-SCAN':
        return 'Circular Scan: Moves in one direction, jumps to the opposite end when reaching boundary and continues in same direction. Provides more uniform waiting times.';
      case 'LOOK':
        return 'Smart Scan: Serves all requests in current direction, reverses at the last request without going to disk boundaries. More efficient.';
      case 'C-LOOK':
        return 'Circular LOOK: Moves in one direction, after serving all requests jumps to the nearest request in opposite direction. Balances efficiency and fairness.';
      default:
        return '';
    }
  }
}