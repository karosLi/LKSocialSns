//
//  LKSocialSnsPlatformWechat.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatformWechat.h"
#import "LKSocialSnsManager.h"
#import "LKSocialSnsUtil.h"

NSString * const kWechatScopeUserBase = @"snsapi_userinfo,snsapi_base";

static NSString *AppID;
static NSString *AppSecret;

@interface LKSocialSnsPlatformWechat ()

@end

@implementation LKSocialSnsPlatformWechat

+ (void)registerApp:(NSString *)appid secret:(NSString *)appsecret {
    //向微信注册
    AppID = appid;
    AppSecret = appsecret;
    [WXApi registerApp:appid];
}

#pragma mark - LKSocialSnsPlatformProtocol
- (void)socialLogin:(LKLoginCompeletion)completion {
    SendAuthReq *request = [[SendAuthReq alloc] init];
    request.scope = kWechatScopeUserBase;
    request.state = @"LK";
    
    [WXApi sendAuthReq:request viewController:nil delegate:nil];
}

- (void)socialShareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageURL]];
    UIImage *shareImage = [UIImage imageWithData:data];
    
    [self shareImage:shareImage title:title description:description targetLink:targetLink completion:completion];
}

- (void)socialShareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion {
    
    if (![LKSocialSnsConfigCenter isWXAppInstalled]) {
        self.shareCompletion(@"您的手机未安装微信客户端，请安装后分享");
        return;
    }
    
    NSObject *mediaObject;
    NSData *imageData = [LKSocialSnsUtil compressImage:shareImage toImageSize:CGSizeMake(300, 300) byteSize:32];
    
    if (targetLink) {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = targetLink;
        mediaObject = ext;
    } else {
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = imageData;
        mediaObject = ext;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title.stringByRemovingPercentEncoding;
    message.description = description.stringByRemovingPercentEncoding;
    message.mediaObject = mediaObject;
    message.messageExt = description.stringByRemovingPercentEncoding;
    message.messageAction = nil;
    message.mediaTagName = nil;
    [message setThumbImage:[UIImage imageWithData:imageData]];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = [self.socialType isEqualToString:LKShareToWechatSession] ? WXSceneSession : WXSceneTimeline;
    req.message = message;
    
    [WXApi sendReq:req];
}

- (void)socialOnReceiveResponse:(id)resp {
    if ([resp isKindOfClass:[LKSocialSnsAuthResp class]]) {
        [self handleAuthResponse:resp];
    } else if ([resp isKindOfClass:[LKSocialSnsSendMessageResp class]]) {
        [self handleSendMessageResponse:resp];
    }
}

#pragma mark - hadle response
- (void)handleAuthResponse:(LKSocialSnsAuthResp *)authResp {
    NSString *errMsg = [self getErrorMessage:authResp];
    
    if (errMsg) {
        if (self.loginCompletion) {
            self.loginCompletion(nil, errMsg);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self getAccessTokenWithCode:authResp.code completion:^(NSDictionary *dict) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        __block NSString *errorMsg = dict[@"errmsg"];
        if (errorMsg) {
            if (strongSelf.loginCompletion) {
                strongSelf.loginCompletion(nil, errorMsg);
            }
        } else {
            NSString *access_token = dict[@"access_token"];
            NSString *openid = dict[@"openid"];
            
            [strongSelf getUserInfoWithToken:access_token openid:openid completion:^(NSDictionary *dict) {
                errorMsg = dict[@"errmsg"];
                if (errorMsg) {
                    if (strongSelf.loginCompletion) {
                        strongSelf.loginCompletion(nil, errorMsg);
                    }
                } else {
                    LKSocialSnsAccountInfo *info = [[LKSocialSnsAccountInfo alloc] init];
                    info.usid = openid;
                    info.accessToken = access_token;
                    info.userName = dict[@"nickname"];
                    info.unionId = dict[@"unionid"];
                    info.gender = dict[@"sex"];
                    info.iconURL = dict[@"headimgurl"];
                    
                    /**
                     city = Wuhan;
                     country = CN;
                     headimgurl = "http://wx.qlogo.cn/mmopen/vPjficwtgTJA6ZCRzz25an9rTIjGIPDCQv9eWVC01KY57kp7eLriczgQgiccbuzq2aaJw7059Nv1EHapH4fXLfn3A/0";
                     language = "zh_CN";
                     nickname = "Karos_\U51ef";
                     openid = "o0hJVw-CJhsvjP3LvnIDy8X2p5AM";
                     privilege =     (
                     );
                     province = Hubei;
                     sex = 1;
                     unionid = "oOMqswsgBN_R-rjRyTKHtFtqGuQc";
                     **/
                    
                    if (strongSelf.loginCompletion) {
                        strongSelf.loginCompletion(info, nil);
                    }
                }
            }];
        }
    }];
}

- (void)handleSendMessageResponse:(LKSocialSnsSendMessageResp *)msgResp {
    NSString *errMsg = [self getErrorMessage:msgResp];
    
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
    }
}


//WXSuccess           = 0,    /**< 成功    */
//WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//WXErrCodeSentFail   = -3,   /**< 发送失败    */
//WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//WXErrCodeUnsupport  = -5,   /**< 微信不支持    */

- (NSString *)getErrorMessage:(LKSocialSnsBaseResp *)msgResp {
    NSString *errMsg = msgResp.errStr;
    switch (msgResp.errCode) {
        case WXSuccess:
            break;
        case WXErrCodeCommon:
            break;
        case WXErrCodeUserCancel:
            errMsg = @"用户取消了操作";
            break;
        case WXErrCodeSentFail:
            break;
        case WXErrCodeAuthDeny:
            break;
        case WXErrCodeUnsupport:
            break;
            
        default:
            break;
    }
    
    return errMsg;
}

/**
 *  通过code来获取用户的access_token
 */
- (void)getAccessTokenWithCode:(NSString *)code completion:(void(^)(NSDictionary *dict))completion {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", AppID, AppSecret, code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (completion) {
                    completion(dict);
                }
            }
        });
    });
}

/**
 *  通过token来获取用户的个人信息
 */
- (void)getUserInfoWithToken:(NSString *)token openid:(NSString *)openid completion:(void(^)(NSDictionary *dict))completion {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (completion) {
                    completion(dict);
                }
            }
        });
    });
}

@end
