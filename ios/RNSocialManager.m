
#import "RNSocialManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>

typedef NS_ENUM(NSInteger, ShareToWeixinTypes) {
    ShareToWeixinTypesText,
    ShareToWeixinTypesImage,
    ShareToWeixinTypesVideo,
    ShareToWeixinTypesMusic,
    ShareToWeixinTypesWebpage,
    ShareToWeixinTypesMusicVideo,
    ShareToWeixinTypesMiniProgram
};

NSErrorDomain ShareToWeixinErrorDomain = @"ShareToWeixinErrorDomain";

static ShareToWeixinTypes getShareToWeixinTypes(NSString *string) {
    NSDictionary *map = @{
        @"text": @(ShareToWeixinTypesText),
        @"image": @(ShareToWeixinTypesImage),
        @"video": @(ShareToWeixinTypesVideo),
        @"music": @(ShareToWeixinTypesMusic),
        @"webpage": @(ShareToWeixinTypesWebpage),
        @"musicvideo": @(ShareToWeixinTypesMusicVideo),
        @"miniprogram": @(ShareToWeixinTypesMiniProgram)
    };
    return (ShareToWeixinTypes)[[map objectForKey:string] integerValue];
}

@implementation RNSocialManager

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (void)dispatch_main_block:(void (^)(void))block {
    dispatch_async([self methodQueue], block);
}

/// Application中调用
+ (void)registerWeixin:(NSString *)appId universalLink:(NSString *)universalLink {
    [WXApi registerApp:appId universalLink:universalLink];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(registerWeixin:(NSString *)appId universalLink:(NSString *)universalLink) {
    // js中调用（一般用不上）
    [self dispatch_main_block:^{
        // 注册微信
        [WXApi registerApp:appId universalLink:universalLink];
    }];
}

RCT_EXPORT_METHOD(isWXAppInstalled:(RCTPromiseResolveBlock)succeed) {
    [self dispatch_main_block:^{
        // 是否安装微信
        BOOL result = [WXApi isWXAppInstalled];
        succeed(@(result));
    }];
}

RCT_EXPORT_METHOD(isQQInstalled:(RCTPromiseResolveBlock)succeed) {
    [self dispatch_main_block:^{
        // 是否安装QQ
        BOOL result = [TencentOAuth iphoneQQInstalled];
        succeed(@(result));
    }];
}


RCT_EXPORT_METHOD(shareToWeixin:(NSDictionary *)params
                  succeed:(RCTPromiseResolveBlock)succeed
                  failed:(RCTResponseErrorBlock)failed) {
    [self dispatch_main_block:^{
        NSString *shareType = params[@"shareType"];
        
        WXMediaMessage *msg = [WXMediaMessage message];
        msg.title = params[@"title"];
        msg.description = params[@"description"];

        ShareToWeixinTypes types = getShareToWeixinTypes(shareType);
        switch (types) {
            case ShareToWeixinTypesText:
            {
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = YES;
                req.text = params[@"text"];
                req.scene = WXSceneSession;
                [WXApi sendReq:req completion:^(BOOL success) {
                    [self handlerSuccess:success succeed:succeed failed:failed];
                }];
                break;
            }
            case ShareToWeixinTypesImage:
            {
                WXImageObject *imageObject = [WXImageObject object];
                NSString *hdImageUrl = params[@"hdImageUrl"];
                NSData *hdImageData = nil;
                if ([self checkIsHttps:hdImageUrl]) {
                    hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:hdImageUrl]];
                } else {
                    hdImageData = [NSData dataWithContentsOfFile:hdImageUrl];
                }
                imageObject.imageData = hdImageData;

                WXMediaMessage *message = [WXMediaMessage message];
                NSString *title = params[@"title"];
                if ([title isKindOfClass:[NSString class]]) {
                    message.title = title;
                }
                NSString *desc = params[@"desc"];
                if ([desc isKindOfClass:[NSString class]]) {
                    message.description = desc;
                }
                NSString *thumbImageUrl = params[@"thumbImageUrl"];
                NSData *thumbImageData = nil;
                if ([self checkIsHttps:thumbImageUrl]) {
                    thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageUrl]];
                } else {
                    thumbImageData = [NSData dataWithContentsOfFile:thumbImageUrl];
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
                object.webpageUrl = params[@"webpageUrl"];
                object.userName = params[@"userName"];
                object.path = params[@"path"];
                NSString *hdImageData = params[@"hdImageData"];
                if ([self checkIsHttps:hdImageData] == YES) {
                    object.hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:hdImageData]];
                } else {
                    object.hdImageData = [NSData dataWithContentsOfFile:hdImageData];
                }
                object.withShareTicket = [params[@"withShareTicket"] boolValue];
                object.miniProgramType = [params[@"miniProgramType"] intValue];
                WXMediaMessage *msg = [WXMediaMessage message];
                msg.title = params[@"title"];
                msg.description = params[@"description"];
                NSString *thumbData = params[@"thumbData"];
                if ([self checkIsHttps:thumbData]) {
                    msg.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbData]];
                } else {
                    object.hdImageData = [NSData dataWithContentsOfFile:thumbData];
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
    }];
}

- (void)handlerSuccess:(BOOL)success
             succeed:(RCTPromiseResolveBlock)succeed
              failed:(RCTResponseErrorBlock)failed {
    if (!success) {
        succeed(@"success");
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
  
