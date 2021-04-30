//
//  BaseViewController.m
//  navDemo
//
//  Created by HC－101 on 2018/10/23.
//  Copyright © 2018 stonemover. All rights reserved.
//

#import "BaseViewController.h"

#define IS_IOS_VERSION_11 (([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0)? (YES):(NO))


@interface BaseViewController ()

@property (nonatomic, assign) BOOL isNeedUpdate;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedUpdate=YES;
}

//0:leftBarButtonItems,1:rightBarButtonItems
- (void)initBarItem:(UIView*)view withType:(int)type{
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    //解决按钮不靠左 靠右的问题.iOS 11系统需要单独处理
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -16;//这个值可以根据自己需要自己调整
    switch (type) {
        case 0:
            if (!IS_IOS_VERSION_11) {
                self.navigationItem.leftBarButtonItems =@[spaceItem,buttonItem];
            }else{
                self.navigationItem.leftBarButtonItems =@[buttonItem];
            }
            break;
        case 1:
            if (!IS_IOS_VERSION_11) {
                self.navigationItem.rightBarButtonItems =@[spaceItem,buttonItem];
            }else{
                self.navigationItem.rightBarButtonItems =@[buttonItem];
            }
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedUpdate) {
        [self.view setNeedsLayout];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isNeedUpdate=YES;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateNavLayout];
}

- (void)updateNavLayout{
    if (!IS_IOS_VERSION_11||!self.isNeedUpdate) {
        return;
    }
    self.isNeedUpdate=NO;
    UINavigationItem * item=self.navigationItem;
    NSArray * array=item.leftBarButtonItems;
    if (array&&array.count!=0){
        UIBarButtonItem * buttonItem=array[0];
        UIView * view =[[[buttonItem.customView superview] superview] superview];
        NSArray * arrayConstraint=view.constraints;
        for (NSLayoutConstraint * constant in arrayConstraint) {
            //由于各个系统、手机类型（iPhoneX）的间距不一样，这里要根据不同的情况来做判断m，不一定是等于16的
            if (fabs(constant.constant)==16) {
                constant.constant=0;
            }
            NSLog(@"%f",constant.constant);
        }
    }
}

@end
