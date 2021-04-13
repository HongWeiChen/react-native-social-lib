//
//  RNSocialShareModel.m
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "RNSocialShareModel.h"
#import "WXApi.h"

@implementation RNSocialShareModel

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.type = params[@"type"];
        self.text = params[@"text"];
        self.title = params[@"title"];
        self.desc = params[@"desc"];
        self.thumbImageUrl = params[@"thumbImageUrl"];
        self.imageUrl = params[@"imageUrl"];
        self.webpageUrl = params[@"webpageUrl"];
        self.userName = params[@"userName"];
        self.path = params[@"path"];
        self.withShareTicket = params[@"withShareTicket"];
        self.miniProgramType = params[@"miniProgramType"];
    }
    return self;
}

- (ShareToWeixinTypes)getShareToWeixinTypes:(NSString *)types {
    NSDictionary *map = @{
        @"text": @(ShareToWeixinTypesText),
        @"image": @(ShareToWeixinTypesPicture),
        @"video": @(ShareToWeixinTypesVideo),
        @"music": @(ShareToWeixinTypesMusic),
        @"web": @(ShareToWeixinTypesWebpage),
        @"mv": @(ShareToWeixinTypesMusicVideo),
        @"mini": @(ShareToWeixinTypesMiniProgram)
    };
    return (ShareToWeixinTypes)[[map objectForKey:types] integerValue];
}

- (void)shareWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed {
    ShareToWeixinTypes types = [self getShareToWeixinTypes:self.type];
    switch (types) {
        case ShareToWeixinTypesText:
        {
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = YES;
            req.text = self.text;
            req.scene = WXSceneSession;
            [WXApi sendReq:req completion:^(BOOL success) {
                [self handlerSuccess:success succeed:succeed failed:failed];
            }];
            break;
        }
        case ShareToWeixinTypesPicture:
        {
            WXImageObject *imageObject = [WXImageObject object];
            NSData *hdImageData = nil;
            if ([self checkIsHttps:self.imageUrl]) {
                hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
            } else {
                hdImageData = [NSData dataWithContentsOfFile:self.imageUrl];
            }
            imageObject.imageData = hdImageData;

            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.title;
            message.description = self.desc;
            NSData *thumbImageData = nil;
            if ([self checkIsHttps:self.thumbImageUrl]) {
                thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbImageUrl]];
            } else {
                thumbImageData = [NSData dataWithContentsOfFile:self.thumbImageUrl];
            }
            message.thumbData = thumbImageData;
            message.mediaObject = imageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req completion:^(BOOL success) {
                [self handlerSuccess:success succeed:succeed failed:failed];
            }];
            break;
        }
        case ShareToWeixinTypesVideo:
        case ShareToWeixinTypesMusic:
        case ShareToWeixinTypesMusicVideo:
            // 暂不实现
            break;
        case ShareToWeixinTypesMiniProgram:
        {
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
                object.hdImageData = [NSData dataWithContentsOfFile:self.thumbImageUrl];
            }
            msg.mediaObject = object;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = msg;
            req.scene = WXSceneSession;
            [WXApi sendReq:req completion:^(BOOL success) {
                [self handlerSuccess:success succeed:succeed failed:failed];
            }];
            break;
        }
        default:
        {
            // 类型不存在
            NSError *error = [NSError errorWithDomain:NSArgumentDomain code:-1 userInfo:nil];
            failed(error);
            break;
        }
    }
}

- (void)handlerSuccess:(BOOL)success
             succeed:(RCTResponseSenderBlock)succeed
              failed:(RCTResponseErrorBlock)failed {
    if (!success) {
        succeed(@[@"success"]);
    } else {
        NSError *error = [NSError errorWithDomain:ShareToWeixinErrorDomain code:-1 userInfo:nil];
        failed(error);
    }
}

- (BOOL)checkIsHttps:(NSString *)string {
    if ([string hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

@end
