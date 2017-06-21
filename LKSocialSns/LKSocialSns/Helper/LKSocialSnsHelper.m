//
//  LKSocialSnsHelper.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsHelper.h"

@implementation LKSocialSnsHelper

+ (LKSocialSnsAuthResp *)authRespFromWX:(SendAuthResp *)resp {
    LKSocialSnsAuthResp *response = [[LKSocialSnsAuthResp alloc] init];
    response.errCode = resp.errCode;
    response.errStr = resp.errStr;
    response.type = resp.type;
    response.code = resp.code;
    response.state = resp.state;
    
    return response;
}

+ (LKSocialSnsSendMessageResp *)sendMsgRespFromWX:(SendMessageToWXResp *)resp {
    LKSocialSnsSendMessageResp *response = [[LKSocialSnsSendMessageResp alloc] init];
    response.errCode = resp.errCode;
    response.errStr = resp.errStr;
    response.type = resp.type;
    
    return response;
}

+ (LKSocialSnsAuthResp *)authRespFromWeibo:(WBAuthorizeResponse *)resp {
    LKSocialSnsAuthResp *response = [[LKSocialSnsAuthResp alloc] init];
    response.errCode = resp.statusCode;
    response.requestUserInfo = resp.requestUserInfo;
    response.userInfo = resp.userInfo;
    response.accessToken = resp.accessToken;
    response.userID = resp.userID;
    response.refreshToken = resp.refreshToken;
    response.expirationDate = resp.expirationDate;
    
    return response;
}

+ (LKSocialSnsSendMessageResp *)sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp {
    LKSocialSnsSendMessageResp *response = [[LKSocialSnsSendMessageResp alloc] init];
    response.errCode = resp.statusCode;
    response.requestUserInfo = resp.requestUserInfo;
    response.userInfo = resp.userInfo;
    response.accessToken = resp.authResponse.accessToken;
    response.userID = resp.authResponse.userID;
    response.refreshToken = resp.authResponse.refreshToken;
    response.expirationDate = resp.authResponse.expirationDate;
    
    return response;
}

+ (LKSocialSnsSendMessageResp *)sendMsgRespFromQQ:(SendMessageToQQResp *)resp {
    LKSocialSnsSendMessageResp *response = [[LKSocialSnsSendMessageResp alloc] init];
    response.errCode = [resp.result integerValue];
    response.errStr = resp.errorDescription;
    
    return response;
}

@end
