//
//  SocialManager.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsManager.h"
#import "LKSocialSnsConstant.h"
#import "LKSocialSnsHelper.h"
#import "LKSocialSnsPlatformWechat.h"
#import "LKSocialSnsPlatformQQ.h"
#import "LKSocialSnsPlatformWeibo.h"
#import "LKShareMenuView.h"

static NSMutableDictionary *snsPlatformDic;

@interface LKSocialSnsManager () <WXApiDelegate, WeiboSDKDelegate, QQApiInterfaceDelegate>

@end

@implementation LKSocialSnsManager

+ (void)initialize {
    snsPlatformDic = [NSMutableDictionary dictionary];
}

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return  instance;
}

+ (void)showSnsMenu:(NSArray<NSString *> *)flatforms clickHandle:(LKShareMenuChooseItemBlock)clickHandle {
    [LKShareMenuView show:flatforms block:clickHandle];
}

+ (LKSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)platformName {
    if ([snsPlatformDic.allKeys containsObject:platformName]) {
        return snsPlatformDic[platformName];
    } else {
        LKSocialSnsPlatform *snsPlatform;
        if ([platformName isEqualToString:LKShareToWechatSession] || [platformName isEqualToString:LKShareToWechatTimeline]) {
            snsPlatform = [[LKSocialSnsPlatformWechat alloc] init];
        } else if ([platformName isEqualToString:LKShareToQQ] || [platformName isEqualToString:LKShareToQzone]) {
            snsPlatform = [[LKSocialSnsPlatformQQ alloc] init];
        } else if ([platformName isEqualToString:LKShareToWeibo]) {
            snsPlatform = [[LKSocialSnsPlatformWeibo alloc] init];
        }
        
        snsPlatform.socialType = platformName;
        snsPlatformDic[platformName] = snsPlatform;
        return snsPlatform;
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    BOOL flag = [TencentOAuth HandleOpenURL:url];
    flag = !flag ? [QQApiInterface handleOpenURL:url delegate:[LKSocialSnsManager shared]] : YES;
    flag = !flag ? [WeiboSDK handleOpenURL:url delegate:[LKSocialSnsManager shared]] : YES;
    flag = !flag ? [WXApi handleOpenURL:url delegate:[LKSocialSnsManager shared]] : YES;
    
    return  flag;
}

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void)onReq:(id)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
- (void)onResp:(id)resp {
    // Wechat
    if ([resp isKindOfClass:[BaseResp class]]) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            LKSocialSnsAuthResp *response = [LKSocialSnsHelper authRespFromWX:(SendAuthResp *)resp];
            
            LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:response];
            }
        } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            LKSocialSnsSendMessageResp *response = [LKSocialSnsHelper sendMsgRespFromWX:(SendMessageToWXResp *)resp];
            
            LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:response];
            }
        }

    }
    // QQ
    else if ([resp isKindOfClass:[QQBaseResp class]]) {
        if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
            LKSocialSnsSendMessageResp *response = [LKSocialSnsHelper sendMsgRespFromQQ:(SendMessageToQQResp *)resp];
            
            LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:response];
            }
        }
    }
}

#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param resp 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)resp {
    if ([resp isKindOfClass:[WBAuthorizeResponse class]]) {
        LKSocialSnsAuthResp *response = [LKSocialSnsHelper authRespFromWeibo:(WBAuthorizeResponse *)resp];
        
        LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
        if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
            [snsPlatform onReceiveResponse:response];
        }
    } else if ([resp isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        LKSocialSnsSendMessageResp *response = [LKSocialSnsHelper sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp];
        
        LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
        if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
            [snsPlatform onReceiveResponse:response];
        }
    }
}

#pragma mark - TencentSessionDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    LKSocialSnsAuthResp *resp = [[LKSocialSnsAuthResp alloc] init];
    resp.errCode = LKSocialSnsQQLoginSuccess;
    
    LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:resp];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    LKSocialSnsAuthResp *resp = [[LKSocialSnsAuthResp alloc] init];
    resp.errCode = cancelled ? LKSocialSnsQQLoginCancel : LKSocialSnsQQLoginFail;
    
    LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:resp];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    LKSocialSnsAuthResp *resp = [[LKSocialSnsAuthResp alloc] init];
    resp.errCode = LKSocialSnsQQLoginFail;
    
    LKSocialSnsPlatform *snsPlatform = [LKSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:resp];
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {

}

@end
