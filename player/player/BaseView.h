//
//  BaseView.h
//  Base
//
//  Created by whbt_mac on 15/12/28.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

@property(nonatomic,assign)int w;//自身的宽度

@property(nonatomic,assign)int h;//自身的高度

@property(nonatomic,assign)int isNeedFirLayout;//0的时候为第一次,以后每次加1,是否是第一次加载layoutsubview方法

//从xib的初始化
-(void)awakeFromNib;
//从frame的初始化
-(instancetype)initWithFrame:(CGRect)frame;

-(void)layoutSubviews;
//自身初始化
-(void)initSelf;
//自身第一次被初始化的时候调用
-(void)layoutSubviewsFirst;
//从nib加载view
-(UIView*)getViewFromNib:(NSString*)nibName withOwer:(id)owner;

@end
