//
//  CMALModel.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBALModel.h"

const CGFloat CMBOriginRegisterNumber = -1.0f;

@implementation CMBALModel
@synthesize cachedHeight,mappingTableWidth;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self needReloadHeight];
    }
    return self;
}

- (void)needReloadHeight{
    self.cachedHeight = CMBOriginRegisterNumber;
    self.mappingTableWidth = CMBOriginRegisterNumber;
}

@end
