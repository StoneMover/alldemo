//
//  SMListDialogView.m
//  Base
//
//  Created by whbt_mac on 16/1/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "SMDialogView.h"
#import "SMListDialogTableViewCell.h"

int const TABLEVIEW_MAX_HEIGHT=300;//tableview 最高的高度

int const TABLEVIEW_LEF_RIGHT_PADDING=30;//tableview 左右两边的距离

int const TABLEVIEW_CELL_DEFAULT_HEIGHT=44;//tableview cell 默认高度

int const HEAD_VIEW_HEIGHT=45;//headview 的高度

@interface SMDialogView()<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) UITableView * tableView;

@property(strong, nonatomic) UIButton * btnCancel;//取消按钮


@property(strong, nonatomic) UIView * headView;//头部view

@property(strong, nonatomic) UILabel * labelTitle;//头部label

@property(strong, nonatomic) UIImageView * imgViewLine;//头部分割线

@property (nonatomic, strong) UIButton * headCloseBtn;//头部关闭按钮

@property(assign, nonatomic) BOOL isAddParentView;//是否已经添加入parentView

@property(strong, nonatomic) UIView * viewParent;//用来放tableView和headView的父容器

@property(strong, nonatomic) UIButton * btnBg;//用来监听点击消失手势的按钮

@property(strong, nonatomic) UIView * bgBlackColor;//透明的黑色

@property (nonatomic,assign) SMDialogAnimStyle animStyle;//动画样式

@property (nonatomic,assign) SMDialogModel model;//展现样式

@property (nonatomic, assign) SMDialogLocation location;//位置对象

@property (nonatomic, assign) SMDialogListStyle listStyle;//列表风格

@property (nonatomic, assign) BOOL isLayoutShow;

@property (nonatomic, assign) CGRect customeViewFrame;//自定义view的frame

@end

@implementation SMDialogView

#pragma mark 初始化方法
-(instancetype)initListStyle{
    return [self initListStyle:SMDialogLocationCenter withStyle:SMDialogListStyleNormal];
}


-(instancetype)initListStyle:(SMDialogLocation)location withStyle:(SMDialogListStyle)style{
    self=[super init];
    self.location=location;
    self.listStyle=style;
    self.model=SMListDialoglList;
    [self initDialog];
    [self initTableView];
    [self initListStyleHead];
    return self;
}

-(instancetype)initCustomStyle:(UIView*)view withLocation:(SMDialogLocation)location{
    self=[super init];
    self.location=location;
    self.viewParent=view;
    self.model=SMDialogCustom;
    [self initDialog];
    self.customeViewFrame=view.frame;
    return self;
}

-(instancetype)initCustomStyle:(UIView*)view{
    return [self initCustomStyle:view withLocation:SMDialogLocationCenter];
}

//初始化弹框
-(void)initDialog{
    //设置颜色背景
    self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.clickEmptyAreaDismiss=YES;
    
    //设置透明层
    self.bgBlackColor=[[UIView alloc]init];
    self.bgBlackColor.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    [self.bgBlackColor setAlpha:0];
    [self addSubview:self.bgBlackColor];
    
    //设置消失点击按钮
    self.btnBg=[[UIButton alloc]init];
    [self.btnBg addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnBg];
    
    //设置tableView parent
    if (_model==SMListDialoglList) self.viewParent=[[UIView alloc]init];
    
    self.viewParent.clipsToBounds=YES;
    [self.viewParent setAlpha:0];
    if (!self.isNoCorner) self.viewParent.layer.cornerRadius=5;
    [self addSubview:self.viewParent];
}

