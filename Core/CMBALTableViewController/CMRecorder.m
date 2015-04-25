//
//  CMRecorder.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMRecorder.h"
#import "CMBALTableViewCell.h"
@implementation CMRecorder

- (instancetype)init{
    self = [super init];
    if (self) {
        _recoredType = CMRecorderStoreTypeNone;
    }
    return self;
}

- (instancetype)initWithIdentifer:(NSString *)identifer cellClass:(Class)cellClass{
    self = [super init];
    if (self) {
        _identifer = identifer;
        _templateCell = [cellClass new];
        _recoredType = CMRecorderStoreTypeCoding;
    }
    return self;
}

- (instancetype)initWithIdentifer:(NSString *)identifer Xib:(UINib *)cellNib owner:(id)owner options:(NSDictionary *)options{
    self = [super init];
    if (self) {
        _identifer = identifer;
        __block CMBALTableViewCell *cell = nil;
        [[cellNib instantiateWithOwner:owner
                               options:options]
         enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
             if ([obj isKindOfClass:[CMBALTableViewCell class]]) {
                 cell = (CMBALTableViewCell *)obj;
                 stop = YES;
             }
         }];
        NSAssert(cell, @"seems your put an error nib for identifer:%@",identifer);
        _templateCell = cell;
        _recoredType = CMRecorderStoreTypeXib;
    }
    return self;
}

@end
