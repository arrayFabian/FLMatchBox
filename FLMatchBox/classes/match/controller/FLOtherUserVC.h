//
//  FLOtherUserVC.h
//  FLMatchBox
//
//  Created by Mac on 16/4/4.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLPostCellModel,FLAddressCellModel;
@interface FLOtherUserVC : UITableViewController


@property (nonatomic, strong) FLPostCellModel *cellModel;

@property (nonatomic, strong) FLAddressCellModel *addressModel;

@property (nonatomic, assign) NSInteger otherUserId;
@property (nonatomic, assign) NSString *otherUserName;

@end