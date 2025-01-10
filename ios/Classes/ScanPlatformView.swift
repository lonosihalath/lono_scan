//  lono_scan
//
//  // Modify by Lono Sihalath 10/01/2025 😁

import Flutter
import UIKit


public class ScanPlatformView: NSObject, FlutterPlatformView {
  
  var customScanView: ScanView?  // Renamed variable to avoid ambiguity
  var viewId: Int64!
  var channel: FlutterMethodChannel?
  
  init(_ frame: CGRect, viewId: Int64, args: Any?, registrar: FlutterPluginRegistrar) {
    super.init()
    
    // Now properly initialize ScanView (which should be a custom UIView subclass)
    self.customScanView = ScanView(frame: frame, viewId: viewId, args: args, registrar: registrar)
    self.viewId = viewId
  }
  
  public func view() -> UIView {
    return self.customScanView!  // Return the custom scan view instance
  }
}

// Ensure ScanView is a subclass of UIView
public class ScanView: UIView {
    
    init(frame: CGRect, viewId: Int64, args: Any?, registrar: FlutterPluginRegistrar) {
        super.init(frame: frame)
        
        // Your custom initialization for ScanView here
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Extension for UIColor to support hex color initialization
extension UIColor {
    // Initializes UIColor from a hex string with an alpha value
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    // Initializes UIColor from a hex string with full opacity (alpha = 1)
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
