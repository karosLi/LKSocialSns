//
//  SocialManager.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKSocialSnsConstant.h"
#import "LKSocialSnsConfigCenter.h"

@class LKSocialSnsPlatform;

@interface LKSocialSnsManager : NSObject

@property (nonatomic, strong) NSString *currentSharePlatform;

+ (instancetype)shared;
+ (void)showSnsMenu:(NSArray<NSString *> *)flatforms clickHandle:(LKShareMenuChooseItemBlock)clickHandle;
+ (LKSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)platformName;
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
