import 'package:flutter/material.dart';
import 'widgets/input_panel.dart';
import 'widgets/animation_panel.dart';
import 'widgets/control_panel.dart';
import 'widgets/result_panel.dart';
import 'widgets/algorithm_selector.dart';
import 'algorithms/scan_algorithm.dart';
import 'algorithms/cscan_algorithm.dart';
import 'algorithms/look_algorithm.dart';
import 'algorithms/clook_algorithm.dart';

void main() {
  runApp(const DiskSchedulerVisualizerApp());
}

class DiskSchedulerVisualizerApp extends StatelessWidget {
  const DiskSchedulerVisualizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disk Scheduling Algorithm Visualizer - Food Delivery Rider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // State variables
  String _selectedAlgorithm = 'SCAN';
  List<int> _requests = [18, 38, 39, 55, 58, 90, 150, 160, 184];
  int _initialPosition = 100;
  String _direction = 'north';
  final int _maxTrack = 199;
  List<int> _schedule = [];
  int _totalDistance = 0;
  bool _isAnimating = false;
  double _animationProgress = 0.0;
  int _currentStep = 0;
  
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {
          _animationProgress = _progressAnimation.value;
          if (_schedule.isNotEmpty) {
            _currentStep = (_animationProgress * (_schedule.length - 1)).floor();
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Run algorithm
  void _runAlgorithm() {
    if (_isAnimating) return;
    
    setState(() {
      _schedule.clear();
      _totalDistance = 0;
    });
    
    // Execute selected algorithm
    List<int> schedule;
    switch (_selectedAlgorithm) {
      case 'SCAN':
        schedule = ScanAlgorithm().schedule(
          requests: List.from(_requests),
          initialPosition: _initialPosition,
          direction: _direction,
          maxTrack: _maxTrack,
        );
        break;
      case 'C-SCAN':
        schedule = CScanAlgorithm().schedule(
          requests: List.from(_requests),
          initialPosition: _initialPosition,
          direction: _direction,
          maxTrack: _maxTrack,
        );
        break;
      case 'LOOK':
        schedule = LookAlgorithm().schedule(
          requests: List.from(_requests),
          initialPosition: _initialPosition,
          direction: _direction,
          maxTrack: _maxTrack,
        );
        break;
      case 'C-LOOK':
        schedule = CLookAlgorithm().schedule(
          requests: List.from(_requests),
          initialPosition: _initialPosition,
          direction: _direction,
          maxTrack: _maxTrack,
        );
        break;
      default:
        schedule = [];
    }
    
    // Calculate total distance
    int totalDistance = 0;
    if (schedule.length > 1) {
      for (int i = 0; i < schedule.length - 1; i++) {
        totalDistance += (schedule[i + 1] - schedule[i]).abs();
      }
    }
    
    setState(() {
      _schedule = schedule;
      _totalDistance = totalDistance;
      _currentStep = 0;
      _animationProgress = 0.0;
    });
  }

  // Start animation
  void _startAnimation() {
    if (_schedule.isEmpty || _isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });
    
    _animationController.reset();
    _animationController.duration = Duration(
      seconds: _schedule.length * 2, // 2 seconds per step
    );
    _animationController.forward();
  }

  // Pause/resume animation
  void _toggleAnimation() {
    if (_animationController.isAnimating) {
      _animationController.stop();
      setState(() {
        _isAnimating = false;
      });
    } else {
      _animationController.forward();
      setState(() {
        _isAnimating = true;
      });
    }
  }

  // Reset animation
  void _resetAnimation() {
    _animationController.reset();
    setState(() {
      _isAnimating = false;
      _animationProgress = 0.0;
      _currentStep = 0;
    });
  }

  // Add new request
  void _addRequest(int request) {
    if (!_requests.contains(request) && request >= 0 && request <= _maxTrack) {
      setState(() {
        _requests.add(request);
        _requests.sort();
      });
    }
  }

  // Remove request
  void _removeRequest(int request) {
    setState(() {
      _requests.remove(request);
    });
  }

  // Clear all requests
  void _clearRequests() {
    setState(() {
      _requests.clear();
    });
  }

  // Reset to default values
  void _resetToDefault() {
    setState(() {
      _requests = [18, 38, 39, 55, 58, 90, 150, 160, 184];
      _initialPosition = 100;
      _direction = 'north';
      _selectedAlgorithm = 'SCAN';
      _schedule.clear();
      _totalDistance = 0;
      _isAnimating = false;
      _animationProgress = 0.0;
      _currentStep = 0;
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.delivery_dining, color: Colors.orange),
            SizedBox(width: 10),
            Text(
              'Disk Scheduling Visualizer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Algorithm selector
                AlgorithmSelector(
                  selectedAlgorithm: _selectedAlgorithm,
                  onAlgorithmSelected: (algorithm) {
                    setState(() {
                      _selectedAlgorithm = algorithm;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Input panel
                InputPanel(
                  requests: _requests,
                  initialPosition: _initialPosition,
                  direction: _direction,
                  maxTrack: _maxTrack,
                  onAddRequest: _addRequest,
                  onRemoveRequest: _removeRequest,
                  onClearRequests: _clearRequests,
                  onPositionChanged: (value) {
                    setState(() {
                      _initialPosition = value;
                    });
                  },
                  onDirectionChanged: (value) {
                    setState(() {
                      _direction = value;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Control panel
                ControlPanel(
                  onRunAlgorithm: _runAlgorithm,
                  onStartAnimation: _startAnimation,
                  onToggleAnimation: _toggleAnimation,
                  onResetAnimation: _resetAnimation,
                  onResetToDefault: _resetToDefault,
                  isAnimating: _isAnimating,
                  hasSchedule: _schedule.isNotEmpty,
                  currentAlgorithm: _selectedAlgorithm,
                ),
                
                const SizedBox(height: 20),
                
                // Animation panel
                if (_schedule.isNotEmpty)
                  AnimationPanel(
                    schedule: _schedule,
                    currentStep: _currentStep,
                    requests: _requests,
                    maxTrack: _maxTrack,
                    initialPosition: _initialPosition,
                    animationProgress: _animationProgress,
                    isAnimating: _isAnimating,
                  ),
                
                const SizedBox(height: 20),
                
                // Result panel
                if (_schedule.isNotEmpty)
                  ResultPanel(
                    algorithm: _selectedAlgorithm,
                    schedule: _schedule,
                    totalDistance: _totalDistance,
                    averageSeekTime: _schedule.length > 1 
                        ? (_totalDistance / (_schedule.length - 1)).toStringAsFixed(1)
                        : "0.0",
                  ),
                
                // Instruction text
                if (_schedule.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 How to Use',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '1. Select a scheduling algorithm (SCAN, C-SCAN, LOOK, C-LOOK)\n'
                          '2. Adjust initial position and direction\n'
                          '3. Click "Run Algorithm" to generate schedule\n'
                          '4. Click "Start Animation" to watch delivery process\n'
                          '5. Compare performance of different algorithms',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}