//
//  RNSocialShareBaseModel.h
//  RNSocialManager
//
//  Created by Hongwei Chen on 2021/4/13.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNSocialShareProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNSocialShareBaseModel : NSObject<RNSocialShareProtocol>

- (instancetype)initWithShareParams:(NSDictionary *)shareParams;

- (void)handlerSuccess:(BOOL)success
               succeed:(RCTResponseSenderBlock)succeed
                failed:(RCTResponseErrorBlock)failed;

- (BOOL)checkIsHttps:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
