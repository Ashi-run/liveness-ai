import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EnhancedResultDialog extends StatelessWidget {
  final String status;
  final double confidence;
  final Map<String, dynamic>? analysisDetails;
  final VoidCallback onClose;

  const EnhancedResultDialog({
    super.key,
    required this.status,
    required this.confidence,
    this.analysisDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isReal = status == 'REAL';
    final authenticityScore = (confidence * 100).toStringAsFixed(1);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isReal ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isReal ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isReal ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isReal ? Icons.check_circle : Icons.warning,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isReal ? 'Liveness Verified' : 'Security Alert',
                        style: TextStyle(
                          color: isReal ? Colors.green : Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isReal ? 'Face is AUTHENTIC' : 'Spoof Detected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Authenticity Score
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Authenticity Score',
                    style: TextStyle(
                      color: Color(0xFF00D4FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$authenticityScore%',
                        style: TextStyle(
                          color: isReal ? Colors.green : Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isReal ? 'Likely Real' : 'Likely Fake',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // AI Explanation
            if (analysisDetails != null) _buildAIExplanation(analysisDetails!),
            
            const SizedBox(height: 16),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReal ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .scale(duration: const Duration(milliseconds: 300), begin: const Offset(0.8, 0.8))
          .fadeIn(duration: const Duration(milliseconds: 300)),
    );
  }

  Widget _buildAIExplanation(Map<String, dynamic> details) {
    final reasons = <String>[];
    
    if (details.containsKey('depth_analysis')) {
      reasons.add('• 3D depth analysis: ${details['depth_analysis']}');
    }
    if (details.containsKey('texture_analysis')) {
      reasons.add('• Texture patterns: ${details['texture_analysis']}');
    }
    if (details.containsKey('facial_symmetry')) {
      reasons.add('• Facial symmetry: ${details['facial_symmetry']}');
    }
    if (details.containsKey('eye_reflection')) {
      reasons.add('• Eye reflection: ${details['eye_reflection']}');
    }
    
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
            'AI Analysis Details',
            style: TextStyle(
              color: Color(0xFF00D4FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...reasons.map((reason) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              reason,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
