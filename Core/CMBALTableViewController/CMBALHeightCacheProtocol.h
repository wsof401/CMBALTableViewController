//
//  CMBALHeightCacheProtocol.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat CMBOriginRegisterNumber = -1;
@protocol CMBALHeightCacheProtocol <NSObject>

@required
@property(nonatomic, assign) CGFloat cachedHeight;
@property(nonatomic, assign) CGFloat mappingTableWidth;

- (void)needReloadHeight;

@end
