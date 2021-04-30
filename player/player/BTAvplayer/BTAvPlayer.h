//
//  BTAvPlayer.h
//  player
//
//  Created by whbt_mac on 16/7/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//  需要导入AVFoundation.framework和MediaPlayer.framework

#import "BaseView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class BTAvPlayer;

@protocol BTAvPlayerDelegate <NSObject>

@optional
//当加载视频出现缓存不够,暂停的情况下调用
-(void)BTAvPlayerBufferEmpty:(BTAvPlayer*)player withBufferProgress:(float)progress;

//加载视频中调用,传入进度和加载速度(暂时不可用)
-(void)BTAvPlayerBuffering:(BTAvPlayer*)player withBufferProgress:(float)progress withSpeed:(float)speed;

//一个视频播放完毕的时候调用
-(void)BTAvPlayerPlayFinish:(BTAvPlayer*)player;

//一个视频播放暂停的时候调用
-(void)BTAvPlayerPlayPause:(BTAvPlayer*)player;

//当视频开始播放的时候调用的方法
-(void)BTAvPlayerStartPlay:(BTAvPlayer*)player;

//当视频播放出错的时候调用方法
-(void)BTAvPlayerStartPlayError:(BTAvPlayer*)player;

//当视频全屏的时候调用
-(void)BTAvPlayerFullScreen:(BTAvPlayer*)player;

//退出全屏的时候调用
-(void)BTAvPlayerNoFullScreen:(BTAvPlayer*)player;

@end

@interface BTAvPlayer : BaseView

@property(nonatomic,strong) NSArray<NSString*> * dataSource;//播放数据源,传入播放路径的数组即可,路径最好全英文,无空格

@property(nonatomic,assign,readonly) int index;//播放下标

@property(nonatomic,weak) id<BTAvPlayerDelegate> delegate;


//播放你所传入的播放下标
-(void)play:(int)index;

//播放当前下标视频,暂停之后再次播放视频
-(void)play;

//播放上一个视频
-(void)playNext;

//播放下一个视频
-(void)playLast;

//全屏
-(void)fullScreen;

//退出全屏
-(void)noFullScreen;

//重新播放
-(void)reStart;

//将播放下表充值为0
-(void)reSetIndex;

//暂停播放
-(void)pause;

@end
