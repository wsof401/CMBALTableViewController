//
//  TestXibViewController.m
//  CMBALTableViewController
//
//  Created by wusong on 15/4/25.
//  Copyright (c) 2015年 CMB. All rights reserved.
//

#import "TestXibViewController.h"
#import "TestXibCell.h"
#import "CMBALModel.h"
@interface TestXibViewController ()

@end

@implementation TestXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registStoryboardCellMapModelClass:[CMBALModel class] xibIdentifer:@"1"];
    [self.dataSource addObjectsFromArray:@[[CMBALModel new],[CMBALModel new]]];
    
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
