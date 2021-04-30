//
//  SMSwipeView.h
//  Base
//
//  Created by whbt_mac on 15/12/28.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSwipeView;

@protocol SMSwipeDelegate <NSObject>

@required
-(UITableViewCell*)SMSwipeGetView:(SMSwipeView*)swipe withIndex:(int)index;
-(NSInteger)SMSwipeGetTotaleNum:(SMSwipeView*)swipe;
@end

@interface SMSwipeView : UIView

@property(nonatomic,weak)id<SMSwipeDelegate> delegate;


-(void)reloadData;//加载方法
-(UITableViewCell*)dequeueReusableUIViewWithIdentifier:(NSString*)identifier;//根据id获取缓存的cell

@end
