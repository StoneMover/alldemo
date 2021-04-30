//
//  BTVerticalButton.h
//  VoiceBag
//
//  Created by HC－101 on 2018/6/20.
//  Copyright © 2018年 王迅. All rights reserved.
//

#import <UIKit/UIKit.h>




IB_DESIGNABLE

typedef NS_ENUM(NSInteger,BTButtonStyle) {
    BTButtonStyleVertical=0,//垂直，图片在上，文字在下
    BTButtonStyleHoz//水平，图片在右，文字在左
};

@interface BTButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat  verticalValue;

@property (nonatomic, assign) IBInspectable NSInteger style;

@end
