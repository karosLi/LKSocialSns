//
//  LKSocialUtil.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSocialSnsUtil : NSObject

+ (NSData *)compressImage:(UIImage *)image
              toImageSize:(CGSize)toImageSize
                 byteSize:(NSInteger)byteSize;

@end
