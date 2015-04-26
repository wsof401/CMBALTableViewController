//
//  TestXibCell.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/25.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "TestXibCell.h"

@implementation TestXibCell

- (void)initializationForXib{
    self.avartarImageView.image = [UIImage imageNamed:@"reload"];
    self.commentLabel.text = @"啊哈哈哈";
}

@end
