//
//  TestViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/25.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "TestViewController.h"
#import "TestCell.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.sourceType = CMBTableSourceDefault;

    [self.dataSource addObjectsFromArray:@[[CMALModel new],[CMALModel new]]];
    [self registCellClass:[TestCell class] forModelClass:[CMALModel class]];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
