import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disk_scheduler_visualizer/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiskSchedulerVisualizerApp());

    // Verify that our counter starts at 0.
    expect(find.text('外卖骑手磁盘调度算法可视化'), findsOneWidget);
  });
}