//
//  PersonModel.h
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : BTModel

@property (nonatomic) NSString * username;

@property (nonatomic) NSString * nick;

@property (nonatomic) NSString * profileImage;

@property (nonatomic) NSString * avatar;

@end

NS_ASSUME_NONNULL_END
