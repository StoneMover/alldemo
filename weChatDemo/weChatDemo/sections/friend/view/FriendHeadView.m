//
//  FriendHeadView.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendHeadView.h"
#import <BTHelp/UIView+BTViewTool.h>
#import <BTCore/Const.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <BTHelp/UIImage+BTImage.h>

@interface FriendHeadView()

@property (nonatomic, strong) UIImageView * imgViewIcon;

@property (nonatomic, strong) UIImageView * imgViewBg;

@property (nonatomic, strong) UILabel * labelName;

@end


@implementation FriendHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.imgViewBg=[UIImageView new];
    self.imgViewBg.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:self.imgViewBg];
    
    self.imgViewIcon=[[UIImageView alloc] initWithSize:CGSizeMake(55, 55)];
    self.imgViewIcon.backgroundColor=KWhiteColor;
    self.imgViewIcon.borderColor=KLightGray;
    self.imgViewIcon.borderWidth=.5;
    self.imgViewIcon.corner=2;
    [self addSubview:self.imgViewIcon];
    
    self.labelName=[[UILabel alloc] init];
    self.labelName.font=SystemFont(16, UIFontWeightMedium);
    self.labelName.textColor=KWhiteColor;
    
    [self addSubview:self.labelName];
}

- (void)layoutSubviews{
    self.imgViewBg.frame=self.bounds;
    self.imgViewBg.height=self.height-15;
    self.imgViewIcon.right=self.width-35;
    self.imgViewIcon.bottom=self.height;
    
    
    
    self.labelName.right=self.imgViewIcon.left-20;
    self.labelName.centerY=self.imgViewIcon.centerY-5;
}

- (void)setData:(PersonModel*)model{
    self.labelName.text=model.nick;
    [self.labelName sizeToFit];
    [self.imgViewIcon sd_setImageWithURL:URL(model.avatar) placeholderImage:PLACE_HOLDER];
    [self.imgViewBg sd_setImageWithURL:URL(model.profileImage) placeholderImage:[UIImage imageWithColor:KRGBColor(100, 100, 100)]];
    [self setNeedsDisplay];
}

@end
