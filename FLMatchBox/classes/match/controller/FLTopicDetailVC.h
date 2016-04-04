//
//  FLTopicDetailVC.h
//  FLMatchBox
//
//  Created by Mac on 16/4/2.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLPostCellModel,FLTopicModel;
@interface FLTopicDetailVC : UIViewController

@property (nonatomic, strong) FLPostCellModel *cellModel;


@property (nonatomic, strong) FLTopicModel *topicModel;

@end
