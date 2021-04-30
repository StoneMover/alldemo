//
//  MainViewController.m
//  navDemo
//
//  Created by stonemover on 2017/10/20.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"TestNav";
    UIButton * leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.backgroundColor=[UIColor redColor];
    [leftButton setTitle:@"Hello" forState:UIControlStateNormal];
    [self initBarItem:leftButton withType:0];
    
    
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    rightView.backgroundColor=[UIColor greenColor];
    [self initBarItem:rightView withType:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)pushClick:(id)sender {
    TestViewViewController * vc=[TestViewViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
