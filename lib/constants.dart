import 'package:flutter/material.dart';

// 常量定义文件
class AppConstants {
  // 系统配置
  static const int minTrack = 0;
  static const int maxTrack = 199;
  static const int defaultInitialPosition = 100;
  static const String defaultDirection = 'north';
  static const List<int> defaultRequests = [18, 38, 39, 55, 58, 90, 150, 160, 184];
  
  // 算法定义
  static const List<String> algorithms = ['SCAN', 'C-SCAN', 'LOOK', 'C-LOOK'];
  
  // 算法描述
  static const Map<String, String> algorithmDescriptions = {
    'SCAN': '电梯算法：磁头从一端移动到另一端，服务途中的所有请求，到达边界后掉头。适合负载较重的情况。',
    'C-SCAN': '循环扫描：磁头单向移动，到达边界后直接跳回另一端继续同向移动。提供更均匀的等待时间。',
    'LOOK': '智能扫描：磁头移动方向上服务所有请求，在最后一个请求处掉头，不到达磁盘边界。效率较高。',
    'C-LOOK': '智能循环：磁头单向移动，服务完所有请求后跳回另一端继续同向移动，不访问空区域。兼顾效率与公平性。',
  };
  
  // 算法复杂度
  static const Map<String, String> algorithmComplexities = {
    'SCAN': 'O(n log n)',
    'C-SCAN': 'O(n log n)',
    'LOOK': 'O(n log n)',
    'C-LOOK': 'O(n log n)',
  };
  
  // 算法图标
  static final Map<String, IconData> algorithmIcons = {
    'SCAN': Icons.elevator,
    'C-SCAN': Icons.repeat_one,
    'LOOK': Icons.compass_calibration,
    'C-LOOK': Icons.repeat,
  };
  
  // 算法颜色
  static final Map<String, Color> algorithmColors = {
    'SCAN': Colors.blue,
    'C-SCAN': Colors.green,
    'LOOK': Colors.orange,
    'C-LOOK': Colors.purple,
  };
  
  // 动画配置
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const double animationSpeed = 1.0;
  static const double riderSpeed = 50.0; // 像素/秒
  
  // UI 配置
  static const double trackHeight = 150.0;
  static const double houseSize = 40.0;
  static const double riderSize = 50.0;
  static const double trackPadding = 20.0;
  
  // 颜色主题
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.orange;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color errorColor = Colors.red;
  static const Color infoColor = Colors.blue;
  
  // 道路颜色
  static const Color trackColor = Color(0xFF9E9E9E);
  static const Color trackProgressColor = Colors.blue;
  static const Color trackLineColor = Color(0xFF757575);
  
  // 房屋状态颜色
  static const Color housePendingColor = Colors.blue;
  static const Color houseCurrentColor = Colors.orange;
  static const Color houseCompletedColor = Colors.green;
  static const Color houseHighlightColor = Colors.red;
  
  // 骑手颜色
  static const Color riderColor = Colors.orange;
  static const Color riderShadowColor = Color(0x40000000);
  
  // 文本样式 - 移除字体引用，使用默认字体
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  
  // 轨道标记
  static const List<int> trackMarkers = [0, 50, 100, 150, 199];
  
  // 路径动画配置
  static const double pathStrokeWidth = 3.0;
  static const Color pathColor = Colors.orange;
  static const Color pathCompletedColor = Colors.green;
  
  // 模拟配置
  static const int seekTimePerTrack = 1; // 每个磁道寻道时间(ms)
  static const int rotationDelay = 5; // 旋转延迟(ms)
  
  // 性能指标权重
  static const double weightSeekTime = 0.7;
  static const double weightRotationTime = 0.3;
}