//设置tableView头部view
-(void)initListStyleHead{
    if (self.location==SMDialogLocationTop)return;
    self.headView=[[UIView alloc]init];
    self.headView.backgroundColor=[UIColor whiteColor];
    self.labelTitle=[[UILabel alloc]init];
    self.headCloseBtn=[[UIButton alloc]init];
    [self.headCloseBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headCloseBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.imgViewLine=[[UIImageView alloc]init];
    
    [self.headView addSubview:self.headCloseBtn];
    self.imgViewLine=[[UIImageView alloc]init];
    [self.headView addSubview:self.labelTitle];
    [self.headView addSubview:self.imgViewLine];
    [self.viewParent addSubview:self.headView];
    
}
//初始化tableView
-(void)initTableView{
    self.tableView=[[UITableView alloc]init];
    [self.viewParent addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMListDialogTableViewCell" bundle:nil] forCellReuseIdentifier:@"smlistdialogcell"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}



-(void)layoutSubviewsFirst{
    [super layoutSubviewsFirst];
    self.bgBlackColor.frame=CGRectMake(0, 0, self.w, self.h);
    self.btnBg.frame=CGRectMake(0, 0, self.w, self.h);
    
    int parentWidth=0;
    int parentHeight=0;
    int parentX=0;
    int parentY=0;
    
    switch (self.location) {
        case SMDialogLocationCenter:{
            if (_model==SMDialogCustom) {
                parentWidth=self.w-TABLEVIEW_LEF_RIGHT_PADDING*2;
                parentHeight=parentHeight=self.customeViewFrame.size.height;
            }else if (_model==SMListDialoglList){
                [self layoutListStyleHead];
                int height=(int)self.data.count*TABLEVIEW_CELL_DEFAULT_HEIGHT;
                height=height>TABLEVIEW_MAX_HEIGHT?TABLEVIEW_MAX_HEIGHT:height;
                self.tableView.frame=CGRectMake(0, HEAD_VIEW_HEIGHT, self.w-TABLEVIEW_LEF_RIGHT_PADDING*2, height);
                parentWidth=self.tableView.frame.size.width;
                parentHeight=self.tableView.frame.size.height+self.headView.frame.size.height;
            }
            self.viewParent.frame=CGRectMake(parentX, parentY, parentWidth, parentHeight);
            self.viewParent.center=CGPointMake(self.w/2, self.h/2);
        }
            
            break;
        case SMDialogLocationTop:
            parentWidth=self.w;
            parentHeight=self.model==SMDialogCustom?self.customeViewFrame.size.height:TABLEVIEW_MAX_HEIGHT;
            parentY=-parentHeight;
            self.viewParent.frame=CGRectMake(parentX, parentY, parentWidth, parentHeight);
            self.tableView.frame=self.viewParent.bounds;
            break;
        case SMDialogLocationBottom:
            if (_model==SMDialogCustom) {
                parentWidth=self.w;
                parentHeight=self.customeViewFrame.size.height;
                parentY=self.h;
            }else{
                [self layoutListStyleHead];
                int height=TABLEVIEW_MAX_HEIGHT-30;
                self.tableView.frame=CGRectMake(0, HEAD_VIEW_HEIGHT, self.w, height);
                parentWidth=self.tableView.frame.size.width;
                parentHeight=self.tableView.frame.size.height+self.headView.frame.size.height;
                parentY=self.h;
            }
            
            self.viewParent.frame=CGRectMake(parentX, parentY, parentWidth, parentHeight);
            break;
    }
    
    if (self.isLayoutShow){
        self.isLayoutShow=NO;
        [self show:[self superview] withAnimStyle:self.animStyle];
    }
    
}

-(void)layoutListStyleHead{
    int width=self.w;
    if (self.location==SMDialogLocationCenter) {
        width=self.w-TABLEVIEW_LEF_RIGHT_PADDING*2;
    }
    self.headView.frame=CGRectMake(0, 0, width, HEAD_VIEW_HEIGHT);
    self.labelTitle.frame=CGRectMake(18, 0, self.headView.frame.size.width-HEAD_VIEW_HEIGHT-18, HEAD_VIEW_HEIGHT-1);
    self.imgViewLine.frame=CGRectMake(0, HEAD_VIEW_HEIGHT-1, self.headView.frame.size.width, 1);
    self.headCloseBtn.frame=CGRectMake([self getViewW:self.headView]-HEAD_VIEW_HEIGHT, 0, HEAD_VIEW_HEIGHT, HEAD_VIEW_HEIGHT);
    self.headCloseBtn.imageEdgeInsets=UIEdgeInsetsMake(13, 13, 13, 13);
    
}




#pragma mark show & dismiss & destory
-(void)show:(UIView *)view{
    [self show:view withAnimStyle:SMDialogAnimStyleDefault];
}

-(void)show:(UIView *)view withAnimStyle:(SMDialogAnimStyle)style{
    if (self.isNeedFirLayout==0) {
        self.hidden=NO;
        if (!self.isAddParentView) {
            [view addSubview:self];
            self.isAddParentView=YES;
            self.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        }
        self.viewParent.frame=CGRectMake(self.viewParent.frame.origin.x, self.viewParent.frame.origin.y, 0, 0);
        self.isLayoutShow=YES;
        return;
    }
    
    
    self.animStyle=style;
    
    switch (self.location) {
        case SMDialogLocationCenter:
            [self centerLocationShowAnim];
            break;
        case SMDialogLocationTop:
            [self topLocationShowAnim];
            break;
        case SMDialogLocationBottom:
            [self bottomLocationShowAnim];
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark 显示动画
-(void)centerLocationShowAnim{
    
    switch (self.animStyle) {
        case SMDialogAnimStyleAndroid:{
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.bgBlackColor setAlpha:0.65];
                [self.viewParent setAlpha:1];
            } completion:^(BOOL finished) {
                
            }];
            
            self.viewParent.transform = CGAffineTransformMakeScale(0.55f, 0.55f);//将要显示的view按照正常比例显示出来
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
            [UIView setAnimationDuration:0.25f];//动画时间
            self.viewParent.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
            [UIView commitAnimations];
        }
            
            break;
        case SMDialogAnimStyleDefault:{
            self.viewParent.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [UIView animateWithDuration:0.2 animations:^{
                self.viewParent.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.viewParent.alpha = 1;
                self.bgBlackColor.alpha = 0.4;
            }];
        }
            
            break;
            
        default:
            break;
    }
    
    
}
-(void)topLocationShowAnim{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgBlackColor setAlpha:0.65];
        [self.viewParent setAlpha:1];
        self.viewParent.frame=CGRectMake([self getViewX:self.viewParent], 0, [self getViewW:self.viewParent], [self getViewH:self.viewParent]);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)bottomLocationShowAnim{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgBlackColor setAlpha:0.65];
        [self.viewParent setAlpha:1];
        self.viewParent.frame=CGRectMake([self getViewX:self.viewParent], self.h-[self getViewH:self.viewParent], [self getViewW:self.viewParent], [self getViewH:self.viewParent]);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 消失动画
-(void)dismiss{
    switch (self.location) {
        case SMDialogLocationCenter:
            [self dismissCenterAnim];
            break;
        case SMDialogLocationTop:
            [self dismissTopAnim];
            break;
        case SMDialogLocationBottom:
            [self dismissBottomAnim];
            break;
            
        default:
            break;
    }
    
}

-(void)dismissCenterAnim{
    switch (self.animStyle) {
        case SMDialogAnimStyleDefault:
        {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewParent.alpha = 0;
                self.bgBlackColor.alpha = 0;
            }completion:^(BOOL finished){
                self.hidden=YES;
                [self destory];
            }];
        }
            break;
        case SMDialogAnimStyleAndroid:{
            self.viewParent.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
            [UIView setAnimationDuration:0.25f];//动画时间
            self.viewParent.transform=CGAffineTransformMakeScale(0.7f, 0.7f);//先让要显示的view最小直至消失
            [UIView commitAnimations];
            
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.bgBlackColor setAlpha:0];
                [self.viewParent setAlpha:0];
            } completion:^(BOOL finished) {
                self.hidden=YES;
                [self destory];
            }];
        }
            
        default:
            break;
    }
}
-(void)dismissTopAnim{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewParent.alpha = 0;
        self.bgBlackColor.alpha = 0;
        self.viewParent.frame=CGRectMake([self getViewX:self.viewParent], -[self getViewH:self.viewParent], [self getViewW:self.viewParent], [self getViewH:self.viewParent]);
    } completion:^(BOOL finished) {
        self.hidden=YES;
        [self destory];
    }];
}

