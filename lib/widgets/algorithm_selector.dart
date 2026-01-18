import 'package:flutter/material.dart';

class AlgorithmSelector extends StatelessWidget {
  final String selectedAlgorithm;
  final Function(String) onAlgorithmSelected;

  const AlgorithmSelector({
    super.key,
    required this.selectedAlgorithm,
    required this.onAlgorithmSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> algorithms = ['SCAN', 'C-SCAN', 'LOOK', 'C-LOOK'];
    const List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    const List<IconData> icons = [
      Icons.elevator,
      Icons.repeat_one,
      Icons.compass_calibration,
      Icons.repeat,
    ];

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
              '🎯 Select Scheduling Algorithm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose a disk scheduling algorithm to simulate the food delivery strategy:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Algorithm selection buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: algorithms.asMap().entries.map((entry) {
                int index = entry.key;
                String algorithm = entry.value;
                bool isSelected = selectedAlgorithm == algorithm;
                
                return ElevatedButton(
                  onPressed: () => onAlgorithmSelected(algorithm),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? colors[index] : Color.alphaBlend(
                      colors[index].withAlpha(25), 
                      Colors.white
                    ),
                    foregroundColor: isSelected ? Colors.white : colors[index],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: isSelected ? colors[index] : colors[index].withAlpha(76),
                        width: 1,
                      ),
                    ),
                    elevation: isSelected ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        algorithm,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}