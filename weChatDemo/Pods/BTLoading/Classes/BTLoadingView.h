//
//  LoadingHelpView.h
//  Base
//
//  Created by whbt_mac on 15/11/3.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BTLoadingBlock)(void);

@interface BTLoadingView : UIView

//重新加载按钮控件
@property (strong, nonatomic) UIButton *btnReload;

//中间文字控件
@property (strong, nonatomic) UILabel *labelText;

//加载中图片控件
@property (strong, nonatomic) UIImageView *imgViewLoading;



#pragma mark 显示加载中界面
-(void)showLoading;
-(void)showLoading:(NSString*)loadingStr;
-(void)showLoading:(NSString*)loadingStr withImg:(UIImage*)img;

#pragma mark 显示空界面
-(void)showEmpty:(NSString*)emptyStr withImg:(UIImage*)img;
-(void)showEmpty:(NSString*)emptyStr;
-(void)showEmpty;

#pragma mark 显示错误界面,如服务器错误,网络错误等界面
-(void)showError:(NSString*)errorStr withImg:(UIImage*)img;
-(void)showError:(NSString*)errorStr;
-(void)showError;

#pragma mark NSError type
- (void)showErrorObj:(NSError*)error withImg:(UIImage*)img;

- (void)showErrorObj:(NSError*)error;

#pragma mark 消失
//这里消失以后loading的view仍然在parentView中，如果需要可自己移除
-(void)dismiss;
-(void)dismiss:(BOOL)anim;

@property (nonatomic, copy) BTLoadingBlock block;

@end
