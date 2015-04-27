//
//  CMBALTableViewController.h
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBALModel.h"
#import "CMBALTableViewCell.h"
#import "CMBALHeightCacheProtocol.h"
typedef NS_ENUM(NSUInteger, CMBTableSourceType){
    CMBTableSourceDefault,
    CMBTableSourceInner,
};

@interface CMBALTableViewController : UITableViewController

@property(nonatomic, copy) NSMutableArray *dataSource;

@property(nonatomic, assign) CGFloat registedTableWidth;

@property(nonatomic, assign, readonly) CGFloat fixedCellHeight;

@property(nonatomic, assign) BOOL isCellFixed;

@property(nonatomic) CMBTableSourceType sourceType;

- (instancetype)initWithTableStyle:(UITableViewStyle)style
                          sourceType:(CMBTableSourceType)sourceType;

- (CGFloat)cellHeightForModel:(CMBALModel *)model;



@end


@interface CMBALTableViewController (CellRegistOperations)

- (NSString *)cellReuseIdentifierForModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier;

- (void)registerNibName:(NSString *)nibName forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass owner:(id)owner options:(NSDictionary *)options forCellReuseIdentifier:(NSString *)identifier;


- (void)registStoryboardCellMapModelClass:(Class<CMBALHeightCacheProtocol>)modelClass xibIdentifer:(NSString *)identifer;

- (void)removeCellRegisRecord;

@end

@interface CMBALTableViewController (CellFixedOperations)

- (void)setFixedCellHeight:(CGFloat)height;

- (void)setFixedCellHeight:(CGFloat)height refreshed:(BOOL)animated;

@end

@interface CMBALTableViewController (TableSourceOperations)

- (void)appendSource:(id)source;

- (void)appendSource:(id)source reloaded:(BOOL)reload;

- (void)innerAppendSource:(id)source;

- (void)innerAppendSource:(id)source reloaded:(BOOL)reload;

- (CMBALModel *)modelForIndexPath:(NSIndexPath *)indexPath

@end