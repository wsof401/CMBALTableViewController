//
//  CMBALTableViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBALTableViewController.h"

@interface CMBALTableViewController ()
@property(nonatomic, strong) CMBHeightCache *cmbHeightCache;
@end

@implementation CMBALTableViewController

- (instancetype)initWithTableStyle:(UITableViewStyle)style
                        sourceType:(CMBTableSourceType)sourceType{
    self = [super initWithStyle:style];
    if (self) {
        _sourceType = sourceType;
        _cmbHeightCache = [[CMBHeightCache alloc] initWithReferenceTableView:self.tableView];
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

- (void)awakeFromNib{
    [super awakeFromNib];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cmbHeightCache = [[CMBHeightCache alloc]initWithReferenceTableView:self.tableView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.cmbHeightCache updateRegisterWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Cell Regist Operation

- (NSString *)cellReuseIdentifierForModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    return [self.cmbHeightCache cellReuseIdentifierForModelClass:modelClass];
}

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    [self.cmbHeightCache registerCellClass:cellClass forModelClass:modelClass];
}

- (void)registerCellClass:(Class)cellClass forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    [self.cmbHeightCache registerCellClass:cellClass forModelClass:modelClass forCellReuseIdentifier:identifier];
}


- (void)registerNibName:(NSString *)nibName forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    [self.cmbHeightCache registerNibName:nibName forModelClass:modelClass];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass{
    [self.cmbHeightCache registerNib:nib forModelClass:modelClass];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass forCellReuseIdentifier:(NSString *)identifier{
    [self.cmbHeightCache registerNib:nib forModelClass:modelClass forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forModelClass:(Class<CMBALHeightCacheProtocol>)modelClass owner:(id)owner options:(NSDictionary *)options forCellReuseIdentifier:(NSString *)identifier{
    [self.cmbHeightCache registerNib:nib forModelClass:modelClass owner:owner options:options forCellReuseIdentifier:identifier];
}

- (void)registStoryboardCellMapModelClass:(Class<CMBALHeightCacheProtocol>)modelClass xibIdentifer:(NSString *)identifer{
    [self.cmbHeightCache registStoryboardCellMapModelClass:modelClass xibIdentifer:identifer];
}

- (void)clearMappingCache{
    [self.cmbHeightCache clearMappingCache];
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

- (id<CMBALHeightCacheProtocol>)modelForIndexPath:(NSIndexPath *)indexPath{
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
    CMBALTableViewCell *templateCell = [self.cmbHeightCache templateCellForModelClassName:modelName];
    return templateCell;
}

- (CMBALTableViewCell *)reusedCellForModelNamed:(NSString *)modelName{
    CMBALTableViewCell *reusedCell = [self.cmbHeightCache reuseCellForModelClassName:modelName];
    return reusedCell;
}

- (CGFloat)rowHeightForModel:(id<CMBALHeightCacheProtocol>)model{
    if (self.cmbHeightCache.isCellFixed) {
        return self.cmbHeightCache.cellFixedHeight;
    }
    
    if (model.mappingTableWidth != self.cmbHeightCache.registeredTableWidth) {
        [self.cmbHeightCache cmbHeightForModel:model];
    }
    
    return model.cachedHeight;
}


- (CGFloat)cellHeightForModel:(id<CMBALHeightCacheProtocol>)model{
    return [self.cmbHeightCache cmbHeightForModel:model];
}

#pragma mark - TableSourceOperations

- (void)appendSource:(id)source{
    [self appendSource:source reloaded:YES];
}

- (void)appendSource:(id)source reloaded:(BOOL)reload{
    if (source) {
        switch (self.sourceType) {
            case CMBTableSourceDefault:
                if ([source isKindOfClass:[NSArray class]]) {
                    [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSAssert([obj conformsToProtocol:@protocol(CMBALHeightCacheProtocol)], @"appending source must conforms CMBALHeightCacheProtocol");
                        [self.cmbHeightCache cmbHeightForModel:(id<CMBALHeightCacheProtocol>)obj];
                        [self.dataSource addObject:obj];
                    }];
                }else{
                    NSAssert([source conformsToProtocol:@protocol(CMBALHeightCacheProtocol)], @"appending source must conforms CMBALHeightCacheProtocol");
                    [self.cmbHeightCache cmbHeightForModel:(id<CMBALHeightCacheProtocol>)source];
                    [self.dataSource addObject:source];
                }
                break;
            case CMBTableSourceInner:
                NSAssert([source isKindOfClass:[NSArray class]], @"CMBTableSourceInner should add from an NSArray and subClasses,If you need inner append pleas call innerAppend");
                [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSAssert([obj conformsToProtocol:@protocol(CMBALHeightCacheProtocol)], @"appending source must conforms CMBALHeightCacheProtocol");
                    [self.cmbHeightCache cmbHeightForModel:(id<CMBALHeightCacheProtocol>)obj];
                }];
                
                [self.dataSource addObject:source];
                break;
        }
    }
    if (reload) {
        [self.tableView reloadData];
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
    id<CMBALHeightCacheProtocol> model = [self modelForIndexPath:indexPath];
    NSString *modelName = NSStringFromClass([model class]);
    CMBALTableViewCell *reusedCell = [self.cmbHeightCache reuseCellForModelClassName:modelName];
    [reusedCell commonConfigWithModel:model];
    return reusedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<CMBALHeightCacheProtocol> model = [self modelForIndexPath:indexPath];
    return [self.cmbHeightCache cmbHeightForModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark --Custom Associate


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
