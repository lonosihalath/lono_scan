//  Created by chaves on 2020/10/9.
// Modify by Lono Sihalath 10/01/2025 😁

import Flutter
import UIKit

public class ScanViewFactory: NSObject, FlutterPlatformViewFactory {  // Changed class name to match Swift convention
  var registrar: FlutterPluginRegistrar!
  
  @objc public init(registrar: FlutterPluginRegistrar?) {
    super.init()
    self.registrar = registrar
  }
  
  public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    // Corrected class name to 'ScanPlatformView' (capital S)
    return ScanPlatformView(frame, viewId: viewId, args: args, registrar: registrar)
  }
  
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}
