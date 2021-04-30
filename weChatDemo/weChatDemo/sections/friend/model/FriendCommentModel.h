//
//  FriendCommentModel.h
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTModel.h"
#import "PersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCommentModel : BTModel

@property (nonatomic, strong) PersonModel * sender;

@property (nonatomic, strong) NSString * content;

@property (nonatomic, assign) CGFloat h;

@property (nonatomic, strong) NSMutableAttributedString * resultStr;

@end

NS_ASSUME_NONNULL_END
