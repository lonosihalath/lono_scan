import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LonoScan {
  static const MethodChannel _channel = const MethodChannel('lono/scan');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> parse(String path) async {
    final String? result = await _channel.invokeMethod('parse', path);
    return result;
  }
}

class LonoScanView extends StatefulWidget {
  LonoScanView({
    this.controller,
    this.onCapture,
    this.scanLineColor = Colors.green,
    this.scanAreaScale = 0.7,
  })  : assert(scanAreaScale <= 1.0, 'scanAreaScale must <= 1.0'),
        assert(scanAreaScale > 0.0, 'scanAreaScale must > 0.0');

  final LonoScanController? controller;
  final CaptureCallback? onCapture;
  final Color scanLineColor;
  final double scanAreaScale;

  @override
  State<StatefulWidget> createState() => _scanViewState();
}

class _scanViewState extends State<LonoScanView> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'lono/scan_view',
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          "r": widget.scanLineColor.red,
          "g": widget.scanLineColor.green,
          "b": widget.scanLineColor.blue,
          "a": widget.scanLineColor.opacity,
          "scale": widget.scanAreaScale,
        },
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'lono/scan_view',
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          "r": widget.scanLineColor.red,
          "g": widget.scanLineColor.green,
          "b": widget.scanLineColor.blue,
          "a": widget.scanLineColor.opacity,
          "scale": widget.scanAreaScale,
        },
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    }
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('lono/scan/method_$id');
    _channel?.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        if (widget.onCapture != null)
          widget.onCapture!(call.arguments.toString());
      }
    });
    widget.controller?._channel = _channel;
  }
}

typedef CaptureCallback(String data);

class scanArea {
  const scanArea(this.width, this.height);

  final double width;
  final double height;
}

class LonoScanController {
  MethodChannel? _channel;

  LonoScanController();

  void resume() {
    print("LonoScan resume...");
    _channel?.invokeMethod("resume");
  }

  void pause() {
    print("LonoScan pause...");
    _channel?.invokeMethod("pause");
  }

  void toggleTorchMode() {
    print("LonoScan toggleTorchMode...");
    _channel?.invokeMethod("toggleTorchMode");
  }

  void dispose() {
    print("LonoScan dispose...");
    _channel?.invokeMethod('dispose');
    _channel = null;
  }
}
