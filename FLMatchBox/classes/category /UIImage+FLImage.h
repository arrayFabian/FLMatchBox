//
//  UIImage+FLImage.h
//  MyWeibo
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FLImage)
/**
 *  加载原始的图片没有渲染
 *
 *  @param imageName iamgeName
 *
 *  @return originalImage
 */

+(instancetype)imageWithOriginalName:(NSString *)imageName;

/**
 *  拉伸图片
 *
 */
+ (instancetype)imagewithStretchableName:(NSString *)imageName;

@end
