//
//  TestViewViewController.m
//  navDemo
//
//  Created by HC－101 on 2018/10/23.
//  Copyright © 2018 stonemover. All rights reserved.
//

#import "TestViewViewController.h"

@interface TestViewViewController ()

@end

@implementation TestViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"测试view";
    
    UIButton * back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 60)];
    back.backgroundColor=[UIColor blackColor];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self initBarItem:back withType:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
