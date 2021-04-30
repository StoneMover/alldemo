//
//  BaseView.m
//  Base
//
//  Created by whbt_mac on 15/12/28.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import "BaseView.h"

@interface BaseView()



@end

@implementation BaseView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initSelf];
    return self;
}

-(void)layoutSubviews{
    self.w=self.frame.size.width;
    self.h=self.frame.size.height;
    if (self.isNeedFirLayout==0) {
        [self layoutSubviewsFirst];
    }
    
    self.isNeedFirLayout++;
}

-(void)initSelf{
    
}

-(void)layoutSubviewsFirst{
    
}

-(UIView*)getViewFromNib:(NSString*)nibName withOwer:(id)owner{
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil] lastObject];
}



@end