-(void)dismissBottomAnim{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewParent.alpha = 0;
        self.bgBlackColor.alpha = 0;
        self.viewParent.frame=CGRectMake([self getViewX:self.viewParent], self.h, [self getViewW:self.viewParent], [self getViewH:self.viewParent]);
    } completion:^(BOOL finished) {
        self.hidden=YES;
        [self destory];
    }];
}


#pragma mark 销毁
-(void)destory{
    self.isAddParentView=NO;
    if (self.model==SMDialogCustom) {
        [self.viewParent removeFromSuperview];
        self.viewParent=nil;
    }
    [self removeFromSuperview];
}

#pragma mark tableView delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMListDialogTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"smlistdialogcell"];
    SMListDialogItem * item=self.data[indexPath.row];
    cell.label.text=item.title;
    if (self.listStyle==SMDialogListStyleSingleSelect) {
        cell.imgViewSelect.hidden=!item.isSelect;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLEVIEW_CELL_DEFAULT_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isHasDismiss=NO;
    
    if (self.listStyle==SMDialogListStyleSingleSelect) {
        //执行选中项
        for (SMListDialogItem * item in self.data) {
            if (item.isSelect) {
                item.isSelect=NO;
            }
        }
        
        self.data[indexPath.row].isSelect=YES;
        [self.tableView reloadData];
    }
    
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMListDialog:selectIndex:withData:)]) {
        if ([self.delegate SMListDialog:self selectIndex:(int)indexPath.row withData:self.data]) {
            isHasDismiss=YES;
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
        }
    }
    
    if (self.block) {
        if (self.block(self,(int)indexPath.row,self.data)&&!isHasDismiss) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
        }
    }
}


#pragma mark 辅助性方法

-(void)btnClick{
    if (self.clickEmptyAreaDismiss)[self dismiss];
}



-(CGFloat)getViewX:(UIView*)view{
    return view.frame.origin.x;
}

-(CGFloat)getViewY:(UIView*)view{
    return view.frame.origin.y;
}

-(CGFloat)getViewW:(UIView*)view{
    return view.frame.size.width;
}

-(CGFloat)getViewH:(UIView*)view{
    return view.frame.size.height;
}


#pragma mark set function
-(void)setIsNoCorner:(BOOL)isNoCorner{
    _isNoCorner=isNoCorner;
    self.viewParent.layer.cornerRadius=0;
}

-(void)setTableHeadConfig:(NSString*)title withTitleColor:(UIColor*)titleColor withDiverColor:(UIColor*)diverColor{
    self.labelTitle.text=title;
    self.labelTitle.textColor=titleColor;
    self.imgViewLine.backgroundColor=diverColor;
}

@end
