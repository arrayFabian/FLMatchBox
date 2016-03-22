//
//  KSegement.h
//  Matchbox
//
//  Created by 刘卓明 on 16/2/12.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SegmentBlcok)(NSInteger index);

@interface KSegement : UIView
@property (strong, nonatomic) NSArray *titlesArr;
@property (copy, nonatomic) SegmentBlcok callback;
@property (assign, nonatomic) NSInteger selectIndex;

- (void)setTitlesArr:(NSArray *)titlesArr andCallback:(SegmentBlcok)callback;


@end
