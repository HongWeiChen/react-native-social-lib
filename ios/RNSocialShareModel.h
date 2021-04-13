//
//  RNSocialShareModel.h
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

@interface RNSocialShareModel : NSObject

/// 分享平台
@property (copy, nonatomic) NSString *platform;

/// 分享参数
@property (copy, nonatomic) NSDictionary *shareParams;

/**
 初始化配置参数
 */
- (instancetype)initWithPlatform:(NSString *)platform shareParams:(NSDictionary *)shareParams;

/// 调用分享
- (void)shareWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed;

@end

NS_ASSUME_NONNULL_END
