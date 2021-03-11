//
//  HomeTabBarView.m
//  mingZhong
//
//  Created by apple on 2020/12/28.
//

#import "HomeTabBarView.h"
#import <BTHelp/BTUtils.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import <BTHelp/UIColor+BTColor.h>
#import <BTCore/BTCoreConfig.h>
#import <BTWidgetView/UIView+BTConstraint.h>
#import <BTCore/BTUserMananger.h>


@interface HomeTabBarView()

@property (nonatomic, strong) UIView * rootView;

@property (nonatomic, assign) CGFloat tabbarHeight;

@end


@implementation HomeTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.clearColor;
    self.tabbarHeight = 49;
    [self initBgView];
    [self initBtn];
    return self;
}

- (void)initBgView{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    imgView.image = [UIImage imageNamed:@"tabbar_bg"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.BTBottom = self.tabbarHeight;
    [self addSubview:imgView];
    [imgView bt_addHeight:[BTUtils SCALE_6_W:66.5]];
    [imgView bt_addLeftToParent];
    [imgView bt_addRightToParent];
    [imgView bt_addBottomToParentWithPadding:self.tabbarHeight - BTUtils.TAB_HEIGHT];
    
    if (BTUtils.UI_IS_IPHONEX) {
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, imgView.BTBottom, BTUtils.SCREEN_W, BTUtils.HOME_INDICATOR_HEIGHT)];
        whiteView.translatesAutoresizingMaskIntoConstraints = NO;
        whiteView.backgroundColor = UIColor.whiteColor;
        [self addSubview:whiteView];
        [whiteView bt_addLeftToParent];
        [whiteView bt_addRightToParent];
        [whiteView bt_addBottomToParent];
        [whiteView bt_addHeight:BTUtils.HOME_INDICATOR_HEIGHT];
    }
}

- (void)initBtn{
    NSArray * titles = @[@"首页",
                         @"选股",
                         @"",
                         @"课程",
//                         @"自选",
//                         @"行情",
                         @"我的"];
    NSArray<NSString*> * itemImgNor = @[@"tabbar_home",
                                        @"tabbar_choose",
                                        @"",
                                        @"tabbar_course",
                                        @"tabbar_my",
                                        
//                                        @"tabbar_select",
//                                        @"tabbar_market",
                                        ];
    self.btnArray = [NSMutableArray new];
    CGFloat w = BTUtils.SCREEN_W / 5;
    for (int i=0; i<titles.count; i++) {
        BTButton * btn = [[BTButton alloc] initWithFrame:CGRectMake(i * w, 0, w, self.tabbarHeight)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor bt_RGBSame:51] forState:UIControlStateNormal];
        [btn setTitleColor:BTCoreConfig.share.mainColor forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:itemImgNor[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[itemImgNor[i] stringByAppendingString:@"_sel"]]  forState:UIControlStateSelected];
        btn.margin = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        btn.tag = i;
        [self.btnArray addObject:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self selectIndex:0];
}

- (void)selectIndex:(NSInteger)index{
    
    for (BTButton * btn in self.btnArray) {
        btn.selected = NO;
    }
    self.btnArray[index].selected = YES;
}


- (void)btnClick:(BTButton*)btn{
    if (btn.tag == 2) {
        return;
    }
    
    [self selectIndex:btn.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTabBarViewClick:)]) {
        [self.delegate homeTabBarViewClick:btn.tag];
    }
}

@end
