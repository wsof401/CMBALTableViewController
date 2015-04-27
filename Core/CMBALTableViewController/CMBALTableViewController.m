//
//  CMBALTableViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBALTableViewController.h"
#import "CMBRegisterInfo.h"


static NSString *const kCMALTableViewIdentiferCompnent = @"CMB_Registed_CellClass:%@";

@interface CMBALTableViewController ()
@property(nonatomic, strong) NSMutableDictionary *cellMapCollection;
@end

@implementation CMBALTableViewController

- (instancetype)initWithTableStyle:(UITableViewStyle)style
                        sourceType:(CMBTableSourceType)sourceType{
    self = [super initWithStyle:style];
    if (self) {
        _sourceType = sourceType;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [self initWithTableStyle:style
                         sourceType:CMBTableSourceDefault];
}

- (instancetype)init{
    return [self initWithTableStyle:UITableViewStylePlain
                         sourceType:CMBTableSourceDefault];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _sourceType = CMBTableSourceDefault;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.registedTableWidth = CGRectGetHeight(self.tableView.frame);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Cell Regist Operation

- (NSString *)cellReuseIdentifierForModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *cellClass = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = self.cellMapCollection[cellClass];
    return recorder ? recorder.reuseIdentifer : nil;
}

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer = [[NSString alloc] initWithFormat:kCMALTableViewIdentiferCompnent,NSStringFromClass(modelClass)];
    [self registerCellClass:cellClass forModelClass:modelClass forCellReuseIdentifier:customIdentifer];
}

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithIdentifer:identifier cellClass:cellClass];
    recorder.mappingModel = modelClassName;
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    self.cellMapCollection[modelClassName] = recorder;
}


- (void)registerNibName:(NSString *)nibName forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer = [[NSString alloc] initWithFormat:kCMALTableViewIdentiferCompnent,NSStringFromClass(modelClass)];
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:customIdentifer];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer = [[NSString alloc] initWithFormat:kCMALTableViewIdentiferCompnent,NSStringFromClass(modelClass)];
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:customIdentifer];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    [self registerNib:nib forModelClass:modelClass owner:nil options:nil forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass owner:(id)owner options:(NSDictionary *)options forCellReuseIdentifier:(NSString *)identifier{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithIdentifer:identifier Xib:nib owner:owner options:options];
    recorder.mappingModel = modelClassName;
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    self.cellMapCollection[modelClassName] = recorder;
}

- (void)registStoryboardCellMapModelClass:(Class<CMBALHeightCacheProtocol>)modelClass xibIdentifer:(NSString *)identifer{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMBRegisterInfo *recorder = [[CMBRegisterInfo alloc] initWithStoryBoardIdentifer:identifer];
    recorder.mappingModel = modelClassName;
    recorder.templateCell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    self.cellMapCollection[modelClassName] = recorder;
}

- (void)removeCellRegisRecord{
    self.cellMapCollection = [NSMutableDictionary dictionary];
}

#pragma mark - CMB dataSource Core

- (NSInteger)cmb_sectionType{
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            return 1;
            break;
        case CMBTableSourceInner:
            return self.dataSource.count;
            break;
    }
}

- (NSInteger)cmb_numberOfRowsInsection:(NSInteger)section{
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            return self.dataSource.count;
            break;
        case CMBTableSourceInner:
            return [self.dataSource[section] count];
            break;
    }
}

- (CMBALModel *)modelForIndexPath:(NSIndexPath *)indexPath{
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            return self.dataSource[indexPath.row];
            break;
        case CMBTableSourceInner:
            return self.dataSource[indexPath.section][indexPath.row];
            break;
    }
}

- (CMBALTableViewCell *)templateCellForModelNamed:(NSString *)modelName{
    CMBRegisterInfo *modelRecorder = self.cellMapCollection[modelName];
    NSAssert(modelRecorder && [modelRecorder.templateCell isKindOfClass:[CMBALTableViewCell class]], @"can not load template cell for model class : %@",modelName);
    return modelRecorder.templateCell;
}

