
#import "RNSocialManager.h"

#import "RNSocialShareModel.h"

#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>

@implementation RNSocialManager

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)dispatch_main_block:(void (^)(void))block {
    dispatch_async([self methodQueue], block);
}

/**
 工厂方法
 
 注册WXApi
 */
+ (void)registerWeixin:(NSString *)appId universalLink:(NSString *)universalLink {
    [WXApi registerApp:appId universalLink:universalLink];
}

RCT_EXPORT_MODULE()

/**
 注册WXApi
 
 在js中调用注册WXApi
 */
RCT_EXPORT_METHOD(registerWeixin:(NSString *)appId universalLink:(NSString *)universalLink) {
    // js中调用（一般用不上）
    [self dispatch_main_block:^{
        // 注册微信
        [WXApi registerApp:appId universalLink:universalLink];
    }];
}

/**
 是否安装微信
 
 return => YES / NO
 */
RCT_EXPORT_METHOD(isWXAppInstalled:(RCTPromiseResolveBlock)succeed) {
    [self dispatch_main_block:^{
        BOOL result = [WXApi isWXAppInstalled];
        succeed(@(result));
    }];
}


/**
 是否安装QQ
 
 return => YES / NO
 */
RCT_EXPORT_METHOD(isQQInstalled:(RCTPromiseResolveBlock)succeed) {
    [self dispatch_main_block:^{
        BOOL result = [TencentOAuth iphoneQQInstalled];
        succeed(@(result));
    }];
}


/**
 分享到微信
 
 分享数据 => 参考RNSocialShareModel
 */
RCT_EXPORT_METHOD(shareToWeixin:(NSDictionary *)params
                  succeed:(RCTResponseSenderBlock)succeed
                  failed:(RCTResponseErrorBlock)failed) {
    [self dispatch_main_block:^{
        NSString *platform = params[@"platform"];
        NSString *shareParams = params[@"shareParams"];
        RNSocialShareModel *shareModel = [[RNSocialShareModel alloc] initWithPlatform:platform shareParams:shareParams];
        [shareModel shareWithSucceed:succeed failed:failed];
    }];
}

@end
  
