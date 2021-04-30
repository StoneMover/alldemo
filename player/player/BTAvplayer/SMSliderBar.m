//
//  SMSliderBar.m
//  Base
//
//  Created by whbt_mac on 15/12/5.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import "SMSliderBar.h"

const int defaultProgressHeight=2;

const int defaultPointWidth=8;

@interface SMSliderBar()

@property(nonatomic,strong)UIView * viewBg;

@property(nonatomic,strong)UIView * viewProgress;

@property(nonatomic,assign)float progressTotalW;

@property(nonatomic,assign) float lastX;

@property(nonatomic,assign) BOOL isTouchDown;//是否已经按下了

@end

@implementation SMSliderBar



-(void)initSelf{
    if (!self.viewPoint) {
        self.viewPoint=[[UIView alloc]initWithFrame:CGRectMake(0, 0, defaultPointWidth, defaultPointWidth)];
        self.viewPoint.layer.cornerRadius=4;
        [self.viewPoint setAlpha:0.99];
        self.viewPoint.backgroundColor=[UIColor lightGrayColor];
    }
    
    self.viewBg=[[UIView alloc]init];
    self.viewProgress=[[UIView alloc]init];
    self.viewBg.userInteractionEnabled=YES;
    [self addSubview:self.viewBg];
    [self addSubview:self.viewProgress];
    [self addSubview:self.viewPoint];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.w=self.frame.size.width;
    self.h=self.frame.size.height;
    
    int startX=self.viewPoint.frame.size.width;
    self.progressTotalW=self.w-2*self.viewPoint.frame.size.width;
    self.viewBg.frame=CGRectMake(startX, self.h/2-defaultProgressHeight/2, self.progressTotalW, defaultProgressHeight);
    self.viewBg.backgroundColor=self.progressBgColor?self.progressBgColor:[UIColor redColor];
    self.viewProgress.frame=CGRectMake(startX, self.h/2-defaultProgressHeight/2, _value*self.progressTotalW, defaultProgressHeight);
    self.viewProgress.backgroundColor=self.progressColor?self.progressColor:[UIColor greenColor];
    self.viewPoint.center=CGPointMake(_value*self.progressTotalW+self.viewPoint.frame.size.width, self.h/2);
}



-(void)layoutSubviewsFirst{
    
}

-(void)setValue:(float)value{
    if (isnan(value)||self.isTouchDown) {
        return;
    }
    _value=value;
    if (_value>1) {
        _value=1;
    }
    if (_value<0) {
        _value=0;
    }
    self.viewPoint.center=CGPointMake(value*self.progressTotalW+self.viewPoint.frame.size.width, self.h/2);
    [self setViewWidth:self.viewProgress withWidth:_value*self.progressTotalW];
}

-(void)setValueSec:(float)value{
    if (isnan(value)) {
        return;
    }
    _value=value;
    if (_value>1) {
        _value=1;
    }
    if (_value<0) {
        _value=0;
    }
    self.viewPoint.center=CGPointMake(value*self.progressTotalW+self.viewPoint.frame.size.width, self.h/2);
    [self setViewWidth:self.viewProgress withWidth:_value*self.progressTotalW];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSliderBarBeginTouch:)]) {
        [self.delegate SMSliderBarBeginTouch:self];
    }
    self.isTouchDown=YES;
    if (self.isTouchBegin) {
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        CGPoint nowPoint = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
        [self calculate:nowPoint];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSliderBar:valueChanged:)]) {
            [self.delegate SMSliderBar:self valueChanged:_value];
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint nowPoint = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
    [self calculate:nowPoint];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSliderBar:valueChanged:)]) {
        [self.delegate SMSliderBar:self valueChanged:_value];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSliderBarEndTouch:)]) {
        [self.delegate SMSliderBarEndTouch:self];
    }
    self.isTouchDown=NO;
}

-(void)calculate:(CGPoint)nowPoint{
    if (self.type==SMSliderTypeHoz) {
        if (fabs(nowPoint.x-self.lastX)>self.changeDistance) {
            float valueNow=(nowPoint.x-self.viewPoint.frame.size.width)/self.progressTotalW;
            if (valueNow>1) {
                valueNow=1;
            }
            if (valueNow<0) {
                valueNow=0;
            }
            [self setValueSec:valueNow];
            self.lastX=nowPoint.x;
        }
        
    }
}

-(void)setViewWidth:(UIView*)view withWidth:(int)width{
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, width,view.frame.size.height);
}

@end
