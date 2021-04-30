//
//  SMListDialogView.h
//  Base
//
//  Created by whbt_mac on 16/1/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BaseView.h"
#import "SMListDialogItem.h"

typedef NS_ENUM(NSInteger,SMDialogModel){
    SMListDialoglList=0,//列表模式
    SMDialogCustom//自定义View模式
};

typedef NS_ENUM(NSInteger,SMDialogAnimStyle) {
    SMDialogAnimStyleDefault=0,//类似系统对话框动画
    SMDialogAnimStyleAndroid//类似android系统对话框样式
};


typedef NS_ENUM(NSInteger,SMDialogLocation) {
    SMDialogLocationTop=0,//位置,顶部
    SMDialogLocationCenter,//中部
    SMDialogLocationBottom//底部
};

typedef NS_ENUM(NSInteger,SMDialogListStyle) {
    SMDialogListStyleNormal=0,//正常
    SMDialogListStyleSingleSelect,//单选
};

@class SMDialogView;

typedef BOOL (^SMListDialogViewBlock)(SMDialogView*view,int index,NSArray<__kindof SMListDialogItem*> * data);//返回bool值来表明是否关闭view

@protocol SMDialogDelegate <NSObject>

@optional
//返回bool值来表明是否关闭view
-(BOOL)SMListDialog:(SMDialogView*)view selectIndex:(int)index withData:(NSArray<__kindof SMListDialogItem*>*)data;

@end

@interface SMDialogView : BaseView


#pragma mark 共有配置
@property (assign, nonatomic) BOOL isNoCorner;//四周是否不需要圆角,默认需要

@property (nonatomic,assign) BOOL clickEmptyAreaDismiss;//点击空白区域不消失

#pragma mark SMListDialoglList配置

@property (strong, nonatomic) NSArray<__kindof SMListDialogItem*> * data;//数据源

@property (weak, nonatomic) id<SMDialogDelegate> delegate;//协议回调

@property (nonatomic, copy) SMListDialogViewBlock block;//block回调

//初始化tableView样式
-(instancetype)initListStyle:(SMDialogLocation)location withStyle:(SMDialogListStyle)style;
-(instancetype)initListStyle;

//初始化自定义view样式
-(instancetype)initCustomStyle:(UIView*)view withLocation:(SMDialogLocation)location;
-(instancetype)initCustomStyle:(UIView*)view;

//显示弹框,当初始化的location不为center的时候,动画参数无用,为滑动出现
-(void)show:(UIView*)view;
-(void)show:(UIView*)view withAnimStyle:(SMDialogAnimStyle)style;


-(void)dismiss;
-(void)destory;

-(void)setTableHeadConfig:(NSString*)title withTitleColor:(UIColor*)titleColor withDiverColor:(UIColor*)diverColor;

@end
