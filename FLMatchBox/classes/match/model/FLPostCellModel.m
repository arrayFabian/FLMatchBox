//
//  FLPostCellModel.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/25.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLPostCellModel.h"

#import "NSDate+MJ.h"

@implementation FLPostCellModel


+ (NSDictionary *)objectClassInArray{
    return @{@"photoList" : [Photolist class]};
}


- (NSString *)createDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
   // fmt.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";  这是微博的
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *created_at = [fmt dateFromString:_createDate];
    
    
    if ([created_at isThisYear]) {//今年
        
        if ([created_at isToday]) {//今天
            
            //计算跟当前时间的差距
            NSDateComponents *cmp = [created_at deltaWithNow];
            //   NSLog(@"%ld--%ld--%ld",cmp.hour,cmp.minute,cmp.second);
            
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:@"%ld分钟前",cmp.minute];
            }else{
                return @"刚刚";
            }
            
            
        }else if ([created_at isYesterday]){//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:created_at];
            
            
        }else{//前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:created_at];
            
        }
        
    }else{//不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:created_at];
    }
    
    
    return _createDate;

}


@end


@implementation Photolist

@end


