//
//  UIImage+FLImage.m
//  MyWeibo
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "UIImage+FLImage.h"

@implementation UIImage (FLImage)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imagewithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
