//
//  LKSocialSnsPlatformWechat.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatformWeibo.h"
#import "LKSocialSnsManager.h"
#import "LKSocialSnsUtil.h"

static NSString *AppKey;
static NSString *RedirectURI;

@interface LKSocialSnsPlatformWeibo () <WXApiDelegate>

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation LKSocialSnsPlatformWeibo

+ (void)registerApp:(NSString *)appkey redictURI:(NSString *)redirectURI {
    AppKey = appkey;
    RedirectURI = redirectURI ? redirectURI : @"https://api.weibo.com/oauth2/default.html";
//    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appkey];
}

#pragma mark - LKSocialSnsPlatformProtocol
- (void)socialLogin:(LKLoginCompeletion)completion {
    
}

- (void)socialShareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageURL]];
    UIImage *shareImage = [UIImage imageWithData:data];
    
    [self shareImage:shareImage title:title description:description targetLink:targetLink completion:completion];
}

- (void)socialShareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion {
    
    if (![LKSocialSnsConfigCenter isWeiboAppInstalled]) {
        self.shareCompletion(@"您的手机未安装微博客户端，请安装后分享");
        return;
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = RedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    NSString *decodedDescription = description.stringByRemovingPercentEncoding;
    NSData *descriptionData = [decodedDescription dataUsingEncoding:NSUnicodeStringEncoding];
    NSData *linkData = [targetLink dataUsingEncoding:NSUnicodeStringEncoding];

    if (descriptionData.length + linkData.length > 280) {
        NSInteger toIndex = MAX((280 - linkData.length) / 2, 0);
        if (toIndex < description.length) {
            decodedDescription = [decodedDescription substringToIndex:toIndex];
            decodedDescription = [decodedDescription stringByReplacingCharactersInRange:NSMakeRange(description.length - 3, 3) withString:@"..."];
        }
    }
    message.text = [NSString stringWithFormat:@"%@%@", decodedDescription, targetLink];
    NSData *imageData = UIImagePNGRepresentation(shareImage);
    
    if (targetLink) {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = targetLink;
        webpage.title = title.stringByRemovingPercentEncoding;
        webpage.description = decodedDescription;
        webpage.thumbnailData = imageData;
        webpage.webpageUrl = targetLink;
        message.mediaObject = webpage;
    } else {
        WBImageObject *image = [WBImageObject object];
        image.imageData = imageData;
        message.imageObject = image;
    }

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}

- (void)socialOnReceiveResponse:(id)resp {
    if ([resp isKindOfClass:[LKSocialSnsAuthResp class]]) {
        [self handleAuthResponse:resp];
    } else if ([resp isKindOfClass:[LKSocialSnsSendMessageResp class]]) {
        [self handleSendMessageResponse:resp];
    }
}

#pragma mark - hadle response
//WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
//WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
//WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//WeiboSDKResponseStatusCodeUnknown               = -100,

- (void)handleSendMessageResponse:(LKSocialSnsSendMessageResp *)msgResp {
    NSString *errMsg = [self getErrorMessage:msgResp];
    
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
    }
}

- (void)handleAuthResponse:(LKSocialSnsAuthResp *)authResp {
    NSString *errMsg = [self getErrorMessage:authResp];
    
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
        return;
    }
    
    self.accessToken = authResp.accessToken;
}

- (NSString *)getErrorMessage:(LKSocialSnsBaseResp *)resp {
    NSString *errMsg = resp.errStr;
    switch (resp.errCode) {
        case WeiboSDKResponseStatusCodeSuccess:
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
            errMsg = @"用户取消了操作";
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            errMsg = @"发送失败";
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
            errMsg = @"授权失败";
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            errMsg = @"用户取消安装微博客户端";
            break;
        case WeiboSDKResponseStatusCodePayFail:
            errMsg = @"支付失败";
            break;
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
            errMsg = @"分享失败";
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
            errMsg = @"不支持的请求";
            break;
        case WeiboSDKResponseStatusCodeUnknown:
            errMsg = @"未知错误";
            break;
            
        default:
            break;
    }
    
    return errMsg;
}

@end
