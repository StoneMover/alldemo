//
//  ViewController.m
//  scrollTest
//
//  Created by stonemover on 2017/6/21.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "ViewController.h"
#import "TestTableViewCell.h"
#import "UIScrollView+ScrollAnimation.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TestTableViewCell" bundle:nil] forCellReuseIdentifier:@"TestTableViewCellId"];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender {
    CAMediaTimingFunction * timing=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [self.tableView setContentOffset:CGPointMake(0, 100)animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+44) withTimingFunction:timing duration:1];
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"TestTableViewCellId"];
    cell.label.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"%@",@"scrollViewDidEndScrollingAnimation");
    
    CAMediaTimingFunction * timing=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    if (self.tableView.contentOffset.y<200*44) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+44) withTimingFunction:timing duration:1];
        
    }
}

@end
