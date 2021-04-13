//
//  RNSocialShareWechatModel.m
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "RNSocialShareWechatModel.h"
#import "WXApi.h"

@implementation RNSocialShareWechatModel

- (instancetype)initWithShareParams:(NSDictionary *)shareParams {
    self = [super initWithShareParams:shareParams];
    if (self) {
        self.scene = shareParams[@"scene"];
        self.type = shareParams[@"type"];
        self.text = shareParams[@"text"];
        self.title = shareParams[@"title"];
        self.desc = shareParams[@"desc"];
        self.thumbImageUrl = shareParams[@"thumbImageUrl"];
        self.imageUrl = shareParams[@"imageUrl"];
        self.webpageUrl = shareParams[@"webpageUrl"];
        self.userName = shareParams[@"userName"];
        self.path = shareParams[@"path"];
        self.withShareTicket = shareParams[@"withShareTicket"];
        self.miniProgramType = shareParams[@"miniProgramType"];
    }
    return self;
}

- (void)shareToWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed {
    if ([self.type isEqualToString:@"text"]) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = self.text;
        req.scene = [self getWechatScene];
        [WXApi sendReq:req completion:^(BOOL success) {
            [self handlerSuccess:success succeed:succeed failed:failed];
        }];
    } else if ([self.type isEqualToString:@"image"]) {
        WXImageObject *imageObject = [WXImageObject object];
        if ([self checkIsHttps:self.imageUrl]) {
            imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        } else {
            imageObject.imageData = [NSData dataWithContentsOfFile:self.imageUrl];
        }
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.title;
        message.description = self.desc;
        if ([self checkIsHttps:self.thumbImageUrl]) {
            message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbImageUrl]];
        } else {
            message.thumbData = [NSData dataWithContentsOfFile:self.thumbImageUrl];
        }
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = [self getWechatScene];
        [WXApi sendReq:req completion:^(BOOL success) {
            [self handlerSuccess:success succeed:succeed failed:failed];
        }];
    } else if ([self.type isEqualToString:@"mini"]) {
        // 小程序分享
        WXMiniProgramObject *object = [WXMiniProgramObject object];
        object.webpageUrl = self.webpageUrl;
        object.userName = self.userName;
        object.path = self.path;
        if ([self checkIsHttps:self.imageUrl] == YES) {
            object.hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        } else {
            object.hdImageData = [NSData dataWithContentsOfFile:self.imageUrl];
        }
        object.withShareTicket = [self.withShareTicket boolValue];
        object.miniProgramType = [self.miniProgramType intValue];
        WXMediaMessage *msg = [WXMediaMessage message];
        msg.title = self.title;
        msg.description = self.desc;
        if ([self checkIsHttps:self.thumbImageUrl]) {
            msg.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbImageUrl]];
        } else {
            msg.thumbData = [NSData dataWithContentsOfFile:self.thumbImageUrl];
        }
        msg.mediaObject = object;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = msg;
        req.scene = [self getWechatScene];
        [WXApi sendReq:req completion:^(BOOL success) {
            [self handlerSuccess:success succeed:succeed failed:failed];
        }];
    } else if ([self.type isEqualToString:@"link"]) {
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = self.webpageUrl;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.title;
        message.description = self.desc;
        if ([self checkIsHttps:self.thumbImageUrl]) {
            message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbImageUrl]];
        } else {
            message.thumbData = [NSData dataWithContentsOfFile:self.thumbImageUrl];
        }
        message.mediaObject = webpageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = [self getWechatScene];
        [WXApi sendReq:req completion:^(BOOL success) {
            [self handlerSuccess:success succeed:succeed failed:failed];
        }];
    } else {
        // 类型不存在
        NSError *error = [NSError errorWithDomain:NSArgumentDomain code:-1 userInfo:nil];
        failed(error);
    }
}

- (int)getWechatScene {
    if ([self.scene isEqualToString:@"session"]) {
        return WXSceneSession;
    } else if ([self.scene isEqualToString:@"timeline"]) {
        return WXSceneTimeline;
    } else if ([self.scene isEqualToString:@"fav"]) {
        return WXSceneFavorite;
    } else {
        return WXSceneSpecifiedSession;
    }
}

@end
