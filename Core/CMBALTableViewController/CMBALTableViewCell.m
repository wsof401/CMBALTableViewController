//
//  CMBALTableViewCell.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/24.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "CMBALTableViewCell.h"

@implementation CMBALTableViewCell
@synthesize model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _cmbRootInitForCode];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _cmbRootInitForCode];
    }
    return self;
}

- (void)awakeFromNib {
    [self _cmbRootInitForXib];
}

#pragma makr --Initialization

- (void)_cmbRootInitForCode{
    [self initializationForCode];
}

- (void)_cmbRootInitForXib{
    [self initializationForXib];
}

- (void)initializationForCode{
    
}

- (void)initializationForXib{
    
}

#pragma mark --Data binding

- (void)loadWithModel:(id<CMBALHeightCacheProtocol>)dataModel{
    self.model = dataModel;
    [self commonConfigWithModel:dataModel];
}

- (void)commonConfigWithModel:(id<CMBALHeightCacheProtocol>)dataModel{
    
}

- (void)templateLoadWithModel:(id<CMBALHeightCacheProtocol>)dataModel{
    [self commonConfigWithModel:dataModel];
}

@end
