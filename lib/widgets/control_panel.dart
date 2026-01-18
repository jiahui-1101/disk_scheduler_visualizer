import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final VoidCallback onRunAlgorithm;
  final VoidCallback onStartAnimation;
  final VoidCallback onToggleAnimation;
  final VoidCallback onResetAnimation;
  final VoidCallback onResetToDefault;
  final bool isAnimating;
  final bool hasSchedule;
  final String currentAlgorithm;

  const ControlPanel({
    super.key,
    required this.onRunAlgorithm,
    required this.onStartAnimation,
    required this.onToggleAnimation,
    required this.onResetAnimation,
    required this.onResetToDefault,
    required this.isAnimating,
    required this.hasSchedule,
    required this.currentAlgorithm,
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
              '🎮 Control Panel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Current Algorithm: $currentAlgorithm',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            
            // Main control buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: onRunAlgorithm,
                  icon: const Icon(Icons.play_circle_filled, size: 20),
                  label: const Text('Run Algorithm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                
                ElevatedButton.icon(
                  onPressed: hasSchedule ? onStartAnimation : null,
                  icon: const Icon(Icons.animation, size: 20),
                  label: const Text('Start Animation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                
                ElevatedButton.icon(
                  onPressed: isAnimating ? onToggleAnimation : null,
                  icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow, size: 20),
                  label: Text(isAnimating ? 'Pause Animation' : 'Resume Animation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                
                OutlinedButton.icon(
                  onPressed: onResetAnimation,
                  icon: const Icon(Icons.replay, size: 20),
                  label: const Text('Reset Animation'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                
                OutlinedButton.icon(
                  onPressed: onResetToDefault,
                  icon: const Icon(Icons.restart_alt, size: 20),
                  label: const Text('Reset to Default'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}