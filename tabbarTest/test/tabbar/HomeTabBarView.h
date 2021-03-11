//
//  HomeTabBarView.h
//  mingZhong
//
//  Created by apple on 2020/12/28.
//

#import <UIKit/UIKit.h>
#import <BTWidgetView/BTButton.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTabBarViewDelegate <NSObject>

@required

- (void)homeTabBarViewClick:(NSInteger)index;

@end


@interface HomeTabBarView : UIView

@property (nonatomic, strong) NSMutableArray<BTButton*> * btnArray;

@property (nonatomic, weak) id<HomeTabBarViewDelegate>  delegate;

- (void)selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
