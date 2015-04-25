//
//  TestCell.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/25.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "TestCell.h"
#import "PureLayout.h"


@implementation TestCell{

}

- (void)initializationForCode{
    
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:0.1];

    
    _arvatar = [UIImageView newAutoLayoutView];
    _arvatar.contentMode = UIViewContentModeScaleAspectFit;
    
    _title = [UILabel newAutoLayoutView];
    _title.textColor = [UIColor colorWithRed:0.2 green:0.3 blue:02 alpha:0.5];
    
    [self.contentView addSubview:_arvatar];
    [self.contentView addSubview:_title];
    
    [UIView autoSetPriority:999 forConstraints:^{
        [_arvatar autoSetDimensionsToSize:CGSizeMake(100, 100)];
    }];
    
    [_arvatar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 8, 8, 8) excludingEdge:ALEdgeTrailing];
    [_title autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_arvatar];
    [_title autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_arvatar withOffset:10];
    [_title autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10];
}

- (void)commonConfigWithModel:(id<CMBALHeightCacheProtocol>)dataModel{
    _arvatar.image = [UIImage imageNamed:@"reload"];
    _title.text = @"test example";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
