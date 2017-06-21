//
//  LKSocialSnsPlatformWechat.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatformQQ.h"
#import "LKSocialSnsConstant.h"
#import "LKSocialSnsUtil.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "LKSocialSnsManager.h"

static NSString *kAccessToken = @"QQAccessToken";
static NSString *kOpenId = @"QQOpenId";
static NSString *kExpireDate = @"QQExpireDate";

static NSString *AppId;
static TencentOAuth *TencentAuth;

@interface LKSocialSnsPlatformQQ ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, copy) void(^ShareBlock)(void) ;

@end

@implementation LKSocialSnsPlatformQQ

+ (void)registerApp:(NSString *)appid {
    AppId = appid;
    TencentAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:(id)[LKSocialSnsManager shared]];
}

#pragma mark - LKSocialSnsPlatformProtocol
- (void)socialLogin:(LKLoginCompeletion)completion {
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];

    [self restoreToken];
    if (self.accessToken && self.openId && self.expirationDate) {
        [TencentAuth setAccessToken:self.accessToken];
        [TencentAuth setOpenId:self.openId];
        [TencentAuth setExpirationDate:self.expirationDate];
        self.ShareBlock();
    } else {
        [TencentAuth authorize:permissions inSafari:NO];
    }
}

- (void)socialShareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageURL]];
    UIImage *shareImage = [UIImage imageWithData:data];
    
    [self shareImage:shareImage title:title description:description targetLink:targetLink completion:completion];
}

- (void)socialShareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion {
    
    if (![LKSocialSnsConfigCenter isQQInstalled]) {
        self.shareCompletion(@"您的手机未安装QQ，请安装后分享");
        return;
    }
    
    NSData *imageData = UIImagePNGRepresentation(shareImage);
    
    SendMessageToQQReq *req;
    if (targetLink) {
        QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetLink] title:title.stringByRemovingPercentEncoding description:description.stringByRemovingPercentEncoding previewImageData:imageData];
        req = [SendMessageToQQReq reqWithContent:img];
    } else {
        QQApiImageObject *img = [QQApiImageObject objectWithData:imageData previewImageData:imageData title:title.stringByRemovingPercentEncoding description:description.stringByRemovingPercentEncoding];
        req = [SendMessageToQQReq reqWithContent:img];
    }
    
    QQApiSendResultCode sent;
    if ([self.socialType isEqualToString:LKShareToQQ]) {
        sent = [QQApiInterface sendReq:req];
    } else {
        sent = [QQApiInterface SendReqToQZone:req];
    }
}

- (void)socialOnReceiveResponse:(id)resp {
    if ([resp isKindOfClass:[LKSocialSnsAuthResp class]]) {
        [self handleAuthResp:resp];
    } else if ([resp isKindOfClass:[LKSocialSnsSendMessageResp class]]) {
        [self handleSendMessageResp:resp];
    }
}

#pragma mark - hadle response
- (void)handleAuthResp:(LKSocialSnsAuthResp *)authResp {
    NSString *errMsg = [self getErrorMessage:authResp.errCode];
    if (errMsg) {
        if (self.shareCompletion) {
            self.shareCompletion(errMsg);
        }
    } else {
        [self saveToken];
    }
}

- (void)handleSendMessageResp:(LKSocialSnsSendMessageResp *)msgResp {
    NSString *errMsg = [self getErrorMessage:msgResp.errCode];
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
    }
}


/**
 <TR><TD>error</TD><TD>errorDescription</TD><TD>注释</TD></TR>
 <TR><TD>0</TD><TD>nil</TD><TD>成功</TD></TR>
 <TR><TD>-1</TD><TD>param error</TD><TD>参数错误</TD></TR>
 <TR><TD>-2</TD><TD>group code is invalid</TD><TD>该群不在自己的群列表里面</TD></TR>
 <TR><TD>-3</TD><TD>upload photo failed</TD><TD>上传图片失败</TD></TR>
 <TR><TD>-4</TD><TD>user give up the current operation</TD><TD>用户放弃当前操作</TD></TR>
 <TR><TD>-5</TD><TD>client internal error</TD><TD>客户端内部处理错误</TD></TR>

 @param errCode errCode
 @return errMsg
 */
- (NSString *)getErrorMessage:(NSInteger)errCode {
    NSString *errMsg = nil;
    switch (errCode) {
        case LKSocialSnsQQLoginSuccess:
            break;
        case LKSocialSnsQQLoginCancel:
            errMsg = @"用户取消了登录";
            break;
        case LKSocialSnsQQLoginFail:
            errMsg = @"登录失败";
            break;
        case 0:
            break;
        case -1:
            errMsg = @"参数错误";
            break;
        case -2:
            errMsg = @"该群不在自己的群列表里面";
            break;
        case -3:
            errMsg = @"上传图片失败";
            break;
        case -4:
            errMsg = @"用户取消了操作";
            break;
        case -5:
            errMsg = @"客户端内部处理错误";
            break;
        default:
            break;
    }
    
    return errMsg;
}

#pragma mark - save / restore token
- (void)saveToken {
    self.accessToken = [TencentAuth accessToken];
    self.openId = [TencentAuth openId];
    self.expirationDate = [TencentAuth expirationDate];
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:self.openId forKey:kOpenId];
    [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:kExpireDate];
}

- (void)restoreToken {
    self.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken];
    self.openId = [[NSUserDefaults standardUserDefaults] valueForKey:kOpenId];
    self.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:kExpireDate];
}

@end
