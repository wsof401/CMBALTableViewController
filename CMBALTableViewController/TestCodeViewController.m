//
//  TestViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/25.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "TestCodeViewController.h"
#import "TestCodeCell.h"
#import "CMBALModel.h"
@interface TestCodeViewController ()

@end

@implementation TestCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.sourceType = CMBTableSourceDefault;

    //使用代码创建cell
    [self.dataSource addObjectsFromArray:@[[CMBALModel new],[CMBALModel new]]];
    [self registerCellClass:[TestCodeCell class] forModelClass:[CMBALModel class]];

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
