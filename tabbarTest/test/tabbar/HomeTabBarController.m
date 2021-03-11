//
//  HomeTabBarController.m
//  mingZhong
//
//  Created by apple on 2020/12/28.
//

#import "HomeTabBarController.h"
#import <BTHelp/UIImage+BTImage.h>
#import <BTCore/BTCoreConfig.h>
#import "HomeTabBarView.h"
#import <BTHelp/BTUtils.h>
#import <BTWidgetView/BTButton.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import <BTCore/BTViewController.h>
#import "ChildVC.h"

@interface HomeTabBarController ()<UITabBarControllerDelegate,HomeTabBarViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) HomeTabBarView * tabbarView;

@property (nonatomic, strong) BTButton * giftBtn;

@property (nonatomic, strong) BTButton * lockBtn;

@property (nonatomic, assign) BOOL isShowTabbar;

@property (nonatomic, assign) CGFloat initBottomValue;

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.delegate = self;
    self.isShowTabbar = YES;
    
    _tabbarVc = [[NSMutableArray alloc] initWithObjects:
                 [ChildVC new],
                 [ChildVC new],
                 [ChildVC new],
                 [ChildVC new],
                 [ChildVC new],
                 
//                 [BTUtils createVc:@"select" storyBoardName:@"Main"],
//                 [BTUtils createVc:@"market" storyBoardName:@"Main"],
                 
                 nil];
    
    NSMutableArray * controllers = [NSMutableArray new];
    for (UIViewController * vc in _tabbarVc) {
        BTNavigationController * nav = [[BTNavigationController alloc] initWithRootViewController:vc];
        nav.delegate = self;
        [controllers addObject:nav];
    }
    
    self.viewControllers = controllers;
    self.tabbarView = [[HomeTabBarView alloc] initWithFrame:CGRectMake(0, BTUtils.SCREEN_H - BTUtils.TAB_HEIGHT, BTUtils.SCREEN_W, BTUtils.TAB_HEIGHT)];
    self.tabbarView.delegate = self;
    [self.view addSubview:self.tabbarView];
    
    [self initBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideTabbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self isCurrentNavInRootVc]) {
        [self showTabbar];
    }
}

- (void)initBtn{
    self.giftBtn = [[BTButton alloc] initWithFrame:CGRectMake(0, 0, [BTUtils SCALE_6_W:52], [BTUtils SCALE_6_W:52])];
    [self.giftBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_btn_bg"] forState:UIControlStateNormal];
    [self.giftBtn setTitle:@"福袋" forState:UIControlStateNormal];
    [self.giftBtn setImage:[UIImage imageNamed:@"tabbar_gift"] forState:UIControlStateNormal];
    self.giftBtn.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    self.giftBtn.margin = 3;
    [self.view addSubview:self.giftBtn];
    [self.giftBtn setBTCenterParentX];
    self.initBottomValue = BTUtils.SCREEN_H - BTUtils.TAB_HEIGHT + 20;
    self.giftBtn.BTBottom = self.initBottomValue;
//    [self.giftBtn addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftClick)];
    [self.giftBtn addGestureRecognizer:tap];
    
    [self startBtnAnim];
}




- (void)startBtnAnim{
    if (self.giftBtn.layer.animationKeys != nil) {
        return;
    }
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.giftBtn.BTBottom = self.initBottomValue + 20;
    } completion:nil];
}

- (void)endBtnAnim{
    if (self.giftBtn.layer.animationKeys == nil) {
        return;
    }
    [self.giftBtn.layer removeAllAnimations];
    self.giftBtn.BTBottom = self.initBottomValue;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    [self.tabbarView selectIndex:selectedIndex];
}

#pragma mark 通知
- (void)applicationWillResignActive{
    [self endBtnAnim];
}

- (void)applicationDidBecomeActive{
    if ([self.selectedViewController isKindOfClass:[BTNavigationController class]]) {
        BTNavigationController * nav = (BTNavigationController*)self.selectedViewController;
        if (nav.viewControllers.count == 1) {
            [self startBtnAnim];
        }
    }
}



#pragma mark HomeTabBarViewDelegate
- (void)homeTabBarViewClick:(NSInteger)index{
    self.selectedIndex = index;
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([tabBarController.viewControllers indexOfObject:viewController] == 2) {
        return NO;
    }
    
    return YES;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.tabbarVc containsObject:viewController]) {
        [self showTabbar];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (![self.tabbarVc containsObject:viewController]) {
        [self hideTabbar];
    }
}

#pragma mark 全屏旋转相关


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark 相关方法
- (void)hideTabbar{
    if (!self.isShowTabbar) {
        return;
    }
    self.isShowTabbar = NO;
    self.tabbarView.clipsToBounds = YES;
    [self endBtnAnim];
    [UIView animateWithDuration:0.25 animations:^{
        self.tabbarView.BTTop = BTUtils.SCREEN_H;
        self.giftBtn.BTTop = BTUtils.SCREEN_H;
    }];
}

- (void)showTabbar{
    if (self.isShowTabbar) {
        return;
    }
    self.tabbarView.clipsToBounds = NO;
    self.isShowTabbar = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabbarView.BTTop = BTUtils.SCREEN_H - BTUtils.TAB_HEIGHT;
        self.giftBtn.BTBottom = BTUtils.SCREEN_H - BTUtils.TAB_HEIGHT + 20;
    } completion:^(BOOL finished) {
        if ([self isCurrentNavInRootVc]) {
            [self startBtnAnim];
        }
        
    }];
}

- (void)giftClick{
    
    
    
}

- (BOOL)isCurrentNavInRootVc{
    if ([self.selectedViewController isKindOfClass:[BTNavigationController class]]) {
        BTNavigationController * nav = (BTNavigationController*)self.selectedViewController;
        if (nav.viewControllers.count == 1) {
            return YES;
        }
    }
    
    return NO;
}


@end
