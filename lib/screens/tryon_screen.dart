import 'package:flutter/material.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:flutter/foundation.dart';


class Constants {
  static const List<String> groupIdList = ['1ce2d3c2-e096-42a6-be41-c6d22f8cf6a9']; // Replace with your group ID
}

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  _TryOnScreenState createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  int _selectedFilter = 0;
  final List<String> _filters = ['Classic'];
  
  // Map to store lens IDs corresponding to each filter
  final Map<String, String> _filterLensIds = {
    'Classic': '78ae0bb1-6f63-4ee8-9ef6-f5b1f25ee49d',  // Replace with actual lens IDs
    // 'Modern': 'MODERN_LENS_ID',
    // 'Trendy': 'TRENDY_LENS_ID',
    // 'Casual': 'CASUAL_LENS_ID',
  };

  @override
  void initState() {
    super.initState();
    _initializeCameraKit();
  }

  Future<void> _initializeCameraKit() async {
    try {
      _controller = CameraController()
        ..init(
          config: CameraKitConfig(
            groupIds: Constants.groupIdList,
            lensOptions: const CameraKitLensOptions(
              enableZoom: true,
              enableFaceDetection: true,
            ),
          ),
        );

      await _controller?.waitForInitialization();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Failed to initialize CameraKit: $e');
    }
  }

  Future<void> _applyFilter(int index) async {
    try {
      final filterName = _filters[index];
      final lensId = _filterLensIds[filterName];
      
      if (lensId != null) {
        await _controller?.applyLens(lensId);
      }
      
      setState(() {
        _selectedFilter = index;
      });
    } catch (e) {
      print('Failed to apply filter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Try On Hairstyles'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraKitView(
              controller: _controller!,
              onLensChanged: (LensData lens) {
                print('Lens changed: ${lens.id}');
              },
              onMediaCaptured: (MediaData media) {
                print('Media captured: ${media.path}');
                // Handle captured media here
              },
            ),
          ),
          Container(
            height: 100,
            color: Colors.black87,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _applyFilter(index),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedFilter == index
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.face,
                          color: Colors.white,
                        ),
                        Text(
                          _filters[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}