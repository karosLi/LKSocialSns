//
//  LKSocialUtil.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsUtil.h"

@implementation LKSocialSnsUtil

+ (NSData *)compressImage:(UIImage *)image
              toImageSize:(CGSize)toImageSize
                 byteSize:(NSInteger)byteSize {
    
    CGSize imageSize = image.size;
    CGSize newSize = toImageSize;
    float  ratio =
        MIN(newSize.width / imageSize.width, newSize.height / imageSize.height);
    newSize.width = imageSize.width * ratio;
    newSize.height = imageSize.height * ratio;

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imagedata = UIImageJPEGRepresentation(small, 0.5);

    if (imagedata.length > byteSize * 1024) {
        imageSize.height = toImageSize.height / 3 * 2;
        imageSize.width = toImageSize.width / 3 * 2;
        imagedata =
            [self compressImage:image toImageSize:imageSize byteSize:byteSize];
    }

    return imagedata;
}

@end
