//
//  FLEditSexChooseVC.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/29.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLEditSexChooseVCDelegate <NSObject>

@required
- (void)passValue:(NSString *)sexChoose;

@end

@interface FLEditSexChooseVC : UITableViewController

@property (copy, nonatomic) NSString *sexChoose;

@property (nonatomic, weak) id<FLEditSexChooseVCDelegate> delegate;

@end
