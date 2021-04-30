//
//  FriendNet.h
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTNet.h"


NS_ASSUME_NONNULL_BEGIN

@interface FriendNet : BTNet

+ (void)getUserInfo:(BTLoadingView*)loadingView
            success:(BTNetSuccessBlcok)success
               fail:(BTNetFailBlock)fail;


+ (void)getFirendInfo:(BTLoadingView*)loadingView
              success:(BTNetSuccessBlcok)success
                 fail:(BTNetFailBlock)fail;

@end

NS_ASSUME_NONNULL_END
