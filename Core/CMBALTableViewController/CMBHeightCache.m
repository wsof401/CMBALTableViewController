//
//  CMBHeightCache.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/28.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBHeightCache.h"
#import "CMBRegisterInfo.h"

static NSString *const kCMALTableViewCellIdentiferCompnent = @"CMB_Registed_CellClass:%@";

@interface CMBHeightCache ()

@property(nonatomic, strong) NSMutableDictionary *cellMapCollection;

@end

@implementation CMBHeightCache

- (instancetype)initWithReferenceTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _registeredTableView = tableView;
        _reuseIdentiferFormatString = kCMALTableViewCellIdentiferCompnent;
    }
    return self;
}

- (void)updateRegisterWidth{
    _registeredTableWidth = CGRectGetWidth(_registeredTableView.frame);
}

#pragma mark -Cells custom reuseIdentifer

- (NSString *)cmCreateReusedIdentiferBasedOnModel:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *modelClassName = NSStringFromClass(modelClass);
    return [[NSString alloc] initWithFormat:kCMALTableViewCellIdentiferCompnent,modelClassName];
}

#pragma mark -Cell init with code register operation

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer =  [self cmCreateReusedIdentiferBasedOnModel:modelClass];
    [self registerCellClass:cellClass forModelClass:modelClass forCellReuseIdentifier:customIdentifer];
}

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithIdentifer:identifier cellClass:cellClass];
    recorder.mappingModel = modelClassName;
    [self.registeredTableView registerClass:cellClass forCellReuseIdentifier:identifier];
    self.cellMapCollection[modelClassName] = recorder;
}

#pragma mark -Cell init with nib register operation

- (void)registerNibName:(NSString *)nibName forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer =  [self cmCreateReusedIdentiferBasedOnModel:modelClass];
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:customIdentifer];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer =  [self cmCreateReusedIdentiferBasedOnModel:modelClass];
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:customIdentifer];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass owner:(id)owner options:(NSDictionary *)options forCellReuseIdentifier:(NSString *)identifier{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithIdentifer:identifier Xib:nib owner:owner options:options];
    recorder.mappingModel = modelClassName;
    [self.registeredTableView registerNib:nib forCellReuseIdentifier:identifier];
    self.cellMapCollection[modelClassName] = recorder;
}

#pragma mark -Cell init with storyboard

- (void)registStoryboardCellMapModelClass:(Class<CMBALHeightCacheProtocol>)modelClass xibIdentifer:(NSString *)identifer{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithStoryBoardIdentifer:identifer];
    recorder.mappingModel = modelClassName;
    recorder.templateCell = [self.registeredTableView dequeueReusableCellWithIdentifier:identifer];
    self.cellMapCollection[modelClassName] = recorder;
}

#pragma mark -Cell register management

- (void)clearMappingCache{
    [self.cellMapCollection removeAllObjects];
}

#pragma mark -Cell dequeueReuse reference

- (NSString *)cellReuseIdentifierForModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = self.cellMapCollection[modelClassName];
    return recorder ? recorder.reuseIdentifer : nil;
}

- (CMBALTableViewCell *)reuseCellForModel:(id<CMBALHeightCacheProtocol>)model{
    NSString *modelClassName = NSStringFromClass([model class]);
    return [self reuseCellForModelClassName:modelClassName];
}

- (CMBALTableViewCell *)reuseCellForModelClassName:(NSString *)modelClassName{
    CMBRegisterInfo *recorder = self.cellMapCollection[modelClassName];
    NSAssert1(recorder || self.isDebugging, @"Seems the cache can not find the mapping cell For Model:%@",modelClassName);
    return [self.registeredTableView dequeueReusableCellWithIdentifier:recorder.reuseIdentifer];
}

- (CMBALTableViewCell *)reuseCellForModel:(id<CMBALHeightCacheProtocol>)model forIndexPath:(NSIndexPath *)indexPath{
    NSString *modelClassName = NSStringFromClass([model class]);
    return [self reuseCellForModelClassName:modelClassName forIndexPath:indexPath];
}

- (CMBALTableViewCell *)reuseCellForModelClassName:(NSString *)modelClassName forIndexPath:(NSIndexPath *)indexPath{
    CMBRegisterInfo *recorder = self.cellMapCollection[modelClassName];
    NSAssert1(recorder || self.isDebugging, @"Seems the cache can not find the mapping relation For Model:%@",modelClassName);
    return [self.registeredTableView dequeueReusableCellWithIdentifier:recorder.reuseIdentifer forIndexPath:indexPath];
}

- (CMBALTableViewCell *)templateCellForModel:(id<CMBALHeightCacheProtocol>)model{
    NSString *modelClassName = NSStringFromClass([model class]);
    return  [self templateCellForModelClassName:modelClassName];
}

- (CMBALTableViewCell *)templateCellForModelClassName:(NSString *)modelClassName{
    CMBRegisterInfo *recorder = self.cellMapCollection[modelClassName];
    NSAssert1(recorder.templateCell || self.isDebugging, @"Seems the cache can not find the mapping cell For Model:%@",modelClassName);
    return recorder.templateCell;
}

#pragma mark -HeigthCaculateOperations

- (CGFloat)cmbHeightForModel:(id<CMBALHeightCacheProtocol>)model{
    if (model.mappingTableWidth == self -> _registeredTableWidth) {
        return model.cachedHeight;
    }
    CMBALTableViewCell *tmpLateCell = [self templateCellForModel:model];
    NSAssert(tmpLateCell, @"SomeThing wrong happend,Check the code if had regist the model : %@", NSStringFromClass([model class]));
    if (model.mappingTableWidth != self -> _registeredTableWidth) {
        [tmpLateCell updateConstraintsIfTableStretch];
    }
    [tmpLateCell templateLoadWithModel:model];
    tmpLateCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.registeredTableView.bounds), CGRectGetHeight(tmpLateCell.bounds));
    tmpLateCell.contentView.bounds = tmpLateCell.bounds;
    [tmpLateCell setNeedsLayout];
    [tmpLateCell layoutIfNeeded];
    
    CGFloat height = [tmpLateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (self.registeredTableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        height += 1 / [UIScreen mainScreen].scale;
    }
    
    model.cachedHeight = height;
    model.mappingTableWidth = self -> _registeredTableWidth;
    return height;
}

#pragma mark -CellFixedOperations)

- (NSMutableDictionary *)cellMapCollection{
    if (!_cellMapCollection) {
        _cellMapCollection = [NSMutableDictionary dictionary];
    }
    return _cellMapCollection;
}

- (void)setCellFixedHeight:(CGFloat)cellFixedHeight{
    _isCellFixed = cellFixedHeight > 0 ? YES : NO;
    _cellFixedHeight = cellFixedHeight;
}

- (void)setCellFixedHeight:(CGFloat)cellFixedHeight refreshed:(BOOL)animated{
    _isCellFixed = cellFixedHeight > 0 ? YES : NO;
    _cellFixedHeight = cellFixedHeight;
    if (animated) {
        [self.registeredTableView reloadData];
    }
}

#pragma mark --Custom Associate

- (void)setRegisteredTableView:(UITableView *)registTableView{
    if (_registeredTableView != registTableView && ![_registeredTableView isEqual:registTableView]) {
        _registeredTableWidth = CGRectGetWidth(registTableView.frame);
    }
    _registeredTableView = registTableView;
}

@end
