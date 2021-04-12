
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNSocialManager : NSObject <RCTBridgeModule>

+ (void)registerWeixin:(NSString *)appId universalLink:(NSString *)universalLink;

@end
  
