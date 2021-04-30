//
//  BaseViewController.h
//  navDemo
//
//  Created by HC－101 on 2018/10/23.
//  Copyright © 2018 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

//0:leftBarButtonItems,1:rightBarButtonItems
- (void)initBarItem:(UIView*)view withType:(int)type;

-(void)viewDidLayoutSubviews;

@end

NS_ASSUME_NONNULL_END
