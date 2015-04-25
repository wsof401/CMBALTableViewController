//
//  CMALTableViewCellProtocol.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBALHeightCacheProtocol.h"

@protocol CMALTableViewCellProtocol <NSObject>

@property(nonatomic, weak) id<CMBALHeightCacheProtocol> model;

- (void)loadWithModel:(id<CMBALHeightCacheProtocol>)dataModel;

@end
