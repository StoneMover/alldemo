//
//  SwipeViewController.m
//  Base
//
//  Created by whbt_mac on 15/12/29.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import "SwipeViewController.h"
#import "SMSwipeView.h"

@interface SwipeViewController ()<SMSwipeDelegate>

@property (weak, nonatomic) IBOutlet SMSwipeView *swipe;

@property (nonatomic,strong) NSArray * colors;

@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"滑动效果";
    self.swipe.delegate=self;
    self.colors=@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)SMSwipeGetView:(SMSwipeView *)swipe withIndex:(int)index{
    static NSString * identify=@"testIndentify";
    UITableViewCell * cell=[self.swipe dequeueReusableUIViewWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else{
        NSLog(@"%@",@"not nil");
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%d",index];
    cell.backgroundColor=self.colors[index];
    cell.imageView.image=[UIImage imageNamed:@"choose_gou"];
    cell.layer.cornerRadius=10;
    return cell;
}

-(NSInteger)SMSwipeGetTotaleNum:(SMSwipeView *)swipe{
    return 3;
}

@end
