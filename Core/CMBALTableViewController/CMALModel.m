//
//  CMALModel.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMALModel.h"

static const CGFloat kCMBDefaultHeight = -1.0f;

@implementation CMALModel
@synthesize cachedHeight,mappingTableWidth;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self needReloadHeight];
    }
    return self;
}

- (void)needReloadHeight{
    self.cachedHeight = kCMBDefaultHeight;
    self.mappingTableWidth = kCMBDefaultHeight;
}

@end
