//
//  SMSliderBar.h
//  Base
//
//  Created by whbt_mac on 15/12/5.
//  Copyright © 2015年 StoneMover. All rights reserved.
//
#import "BaseView.h"


typedef NS_ENUM(NSInteger,SMSliderType){
    SMSliderTypeHoz=0,
    SMSliderTypeVer
};

@class SMSliderBar;

@protocol SMSliderDelegate <NSObject>

@optional
-(void)SMSliderBar:(SMSliderBar*)slider valueChanged:(float)value;
-(void)SMSliderBarBeginTouch:(SMSliderBar *)slider;
-(void)SMSliderBarEndTouch:(SMSliderBar *)slider;
@end



@interface SMSliderBar : BaseView


/**
 *  @author StoneMover, 15-12-07 14:12:59
 *
 *  @brief 圆点view
 */
@property(nonatomic,strong)UIView * viewPoint;


/**
 *  @author StoneMover, 15-12-07 14:12:53
 *
 *  @brief 进度颜色
 */
@property(nonatomic,strong)UIColor * progressColor;


/**
 *  @author StoneMover, 15-12-07 14:12:48
 *
 *  @brief 进度背景色
 */
@property(nonatomic,strong)UIColor * progressBgColor;


/**
 *  @author StoneMover, 15-12-07 14:12:42
 *
 *  @brief 改变值的触摸间距,大于这个值认为进度改变
 */
@property(nonatomic,assign)float changeDistance;

/**
 *  @author StoneMover, 15-12-07 14:12:21
 *
 *  @brief 类型,垂直或者水平
 */
@property(nonatomic,assign)SMSliderType type;

/**
 *  @author StoneMover, 15-12-07 14:12:07
 *
 *  @brief 进度条的值
 */
@property(nonatomic,assign)float value;


@property(nonatomic,weak)id<SMSliderDelegate> delegate;


/**
 *  @author StoneMover, 15-12-07 14:12:50
 *
 *  @brief 是否在按下的时候也可以改变value
 */
@property(nonatomic,assign)BOOL isTouchBegin;


@end
