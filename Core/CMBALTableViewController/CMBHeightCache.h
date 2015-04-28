//
//  CMBHeightCache.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/28.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBALHeightCacheProtocol.h"
#import "CMBALTableViewCell.h"
@interface CMBHeightCache : NSObject

@property(nonatomic, weak)UITableView *registeredTableView;

@property(nonatomic, assign, readonly) CGFloat registeredTableWidth;

@property(nonatomic, assign, readonly) CGFloat cellFixedHeight;

@property(nonatomic, assign, readonly) BOOL isCellFixed;

@property(nonatomic, copy) NSString *reuseIdentiferFormatString;

@property(nonatomic, assign) BOOL isDebugging;

- (instancetype)initWithReferenceTableView:(UITableView *)tableView;

- (void)updateRegisterWidth;

@end

@interface CMBHeightCache (CellInCodeRegister)

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier;

@end

@interface CMBHeightCache (CellInXibRegister)

- (void)registerNibName:(NSString *)nibName forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass owner:(id)owner options:(NSDictionary *)options forCellReuseIdentifier:(NSString *)identifier;

@end

@interface CMBHeightCache (CellInStoryBoardRegister)

- (void)registStoryboardCellMapModelClass:(Class<CMBALHeightCacheProtocol>)modelClass xibIdentifer:(NSString *)identifer;

@end

@interface CMBHeightCache (CellRegisterManagement)

- (void)clearMappingCache;

@end

@interface CMBHeightCache (DequeueCellOperations)

- (NSString *)cellReuseIdentifierForModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (CMBALTableViewCell *)reuseCellForModel:(id<CMBALHeightCacheProtocol> )model;

- (CMBALTableViewCell *)reuseCellForModelClassName:(NSString *)modelClassName;

- (CMBALTableViewCell *)reuseCellForModel:(id<CMBALHeightCacheProtocol>)model forIndexPath:(NSIndexPath *)indexPath;

- (CMBALTableViewCell *)reuseCellForModelClassName:(NSString *)modelClassName forIndexPath:(NSIndexPath *)indexPath;

- (CMBALTableViewCell *)templateCellForModel:(id<CMBALHeightCacheProtocol>)model;

- (CMBALTableViewCell *)templateCellForModelClassName:(NSString *)modelClassName;

@end

@interface CMBHeightCache (HeigthCaculateOperations)

- (CGFloat)cmbHeightForModel:(id<CMBALHeightCacheProtocol>)model;

@end

@interface CMBHeightCache (CellFixedOperations)

- (void)setCellFixedHeight:(CGFloat)cellFixedHeight refreshed:(BOOL)animated;

@end

