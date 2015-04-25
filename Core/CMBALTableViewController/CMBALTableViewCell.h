//
//  CMBALTableViewCell.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMALTableViewCellProtocol.h"

@interface CMBALTableViewCell : UITableViewCell<CMALTableViewCellProtocol>

- (void)initializationForCode;

- (void)initializationForXib;

- (void)commonConfigWithModel:(id<CMBALHeightCacheProtocol>)dataModel;

- (void)templateLoadWithModel:(id<CMBALHeightCacheProtocol>)dataModel;

@end
