import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManipulationHeatmap extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> suspiciousRegions;

  const ManipulationHeatmap({
    super.key,
    required this.imagePath,
    required this.suspiciousRegions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00D4FF).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF00D4FF),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Manipulation Analysis',
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Image with heatmap overlay
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF0A0E27),
              ),
              child: Stack(
                children: [
                  // Base image (placeholder)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white54,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image Preview',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Heatmap overlays
                  ...suspiciousRegions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final region = entry.value;
                    
                    return Positioned(
                      left: region['x']?.toDouble() ?? 0,
                      top: region['y']?.toDouble() ?? 0,
                      child: Container(
                        width: region['width']?.toDouble() ?? 50,
                        height: region['height']?.toDouble() ?? 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red.withOpacity(0.3),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${(region['confidence'] * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 100 * (index + 1)))
                          .scale(duration: const Duration(milliseconds: 300)),
                    );
                  }).toList(),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Analysis details
            _buildAnalysisDetails(),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: const Color(0xFF0A0E27),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00D4FF),
                    side: const BorderSide(color: Color(0xFF00D4FF)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suspicious Areas Detected:',
            style: TextStyle(
              color: Color(0xFF00D4FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...suspiciousRegions.asMap().entries.map((entry) {
            final region = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getRegionColor(region['type']),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region['area'] ?? 'Unknown Area',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          region['description'] ?? 'No description available',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
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

  Color _getRegionColor(String? type) {
    switch (type) {
      case 'face':
        return Colors.orange;
      case 'eyes':
        return Colors.yellow;
      case 'mouth':
        return Colors.purple;
      case 'background':
        return Colors.blue;
      case 'reflection':
        return Colors.cyan;
      default:
        return Colors.red;
    }
  }
}
