//
//  FriendNet.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendNet.h"

@implementation FriendNet

+ (void)getUserInfo:(BTLoadingView*)loadingView
            success:(BTNetSuccessBlcok)success
               fail:(BTNetFailBlock)fail{
    BTHttp * request=[BTHttp share];
    NSString * url =[self getUrl:@"neuron-server-qa/STATIC" functionName:@"jsmith.json"];
    [request GET:url parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [loadingView showErrorObj:error];
    }];
}


+ (void)getFirendInfo:(BTLoadingView*)loadingView
              success:(BTNetSuccessBlcok)success
                 fail:(BTNetFailBlock)fail{
    BTHttp * request=[BTHttp share];
    NSString * url =[self getUrl:@"neuron-server-qa/STATIC" functionName:@"tweets.json"];
    [request GET:url parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [loadingView dismiss];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [loadingView showErrorObj:error];
    }];
}


@end
