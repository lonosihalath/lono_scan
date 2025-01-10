// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lono_scan/lono_scan.dart';

class LonoScanPage extends StatelessWidget {
  final LonoScanController controller = LonoScanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            Container(
              child: LonoScanView(
                controller: controller,
                scanAreaScale: 0.8,
                scanLineColor: Colors.orange,
                onCapture: (data) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Scan Result'),
                          backgroundColor: Colors.orange,
                        ),
                        body: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              data,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  )).then((value) {
                    controller.resume();
                  });
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton(
                        label: "Toggle Torch",
                        icon: Icons.flash_on,
                        onPressed: () {
                          controller.toggleTorchMode();
                        },
                      ),
                      _buildButton(
                        label: "Pause",
                        icon: Icons.pause,
                        onPressed: () {
                          controller.pause();
                        },
                      ),
                      _buildButton(
                        label: "Resume",
                        icon: Icons.play_arrow,
                        onPressed: () {
                          controller.resume();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.orange,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min, // Ensures the button size adjusts to content
    children: [
      Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      const SizedBox(height: 4), // Spacing between icon and text
      Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    ],
  ),
);

  }
}
