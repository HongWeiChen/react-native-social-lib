//
//  RNSocialShareModel.m
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "RNSocialShareModel.h"
#import "WXApi.h"
#import "RNSocialShareProtocol.h"
#import "RNSocialShareWechatModel.h"

@implementation RNSocialShareModel

- (instancetype)initWithPlatform:(NSString *)platform shareParams:(NSDictionary *)shareParams {
    self = [super init];
    if (self) {
        self.platform = platform;
        self.shareParams = shareParams;
    }
    return self;
}

- (void)shareWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed {
    id<RNSocialShareProtocol> model = [self getShareModel];
    if (model == nil) {
        return;
    }
    [model shareToWithSucceed:succeed failed:failed];
}

- (id<RNSocialShareProtocol>)getShareModel {
    if ([self.platform isEqualToString:@"qq"]) {
        
    } else if ([self.platform isEqualToString:@"wechat"]) {
        return [[RNSocialShareWechatModel alloc] initWithShareParams:self.shareParams];
    }
    return nil;
}


@end
