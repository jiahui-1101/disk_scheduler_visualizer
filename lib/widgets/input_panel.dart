import 'package:flutter/material.dart';

class InputPanel extends StatefulWidget {
  final List<int> requests;
  final int initialPosition;
  final String direction;
  final int maxTrack;
  final Function(int) onAddRequest;
  final Function(int) onRemoveRequest;
  final VoidCallback onClearRequests;
  final Function(int) onPositionChanged;
  final Function(String) onDirectionChanged;

  const InputPanel({
    super.key,
    required this.requests,
    required this.initialPosition,
    required this.direction,
    required this.maxTrack,
    required this.onAddRequest,
    required this.onRemoveRequest,
    required this.onClearRequests,
    required this.onPositionChanged,
    required this.onDirectionChanged,
  });

  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  final TextEditingController _requestController = TextEditingController();
  String _newRequest = '';

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
              '⚙️ System Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Track range
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.straighten, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Track Range: 0 - ${widget.maxTrack}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Initial position slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('Rider Starting Position: '),
                    Text(
                      widget.initialPosition.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: widget.initialPosition.toDouble(),
                  min: 0,
                  max: widget.maxTrack.toDouble(),
                  divisions: widget.maxTrack,
                  label: widget.initialPosition.toString(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.green.shade100,
                  onChanged: (value) {
                    widget.onPositionChanged(value.toInt());
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Direction selection
            Row(
              children: [
                const Icon(Icons.navigation, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Initial Direction: '),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Row(
                    children: [
                      Icon(Icons.north, size: 16),
                      SizedBox(width: 4),
                      Text('North (towards 199)'),
                    ],
                  ),
                  selected: widget.direction == 'north',
                  selectedColor: Colors.orange.shade100,
                  onSelected: (selected) {
                    if (selected) widget.onDirectionChanged('north');
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Row(
                    children: [
                      Icon(Icons.south, size: 16),
                      SizedBox(width: 4),
                      Text('South (towards 0)'),
                    ],
                  ),
                  selected: widget.direction == 'south',
                  selectedColor: Colors.orange.shade100,
                  onSelected: (selected) {
                    if (selected) widget.onDirectionChanged('south');
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Request collection
            const Text(
              '📋 Delivery Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current requests: ${widget.requests.length}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            
            // Request list
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.requests.map((request) {
                    return Chip(
                      label: Text('🏠 House $request'),
                      backgroundColor: Colors.blue.shade50,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => widget.onRemoveRequest(request),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Add new request
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _requestController,
                    decoration: InputDecoration(
                      labelText: 'Add new request (0-${widget.maxTrack})',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.add_location),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _newRequest = value;
                      });
                    },
                    onSubmitted: (value) {
                      _addRequest();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _addRequest,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: widget.onClearRequests,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onAddRequest(100);
                    widget.onAddRequest(150);
                    widget.onAddRequest(50);
                  },
                  icon: const Icon(Icons.lightbulb, size: 18),
                  label: const Text('Add Example'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addRequest() {
    if (_newRequest.isNotEmpty) {
      try {
        int request = int.parse(_newRequest);
        if (request >= 0 && request <= widget.maxTrack) {
          widget.onAddRequest(request);
          _requestController.clear();
          setState(() {
            _newRequest = '';
          });
        } else {
          _showError('Please enter a number between 0 and ${widget.maxTrack}');
        }
      } catch (e) {
        _showError('Please enter a valid number');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}