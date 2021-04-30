//
//  FriendModel.h
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTModel.h"
#import "PersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendModel : BTModel

@property (nonatomic, strong) PersonModel * sender;

@property (nonatomic, strong) NSMutableArray * comments;

@property (nonatomic, strong) NSString * error;

@property (nonatomic, strong) NSString * content;

@property (nonatomic, strong) NSMutableArray * images;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat contentH;

@property (nonatomic, assign) CGFloat imgContainerH;

@property (nonatomic, assign) CGFloat imgContainerW;

@property (nonatomic, assign) CGFloat commentH;

- (void)calculate;

@end

NS_ASSUME_NONNULL_END
