import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';
import 'services/api_service.dart';
import 'widgets/enhanced_result_dialog.dart';
import 'widgets/manulation_heatmap.dart';

void main() {
  runApp(const LivenessAIApp());
}

class LivenessAIApp extends StatelessWidget {
  const LivenessAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LivenessAI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D4FF),
          secondary: const Color(0xFF0099CC),
        ),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.forward();
    
    // Navigate to main screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A237E),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing logo
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00D4FF),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'LIVENESS-AI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00D4FF),
                    letterSpacing: 2,
                  ),
                ),
              )
                  .animate(controller: _controller, autoPlay: true)
                  .fadeIn(duration: const Duration(seconds: 2))
                  .scale(duration: const Duration(seconds: 2)),
              
              const SizedBox(height: 40),
              
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
                strokeWidth: 2,
              )
                  .animate(controller: _controller, autoPlay: true)
                  .fadeIn(delay: const Duration(milliseconds: 500)),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isDarkMode = true;
  int _selectedTabIndex = 0;
  List<double> _confidenceData = [0.5, 0.6, 0.7, 0.8, 0.9, 0.85, 0.9];
  List<Map<String, dynamic>> _detectedPhotos = [];
  String? _resultStatus;
  double? _resultConfidence;
  Map<String, dynamic>? _analysisDetails;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadDetectedPhotos();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          _cameraController = CameraController(
            _cameras![0],
            ResolutionPreset.high,
          );
          await _cameraController!.initialize();
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      } catch (e) {
        print('Camera initialization error: $e');
      }
    } else {
      _showPermissionDialog();
    }
  }

  Future<void> _loadDetectedPhotos() async {
    // Load previously detected photos (mock data for now)
    setState(() {
      _detectedPhotos = [
        {
          'path': 'mock1.jpg',
          'status': 'REAL',
          'confidence': 0.92,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toString(),
        },
        {
          'path': 'mock2.jpg',
          'status': 'FAKE',
          'confidence': 0.15,
          'timestamp': DateTime.now().subtract(const Duration(hours: 4)).toString(),
        },
      ];
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text(
          'Camera Permission Required',
          style: TextStyle(color: Color(0xFF00D4FF)),
        ),
        content: const Text(
          'This app needs camera access to perform liveness detection. Please grant camera permission in settings.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF00D4FF)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final imageFile = File(image.path);
      
      final result = await ApiService.sendImage(imageFile);
      
      // Generate mock analysis details
      final analysisDetails = _generateAnalysisDetails(result);
      
      setState(() {
        _resultStatus = result['status'];
        _resultConfidence = result['confidence'];
        _analysisDetails = analysisDetails;
        _isProcessing = false;
        
        // Update confidence chart
        _confidenceData.add(_resultConfidence ?? 0.5);
        if (_confidenceData.length > 10) {
          _confidenceData.removeAt(0);
        }
        
        // Add to detected photos
        _detectedPhotos.insert(0, {
          'path': image.path,
          'status': result['status'],
          'confidence': result['confidence'],
          'timestamp': DateTime.now().toString(),
        });
      });

      _showEnhancedResultDialog();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Error: $e');
    }
  }

  Map<String, dynamic> _generateAnalysisDetails(Map<String, dynamic> result) {
    final isReal = result['status'] == 'REAL';
    final confidence = result['confidence'] ?? 0.5;
    
    return {
      'depth_analysis': isReal ? 'Normal 3D depth detected' : 'Flat 3D depth - possible photo spoof',
      'texture_analysis': isReal ? 'Natural skin texture patterns' : 'Unusual texture artifacts detected',
      'facial_symmetry': isReal ? 'Normal facial proportions' : 'Asymmetrical features detected',
      'eye_reflection': isReal ? 'Natural eye reflections' : 'Missing eye reflection patterns',
      'irregular_shadows': !isReal ? 'Irregular shadow patterns detected' : null,
      'distorted_fingers': !isReal ? 'Finger distortion in frame' : null,
    };
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _isProcessing = true;
      });

      try {
        final imageFile = File(pickedFile.path);
        final result = await ApiService.sendImage(imageFile);
        
        final analysisDetails = _generateAnalysisDetails(result);
        
        setState(() {
          _resultStatus = result['status'];
          _resultConfidence = result['confidence'];
          _analysisDetails = analysisDetails;
          _isProcessing = false;
          
          _confidenceData.add(_resultConfidence ?? 0.5);
          if (_confidenceData.length > 10) {
            _confidenceData.removeAt(0);
          }
          
          _detectedPhotos.insert(0, {
            'path': pickedFile.path,
            'status': result['status'],
            'confidence': result['confidence'],
            'timestamp': DateTime.now().toString(),
          });
        });

        _showEnhancedResultDialog();
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
        _showErrorDialog('Error: $e');
      }
    }
  }

  void _showEnhancedResultDialog() {
    showDialog(
      context: context,
      builder: (context) => EnhancedResultDialog(
        status: _resultStatus ?? 'UNKNOWN',
        confidence: _resultConfidence ?? 0.0,
        analysisDetails: _analysisDetails,
        onClose: () {
          Navigator.of(context).pop();
          if (_resultStatus == 'FAKE') {
            _showManipulationHeatmap();
          }
        },
      ),
    );
  }

  void _showManipulationHeatmap() {
    final suspiciousRegions = [
      {
        'x': 50,
        'y': 80,
        'width': 60,
        'height': 40,
        'confidence': 0.85,
        'type': 'eyes',
        'area': 'Eye Region',
        'description': 'Unnatural eye reflection pattern detected',
      },
      {
        'x': 120,
        'y': 150,
        'width': 80,
        'height': 60,
        'confidence': 0.92,
        'type': 'mouth',
        'area': 'Mouth Region',
        'description': 'Inconsistent mouth shape and texture',
      },
    ];

    showDialog(
      context: context,
      builder: (context) => ManipulationHeatmap(
        imagePath: 'mock_image.jpg',
        suspiciousRegions: suspiciousRegions,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF00D4FF)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0A0E27) : Colors.white,
      appBar: AppBar(
        title: Text(
          'LivenessAI',
          style: TextStyle(
            color: _isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Theme toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF1A237E),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_isDarkMode ? const Color(0xFF1A237E) : Colors.grey.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildTab(0, 'Camera', Icons.camera_alt),
                  _buildTab(1, 'Gallery', Icons.photo_library),
                  _buildTab(2, 'History', Icons.history),
                ],
              ),
            ),
            
            // Tab content
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? (_isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF1A237E))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? (_isDarkMode ? const Color(0xFF0A0E27) : Colors.white)
                    : (_isDarkMode ? const Color(0xFF00D4FF).withOpacity(0.7) : const Color(0xFF1A237E).withOpacity(0.7)),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? (_isDarkMode ? const Color(0xFF0A0E27) : Colors.white)
                      : (_isDarkMode ? const Color(0xFF00D4FF).withOpacity(0.7) : const Color(0xFF1A237E).withOpacity(0.7)),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildCameraTab();
      case 1:
        return _buildGalleryTab();
      case 2:
        return _buildHistoryTab();
      default:
        return _buildCameraTab();
    }
  }

  Widget _buildCameraTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Camera Preview
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              border: Border.all(
                color: const Color(0xFF00D4FF),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: _isCameraInitialized && _cameraController != null
                  ? CameraPreview(_cameraController!)
                  : Container(
                      color: _isDarkMode ? const Color(0xFF1A237E) : Colors.grey.withOpacity(0.3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: _isDarkMode ? const Color(0xFF00D4FF).withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Camera initializing...',
                              style: TextStyle(
                                color: _isDarkMode ? const Color(0xFF00D4FF).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          )
              .animate()
              .scale(duration: const Duration(milliseconds: 500))
              .then()
              .shimmer(duration: const Duration(seconds: 2)),

          const SizedBox(height: 40),

          // Confidence Chart
          Container(
            height: 150,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: (_isDarkMode ? const Color(0xFF1A237E).withOpacity(0.8) : Colors.grey.withOpacity(0.1)),
              border: Border.all(
                color: const Color(0xFF00D4FF).withOpacity(0.3),
              ),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _confidenceData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: const Color(0xFF00D4FF),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF00D4FF),
                        );
                      },
                    ),
                  ),
                ],
                minY: 0,
                maxY: 1,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Verify Liveness Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _captureAndAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4FF),
                  foregroundColor: const Color(0xFF0A0E27),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0E27)),
                        ),
                      )
                    : const Text(
                        'Verify Liveness',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 500))
                  .then()
                  .shimmer(duration: const Duration(seconds: 2)),

              // Upload Photo Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _pickImageFromGallery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0099CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Upload Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 200))
                  .then()
                  .shimmer(duration: const Duration(seconds: 2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Color(0xFF00D4FF).withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Gallery feature coming soon...',
              style: TextStyle(
                color: Color(0xFF00D4FF).withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Detection History',
            style: TextStyle(
              color: Color(0xFF00D4FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ..._detectedPhotos.asMap().entries.map((entry) {
            final photo = entry.value;
            final isReal = photo['status'] == 'REAL';
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1A237E) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isReal ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Status indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isReal ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Photo info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReal ? 'REAL' : 'FAKE',
                          style: TextStyle(
                            color: isReal ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Confidence: ${((photo['confidence'] ?? 0) * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          photo['timestamp'] ?? '',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white54 : Colors.black38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
