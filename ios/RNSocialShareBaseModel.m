//
//  RNSocialShareBaseModel.m
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "RNSocialShareBaseModel.h"

@implementation RNSocialShareBaseModel

- (instancetype)initWithShareParams:(NSDictionary *)shareParams {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)shareToWithSucceed:(RCTResponseSenderBlock)succeed failed:(RCTResponseErrorBlock)failed {
    // TODO: working in subclass
}

- (void)handlerSuccess:(BOOL)success
             succeed:(RCTResponseSenderBlock)succeed
              failed:(RCTResponseErrorBlock)failed {
    if (!success) {
        succeed(@[@"success"]);
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
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
