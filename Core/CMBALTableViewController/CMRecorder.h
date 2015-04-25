//
//  CMRecorder.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMBALTableViewCell;
typedef NS_ENUM(NSUInteger, CMRecorderStoreType) {
    CMRecorderStoreTypeNone,
    CMRecorderStoreTypeCoding,
    CMRecorderStoreTypeXib,
    CMRecorderStoreTypeStoryboard
};


@interface CMRecorder : NSObject

@property(nonatomic, copy) NSString *identifer;
@property(nonatomic, strong) CMBALTableViewCell *templateCell;
@property(nonatomic, assign) CMRecorderStoreType recoredType;

- (instancetype)initWithIdentifer:(NSString *)identifer cellClass:(Class)cellClass;

- (instancetype)initWithIdentifer:(NSString *)identifer Xib:(UINib *)cellNib owner:(id)owner options:(NSDictionary *)options;

- (instancetype)initWithStoryBoardIdentifer:(NSString *)identifer;

@end
