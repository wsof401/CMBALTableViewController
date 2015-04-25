//
//  CMBALTableViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBALTableViewController.h"
#import "CMRecorder.h"


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    CMRecorder *recorder = self.cellMapCollection[cellClass];
    return recorder ? recorder.identifer : nil;
}

- (void)registCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    NSString *customIdentifer = [[NSString alloc] initWithFormat:kCMALTableViewIdentiferCompnent,NSStringFromClass(modelClass)];
    [self registCellClass:cellClass forModelClass:modelClass forCellReuseIdentifier:customIdentifer];
}

- (void)registCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    NSString *modelClassName = NSStringFromClass(modelClass);
    CMRecorder *recorder = [[CMRecorder alloc] initWithIdentifer:identifier cellClass:cellClass];
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    self.cellMapCollection[modelClassName] = recorder;
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
    CMRecorder *recorder = [[CMRecorder alloc] initWithIdentifer:identifier Xib:nib owner:owner options:options];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
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

- (CMALModel *)modelForIndexPath:(NSIndexPath *)indexPath{
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
    CMRecorder *modelRecorder = self.cellMapCollection[modelName];
    NSAssert(modelRecorder && [modelRecorder.templateCell isKindOfClass:[CMBALTableViewCell class]], @"can not load template cell for model class : %@",modelName);
    return modelRecorder.templateCell;
}

- (CMBALTableViewCell *)reusedCellForModelNamed:(NSString *)modelName{
    CMRecorder *modelRecorder = self.cellMapCollection[modelName];
    CMBALTableViewCell *reusedCell = [self.tableView dequeueReusableCellWithIdentifier:modelRecorder.identifer];
    NSAssert(modelRecorder && reusedCell, @"can not load reuse cell for model class : %@",modelName);
    return reusedCell;
}

- (CGFloat)rowHeightForModel:(CMALModel *)model{
    if (_isCellFixed) {
        return self.fixedCellHeight;
    }
    
    if (model.mappingTableWidth != self.registedTableWidth) {
        model.cachedHeight = [self caculateRowHeightForModel:model];
        model.mappingTableWidth = self.registedTableWidth;
    }

    return model.cachedHeight;
}

- (CGFloat)caculateRowHeightForModel:(CMALModel *)model {
    NSString *modelName = NSStringFromClass([model class]);
    CMBALTableViewCell *cell = [self templateCellForModelNamed:modelName];
    NSAssert(cell, @"SomeThing wrong happend,Check the code if had regist the model : %@",modelName);
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

#pragma mark - TableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self cmb_sectionType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self cmb_numberOfRowsInsection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMALModel *model = [self modelForIndexPath:indexPath];
    NSString *modelName = NSStringFromClass([model class]);
    CMBALTableViewCell *reusedCell = [self reusedCellForModelNamed:modelName];
    [reusedCell commonConfigWithModel:model];
    return reusedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMALModel *model = [self modelForIndexPath:indexPath];
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
