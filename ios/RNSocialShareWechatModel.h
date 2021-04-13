//
//  RNSocialShareWechatModel.h
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "RNSocialShareBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNSocialShareWechatModel : RNSocialShareBaseModel

/// 分享scene
@property (copy, nonatomic) NSString *scene;

/// 微信分享类型
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

@end

NS_ASSUME_NONNULL_END
