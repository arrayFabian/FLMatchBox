//
//  FLAddressView.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLAddressCellModel,FLAddressView;

@protocol FLAddressViewDelegate <NSObject>


- (void)addressView:(FLAddressView *)addressCell btnChatDidClick:(FLAddressCellModel *)model;

- (void)addressView:(FLAddressView *)addressCell btnHomeDidClick:(FLAddressCellModel *)model;

@end




@interface FLAddressView : UIView


@property (nonatomic, weak) id<FLAddressViewDelegate> delegate;

@property (nonatomic, strong) FLAddressCellModel *model;

@end
