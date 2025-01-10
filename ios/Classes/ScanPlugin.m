#import "ScanPlugin.h"
#if __has_include(<lono_scan/lono_scan-Swift.h>)
#import <lono_scan/lono_scan-Swift.h>
#else
#import "lono_scan-Swift.h"
#endif

@implementation ScanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftscanPlugin registerWithRegistrar:registrar]; // Corrected class name
}
@end
