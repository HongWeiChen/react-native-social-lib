//
//  RNSocialShareProtocol.h
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RNSocialShareProtocol <NSObject>

- (void)shareToWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed;

@end

NS_ASSUME_NONNULL_END
