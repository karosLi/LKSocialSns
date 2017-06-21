//
//  JYZBaseResp.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKSocialSnsBaseResp : NSObject

/**
 对应的 request 中的自定义信息字典
 
 如果当前 response 是由微博客户端响应给第三方应用的，则 requestUserInfo 中会包含原 request.userInfo 中的所有数据
 
 @see WBBaseRequest.userInfo
 */
@property (strong, nonatomic) NSDictionary *requestUserInfo;

/**
 自定义信息字典，用于数据传输过程中存储相关的上下文环境数据
 
 第三方应用给微博客户端程序发送 request 时，可以在 userInfo 中存储请求相关的信息。
 
 @warning userInfo中的数据必须是实现了 `NSCoding` 协议的对象，必须保证能序列化和反序列化
 @warning 序列化后的数据不能大于10M
 */
@property (nonatomic, strong) NSDictionary *userInfo;

/** 错误码 */
@property (nonatomic, assign) NSInteger errCode;
/** 错误提示字符串 */
@property (nonatomic, retain) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) NSInteger type;

@end