- (CMBALTableViewCell *)reusedCellForModelNamed:(NSString *)modelName{
    CMBRegisterInfo *modelRecorder = self.cellMapCollection[modelName];
    CMBALTableViewCell *reusedCell = [self.tableView dequeueReusableCellWithIdentifier:modelRecorder.reuseIdentifer];
    NSAssert(modelRecorder && reusedCell, @"can not load reuse cell for model class : %@",modelName);
    return reusedCell;
}

- (CGFloat)rowHeightForModel:(CMBALModel *)model{
    if (_isCellFixed) {
        return self.fixedCellHeight;
    }
    
    if (model.mappingTableWidth != self.registedTableWidth) {
        model.cachedHeight = [self caculateRowHeightForModel:model];
        model.mappingTableWidth = self.registedTableWidth;
    }
    
    return model.cachedHeight;
}

- (CGFloat)caculateRowHeightForModel:(CMBALModel *)model {
    NSString *modelName = NSStringFromClass([model class]);
    CMBALTableViewCell *cell = [self templateCellForModelNamed:modelName];
    NSAssert(cell, @"SomeThing wrong happend,Check the code if had regist the model : %@",modelName);
    if (model.mappingTableWidth != self.registedTableWidth) {
        [cell updateConstraintsIfTableStretch];
    }
    [cell templateLoadWithModel:model];
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    cell.contentView.bounds = cell.bounds;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        height += 1;
    }
    return height;
}

- (CGFloat)cellHeightForModel:(CMBALModel *)model{
    return [self caculateRowHeightForModel:model];
}

#pragma mark - TableSourceOperations

- (void)appendSource:(id)source{
    [self appendSource:source reloaded:YES];
}

- (void)appendSource:(id)source reloaded:(BOOL)reload{
    NSAssert(source, @"appending source can not be nil");
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            if ([source isKindOfClass:[NSArray class]]) {
                [self.dataSource addObjectsFromArray:source];
            }else{
                [self.dataSource addObject:source];
            }
            break;
        case CMBTableSourceInner:
            NSAssert([source isKindOfClass:[NSArray class]], @"CMBTableSourceInner should add from an NSArray and subClasses,If you need inner append pleas call innerAppend");
            [self.dataSource addObject:source];
            break;
    }
}

- (void)innerAppendSource:(id)source{
    id appendingSource = source;
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            break;
        case CMBTableSourceInner:{
            NSArray *tmpArray = self.dataSource.lastObject ? : @[];
            [self.dataSource removeLastObject];
            NSArray *insertArray = [source isKindOfClass:[NSArray class]] ? source : @[source];
            appendingSource = [tmpArray arrayByAddingObjectsFromArray:insertArray];
        }
    }
    [self appendSource:appendingSource];
}

- (void)innerAppendSource:(id)source reloaded:(BOOL)reload{
    id appendingSource = source;
    switch (self.sourceType) {
        case CMBTableSourceDefault:
            break;
        case CMBTableSourceInner:{
            NSArray *tmpArray = self.dataSource.lastObject ? : @[];
            [self.dataSource removeLastObject];
            NSArray *insertArray = [source isKindOfClass:[NSArray class]] ? source : @[source];
            appendingSource = [tmpArray arrayByAddingObjectsFromArray:insertArray];
        }
    }
    [self appendSource:appendingSource reloaded:reload];
}

#pragma mark - TableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self cmb_sectionType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self cmb_numberOfRowsInsection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMBALModel *model = [self modelForIndexPath:indexPath];
    NSString *modelName = NSStringFromClass([model class]);
    CMBALTableViewCell *reusedCell = [self reusedCellForModelNamed:modelName];
    [reusedCell commonConfigWithModel:model];
    return reusedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMBALModel *model = [self modelForIndexPath:indexPath];
    return [self rowHeightForModel:model];
}

#pragma mark --Custom Associate

- (NSMutableDictionary *)cellMapCollection{
    if (!_cellMapCollection) {
        _cellMapCollection = [NSMutableDictionary dictionary];
    }
    return _cellMapCollection;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
