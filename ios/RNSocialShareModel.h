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

typedef NS_ENUM(NSInteger, ShareToWeixinTypes) {
    ShareToWeixinTypesText,         // > 文本
    ShareToWeixinTypesPicture,      // > 图片
    ShareToWeixinTypesVideo,        // > 视频
    ShareToWeixinTypesMusic,        // > 音乐
    ShareToWeixinTypesWebpage,      // > 网页
    ShareToWeixinTypesMusicVideo,   // > 音乐视频
    ShareToWeixinTypesMiniProgram   // > 小程序
};

NSErrorDomain ShareToWeixinErrorDomain = @"ShareToWeixinErrorDomain";

@interface RNSocialShareModel : NSObject

/// 微信分享类型 参考ShareToWeixinTypes
@property (copy, nonatomic) NSString *type;

/// 文本类型
@property (copy, nonatomic) NSString *text;             // >> 纯文本

/// MediaObject
@property (copy, nonatomic) NSString *title;            // >> 标题
@property (copy, nonatomic) NSString *desc;             // >> 描述

/// 图片
@property (copy, nonatomic) NSString *thumbImageUrl;         // >> 缩略图
@property (copy, nonatomic) NSString *imageUrl;     // >> 原图


/// 小程序
@property (copy, nonatomic) NSString *webpageUrl;       // >> 网页URL
@property (copy, nonatomic) NSString *userName;         // >> 分享用户名称
@property (copy, nonatomic) NSString *path;             // >> 分享路径Router
@property (copy, nonatomic) NSString *withShareTicket;
@property (copy, nonatomic) NSString *miniProgramType;

/**
 初始化配置参数
 */
- (instancetype)initWithParams:(NSDictionary *)params;

/// 获取分享类型
- (ShareToWeixinTypes)getShareToWeixinTypes:(NSString *)types;

/// 调用分享
- (void)shareWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed;

@end

NS_ASSUME_NONNULL_END
