//
//  BTAvPlayer.m
//  player
//
//  Created by whbt_mac on 16/7/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTAvPlayer.h"
#import "SMSliderBar.h"


const int  defaultSmallToolHeight=42;

const int defaultCanPlayTime=5;//当没有缓存而暂停后,缓存时间减去缓存暂停时间达到多少时可以播放

@interface BTAvPlayer()<SMSliderDelegate,UIGestureRecognizerDelegate>


//@property(nonatomic,strong) UIView * viewBlack;//黑色遮罩层view
@property(nonatomic,assign) BOOL isBuffterEmptyPause;//是否是缓存过少而暂停
@property(nonatomic,assign) BOOL isFullScreen;//是否全屏
@property(nonatomic,assign) BOOL isHideToolBar;//是否隐藏toolBar
@property(nonatomic,assign) BOOL isRePlay;//是否再次播放
@property(nonatomic,assign) CGRect oriRect;//原始的区域
@property(nonatomic,assign) NSTimeInterval buffterEmptyTime;//缓存过少而暂停时候的已缓冲时间
@property(nonatomic,assign) NSTimeInterval lastBufferStartTime;//上次缓存后的总量
@property(nonatomic,assign) NSTimeInterval lastBufferTime;//上次缓存后的时间
@property(nonatomic,assign) float loadSpeed;//加载视频速度
@property(nonatomic,assign) float playCurrentTime;//当前播放的时间
@property(nonatomic,assign) float sizeInKb;//视频大小
@property(nonatomic,assign) float sizeInMB;//视频的大小
@property(nonatomic,strong) AVPlayer * player;//播放器对象
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
@property(nonatomic,strong) UIView * viewContainer;//播放器上层透明view
@property(nonatomic,strong) UIView * viewPlayer;//播放器层view
@property(nonatomic,strong) UIView * viewSmallTool;//当不是全屏的时候的工具栏
@property(nonatomic,strong) id timeObserver;
@property(nonatomic,weak) SMSliderBar * smallBar;//非全屏模式下的进度条
@property(nonatomic,weak) UIActivityIndicatorView * indicatorLoading;
@property(nonatomic,weak) UIButton * btnFull;//全屏按钮
@property(nonatomic,weak) UIButton * btnPlay;//播放按钮
@property(nonatomic,weak) UILabel * labelLoading;
@property(nonatomic,weak) UILabel * labelSmallBarTimeNow;//当前播放时间
@property(nonatomic,weak) UILabel * labelSmallBarTimeTotal;//当前播放时间
@property(nonatomic,weak) UIView * viewLoading;
@property(nonatomic,assign) float totalTime;//视频的总时间


@end

@implementation BTAvPlayer

-(void)initSelf{
    self.viewContainer=[[UIView alloc]init];
    self.viewPlayer=[[UIView alloc]init];
    self.viewSmallTool=[self getViewFromNib:@"BTAvSmallToolView" withOwer:self];
//    self.viewSmallTool.backgroundColor=[UIColor redColor];
    self.viewPlayer.backgroundColor=[UIColor blackColor];
    self.viewPlayer.clipsToBounds=YES;
    [self addSubview:self.viewPlayer];
    [self addSubview:self.viewContainer];
    [self.viewContainer addSubview:self.viewSmallTool];
    [self setSmallToolBar];
    [self initLoadingView];
    [self addPlayerClick];
}


-(void)layoutSubviews{
    if (self.isFullScreen) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }else{
        if (self.isNeedFirLayout>0) {
            self.frame=self.oriRect;
        }
    }
    [super layoutSubviews];
    self.viewContainer.frame=CGRectMake(0, 0, self.w, self.h);
    self.viewPlayer.frame=CGRectMake(0, 0, self.w, self.h);
    if (self.isFullScreen) {
        self.viewSmallTool.frame=CGRectMake(0, self.w-defaultSmallToolHeight, self.h, defaultSmallToolHeight);
        self.viewLoading.frame=CGRectMake(0, 0, 60, 60);
        self.viewLoading.center=CGPointMake(self.h/2, self.w/2);
    }else{
        self.viewSmallTool.frame=CGRectMake(0, self.h-defaultSmallToolHeight, self.w, defaultSmallToolHeight);
        self.viewLoading.frame=CGRectMake(0, 0, 60, 60);
        self.viewLoading.center=CGPointMake(self.w/2, self.h/2);
    }
    
}

-(void)layoutSubviewsFirst{
    self.oriRect=self.frame;
}

/**
 *  @author StoneMover, 16-07-08 16:07:09
 *
 *  @brief 创建播放器层ui
 */
-(void)createPlayUI{
    self.playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.viewPlayer.layer addSublayer:self.playerLayer];
    [self setPlayUIFrame];
}


/**
 *  @author StoneMover, 16-07-08 16:07:58
 *
 *  @brief 设置播放器大小位置
 */
-(void)setPlayUIFrame{
    if (self.isFullScreen) {
        self.playerLayer.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }else{
        
#pragma 解决会在一定特殊布局中播放布局问题
        self.playerLayer.frame=CGRectMake(0, 0, self.oriRect.size.width, self.oriRect.size.height);
#pragma 以前的代码,会在一定特殊布局中播放布局问题
//        self.playerLayer.frame=self.oriRect;
//        NSLog(@"%f;%f;%f;%f",self.playerLayer.frame.origin.x,self.playerLayer.frame.origin.y,self.playerLayer.frame.size.width,self.playerLayer.frame.size.height);
    }
}





/**
 *  播放完成通知
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    [self.btnPlay setImage:[UIImage imageNamed:@"bt_play_btn"] forState:UIControlStateNormal];
    self.smallBar.value=0;
    self.isRePlay=YES;
    self.labelSmallBarTimeNow.text=@"00:00:00";
    [self.player seekToTime:CMTimeMake(0, 1)];
}

#pragma mark create playItem
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    NSString * urlStr=self.dataSource[videoIndex];
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url;
    if ([urlStr hasPrefix:@"http"]) {
        url=[NSURL URLWithString:urlStr];
    }else{
        url=[NSURL fileURLWithPath:urlStr];
    }
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}


/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    [self addProgressObserver:playerItem];
}

/**
 *  @author StoneMover, 16-07-08 14:07:59
 *
 *  @brief 移除kvc监听和广播
 */
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [self removeNotification];
}

/**
 *  @author StoneMover, 16-07-08 15:07:50
 *
 *  @brief 设置player 回调执行的频率,用来显示播放进度
 */
-(void)addProgressObserver:(AVPlayerItem *)item{
    AVPlayerItem *playerItem=item;
    //这里设置每秒执行一次
    __weak BTAvPlayer * weakSelf=self;
    self.timeObserver=[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        weakSelf.playCurrentTime=current;
        weakSelf.smallBar.value=current/total;
        weakSelf.labelSmallBarTimeNow.text=[weakSelf displayTime:[NSString stringWithFormat:@"%f",current].intValue];
        
//        NSLog(@"当前已经播放%f",current);
    }];
}

/**
 *  @author StoneMover, 16-07-08 14:07:45
 *
 *  @brief kvo监听
 *
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            [self readyToPlay:playerItem];
        }else if(status==AVPlayerStatusUnknown){
            [self statusUnknown:playerItem];
        }else if (status==AVPlayerStatusFailed){
            [self statusFailed:playerItem];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        [self loadingBuffter:playerItem];
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if (playerItem.status==AVPlayerStatusReadyToPlay) {
            [self emptyBuffter:playerItem];
        }
        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        [self playBackLikelyToKeepUp:playerItem];
    }else if([keyPath isEqualToString:@"playbackBufferFull"]){
        NSLog(@"%@",@"playbackBufferFull");
    }
}

#pragma mark kvo function
-(void)readyToPlay:(AVPlayerItem*)playerItem{
    self.totalTime=CMTimeGetSeconds(playerItem.duration);
//    CGSize presentationSize=playerItem.presentationSize;
//    AVVideoComposition *videoComposition=playerItem.videoComposition;
    AVAsset * asset=playerItem.asset;//从这里可以得到视频的宽度和高度
//    CGSize size=asset.naturalSize;//得到视频的宽度和高度
//    double total=playerItem.preferredPeakBitRate;
//    CGAffineTransform  transform=set.preferredTransform;
//    NSLog(@"开始播放,视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
    
    //得到视频的大小
    NSArray *tracks = [asset tracks];
    float estimatedSize = 0.0 ;
    for (AVAssetTrack * track in tracks) {
        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
        float seconds = CMTimeGetSeconds([track timeRange].duration);
        estimatedSize += seconds * rate;
    }
    self.sizeInKb = estimatedSize / 1024;
    self.sizeInMB = self.sizeInKb / 1024;
    NSLog(@"视频大小：%fM",self.sizeInMB);
    
    self.labelSmallBarTimeTotal.text=[self displayTime:[NSString stringWithFormat:@"%.2f",CMTimeGetSeconds(playerItem.duration)].intValue];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerStartPlay:)]) {
        [self.delegate BTAvPlayerStartPlay:self];
    }
    [self dismissLoadingView];
    [self.btnPlay setImage:[UIImage imageNamed:@"bt_pause_btn"] forState:UIControlStateNormal];
}

-(void)statusUnknown:(AVPlayerItem*)playerItem{
    NSLog(@"%@",@"AVPlayerStatusUnknown");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerStartPlayError:)]) {
        [self.delegate BTAvPlayerStartPlayError:self];
    }
}

-(void)statusFailed:(AVPlayerItem*)playerItem{
    NSLog(@"%@",@"AVPlayerStatusFailed");
    NSLog(@"%@",playerItem.error.domain);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerStartPlayError:)]) {
        [self.delegate BTAvPlayerStartPlayError:self];
    }
    [self dismissLoadingView];
}

-(void)loadingBuffter:(AVPlayerItem*)playerItem{

    float buffterProgress=[self getTotalBuffer:playerItem];
    NSLog(@"当前加载进度:%f;当前视频总时间:%f",buffterProgress,self.totalTime);
#pragma 获取str的加载速度,不成熟,暂时不用
//    NSString * speed=[self getBuffterLoadingSpeed:self.loadSpeed];
//    self.labelLoading.text=speed;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerBuffering:withBufferProgress:withSpeed:)]) {
        [self.delegate BTAvPlayerBuffering:self withBufferProgress:buffterProgress withSpeed:self.loadSpeed];
    }
    if (self.isBuffterEmptyPause&&buffterProgress-self.buffterEmptyTime>defaultCanPlayTime&&self.player.rate==0) {
        NSLog(@"%@",@"BuffterEmptyPause start play");
        [self play];
    }else if (self.isBuffterEmptyPause&&self.totalTime==buffterProgress&&self.player.rate==0){
        NSLog(@"%@",@"BuffterEmptyPause start play in totalTime==buffterProgress");
        [self play];
    }
    
    
    
//    NSLog(@"%@",@"loading");
//    NSLog(@"缓冲：%.2f",totalBuffer);
//    
//    NSLog(@"%f",event.numberOfBytesTransferred/1024.0/1024.0);
//    NSLog(@"第一个:%f",event.observedBitrate/1024.0);
//    NSLog(@"第二个:%f",event.indicatedBitrate);
    
}


-(void)emptyBuffter:(AVPlayerItem*)playerItem{
    NSLog(@"playbackBufferEmpty");
    [self showLoadingView];
    self.isBuffterEmptyPause=YES;
    self.buffterEmptyTime=[self getTotalBuffer:playerItem];
    [self pause];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerBufferEmpty:withBufferProgress:)]) {
        [self.delegate BTAvPlayerBufferEmpty:self withBufferProgress:[self getTotalBuffer:playerItem]];
    }
    
}

-(void)playBackLikelyToKeepUp:(AVPlayerItem*)playerItem{
    //        if (self.player.rate==0) {
    //            [self.player play];
    //        }
    //        NSLog(@"playbackLikelyToKeepUp");
}

/**
 *  @author StoneMover, 16-07-08 14:07:33
 *
 *  @brief 移除广播通知
 */
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  @author StoneMover, 16-07-08 14:07:26
 *
 *  @brief 全屏模式
 */
-(void)fullScreen{
    if (self.isFullScreen) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerFullScreen:)]) {
        [self.delegate BTAvPlayerFullScreen:self];
    }
    
    self.isFullScreen=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView animateWithDuration:.5 animations:^{
        
        self.viewPlayer.transform=CGAffineTransformMakeRotation(M_PI_2);
        self.viewContainer.transform=CGAffineTransformMakeRotation(M_PI_2);
        if (self.player) {
            [self setPlayUIFrame];
        }
    } completion:^(BOOL finished) {
//        NSLog(@"%@",self.viewSmallTool);
        
//        [self.viewSmallTool setNeedsUpdateConstraints];
    }];
}

/**
 *  @author StoneMover, 16-07-08 14:07:15
 *
 *  @brief 退出全屏
 */
-(void)noFullScreen{
    if (!self.isFullScreen) {
        return;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(BTAvPlayerNoFullScreen:)]) {
        [self.delegate BTAvPlayerNoFullScreen:self];
    }
    
    self.isFullScreen=NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:.5 animations:^{
        self.viewPlayer.transform=CGAffineTransformMakeRotation(0);
        self.viewContainer.transform=CGAffineTransformMakeRotation(0);
        [self setPlayUIFrame];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  @author StoneMover, 16-07-08 14:07:07
 *
 *  @brief 重置播放下标
 */
-(void)reSetIndex{
    _index=0;
}


#pragma mark 播放,暂停相关方法
-(void)play:(int)index{
#pragma 修复无法播放指定下表视频
    _index=index;
    AVPlayerItem * item=[self getPlayItem:self.index];
    
    //这里将所有数据归为初始状态
    self.smallBar.value=0;
    self.labelSmallBarTimeNow.text=[self displayTime:0];
    self.labelSmallBarTimeTotal.text=[self displayTime:0];
    
    if (self.player) {
        [self.player removeTimeObserver:self.timeObserver];
        [self removeObserverFromPlayerItem:_player.currentItem];
        [self addObserverToPlayerItem:item];
#pragma 这是一个耗时操作,如果网络不好,会卡在这一步
        dispatch_async(dispatch_get_main_queue(), ^{
            [_player replaceCurrentItemWithPlayerItem:item];
            if (self.player.rate==0) {
                [self.player play];
            }
        });
        [self showLoadingView];
        return ;
    }else{
        self.player=[AVPlayer playerWithPlayerItem:item];
        [self addObserverToPlayerItem:item];
        [self createPlayUI];
    }
    
    if (self.player.rate==0) {
        [self showLoadingView];
        [self.player play];
    }
}

-(void)play{
    if (!self.player) {
        //第一次调用的时候直接播放第一个资源
        [self play:0];
        [self.btnPlay setImage:[UIImage imageNamed:@"bt_pause_btn"] forState:UIControlStateNormal];
        return;
    }
    
    //在播放完成后isRePlay会被设置成为YES,当播放完成后点击播放按钮则会再次播放该视频
    if (self.isRePlay) {
        self.isRePlay=NO;
        self.isBuffterEmptyPause=NO;
        [self dismissLoadingView];
        [self.player play];
        [self.btnPlay setImage:[UIImage imageNamed:@"bt_pause_btn"] forState:UIControlStateNormal];
        return;
    }
    
    if (self.player.rate==1) {
        [self pause];
    }else if (self.player.rate==0){
        self.isBuffterEmptyPause=NO;
        [self dismissLoadingView];
        [self.player play];
        [self.btnPlay setImage:[UIImage imageNamed:@"bt_pause_btn"] forState:UIControlStateNormal];
    }
    
}

-(void)pause{
    [self.btnPlay setImage:[UIImage imageNamed:@"bt_play_btn"] forState:UIControlStateNormal];
    [self.player pause];
}

-(void)reStart{
    if (self.player&&self.player.rate==0) {
        
        [self.player play];
    }
}

-(void)playNext{
    _index++;
    if (self.index==self.dataSource.count) {
        _index--;
        return;
    }
    [self.player pause];
    [self play:self.index];
}

-(void)playLast{
    _index--;
    if (self.index<0) {
        _index=0;
        return;
    }
    [self.player pause];
    [self play:self.index];
}


#pragma mark toolbar 相关设置
-(void)smallToolBarPlayClick{
    [self play];
}

-(void)smallToolBarPlayFullScreen{
    if (self.isFullScreen) {
        [self.btnFull setImage:[UIImage imageNamed:@"bt_full_btn"] forState:UIControlStateNormal];
        [self noFullScreen];
    }else{
        [self.btnFull setImage:[UIImage imageNamed:@"bt_small_btn"] forState:UIControlStateNormal];
        [self fullScreen];
    }
}

-(void)setSmallToolBar{
    self.btnPlay=[self.viewSmallTool viewWithTag:1];
    [self.btnPlay addTarget:self action:@selector(smallToolBarPlayClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnFull=[self.viewSmallTool viewWithTag:3];
    [self.btnFull addTarget:self action:@selector(smallToolBarPlayFullScreen) forControlEvents:UIControlEventTouchUpInside];
    
    self.smallBar=[self.viewSmallTool viewWithTag:2];
    self.smallBar.delegate=self;
    
    
    
    self.labelSmallBarTimeNow=[self.viewSmallTool viewWithTag:4];
    self.labelSmallBarTimeTotal=[self.viewSmallTool viewWithTag:5];
    
//    self.smallBar.backgroundColor=[UIColor blueColor];
}

-(void)dismissToolBar{
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewSmallTool setAlpha:0.0];
    } completion:^(BOOL finished) {
        if (self.isHideToolBar) {
            self.viewSmallTool.hidden=YES;
        }
    }];
}

-(void)showToolBar{
    self.viewSmallTool.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewSmallTool setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark smslider delegate
-(void)SMSliderBar:(SMSliderBar*)slider valueChanged:(float)value{
    
}

-(void)SMSliderBarEndTouch:(SMSliderBar *)slider{
    if (self.player) {
        [self showLoadingView];
        [self pause];
        NSTimeInterval nowTime=CMTimeGetSeconds(self.player.currentItem.duration)*slider.value;
        
        //        NSTimeInterval result=abs(self.playCurrentTime)
        self.isBuffterEmptyPause=YES;
        [self.player seekToTime:CMTimeMake(nowTime, 1) completionHandler:^(BOOL finished) {
            self.buffterEmptyTime=CMTimeGetSeconds(self.player.currentItem.currentTime);
            NSLog(@"%f",self.buffterEmptyTime);
//            [self play];
        }];
    }
}

-(void)SMSliderBarBeginTouch:(SMSliderBar *)slider{
    
    
}

#pragma mark 相关辅助方法
-(NSString*)displayTime:(int)timeInterval{
    NSString * time=@"";
    
    int seconds = timeInterval % 60;
    int minutes = (timeInterval / 60) % 60;
    int hours = timeInterval / 3600;
    
    NSString * secondsStr=seconds<10?[NSString stringWithFormat:@"%@%d",@"0",seconds]:[NSString stringWithFormat:@"%d",seconds];
    NSString * minutesStr=minutes<10?[NSString stringWithFormat:@"%@%d",@"0",minutes]:[NSString stringWithFormat:@"%d",minutes];
    NSString * hoursStr=hours<10?[NSString stringWithFormat:@"%@%d",@"0",hours]:[NSString stringWithFormat:@"%d",hours];
    
    time=[NSString stringWithFormat:@"%@%@%@%@%@",hoursStr,@":",minutesStr,@":",secondsStr];
    
    return time;
}

-(double)getTotalBuffer:(AVPlayerItem*)playerItem{
    NSArray *array=playerItem.loadedTimeRanges;
//    NSLog(@"%lu",(unsigned long)array.count);
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    float loadDurationTimeNow;
    if (self.lastBufferStartTime!=startSeconds) {
        loadDurationTimeNow=durationSeconds;
        self.lastBufferStartTime=startSeconds;
    }else{
        loadDurationTimeNow=durationSeconds-self.lastBufferTime;
    }
    if(self.lastBufferTime!=0){
        self.loadSpeed=self.sizeInKb * (loadDurationTimeNow/self.totalTime);
    }
    self.lastBufferTime=durationSeconds;
    
    self.lastBufferStartTime=startSeconds;
    
    NSTimeInterval totalBuffer = startSeconds + durationSeconds;//已经缓冲的总时间
//    NSLog(@"缓存了:%f;startSeconds:%f;durationSeconds:%f;speed:%f",totalBuffer,startSeconds,durationSeconds,self.loadSpeed);
    [self getBuffterLoadingSpeedF:playerItem with:durationSeconds];
    return totalBuffer;
}




-(NSString*)getBuffterLoadingSpeed:(float)speed{
   
    NSString * str=[NSString stringWithFormat:@"%d",(int)speed];
    if (speed>1024) {
        str=[NSString stringWithFormat:@"%.1fM/S",speed/1024.0];
    }else{
        str=[str stringByAppendingString:@"K/S"];
    }
    
    
    return str;
}

-(float)getBuffterLoadingSpeedF:(AVPlayerItem*)playerItem with:(float)time{
    AVPlayerItemAccessLog * log=playerItem.accessLog;
    NSArray * events=log.events;
    AVPlayerItemAccessLogEvent * event=[events firstObject];
    
//    NSLog(@"传输了:%lld",event.numberOfBytesTransferred/1024);
//    NSLog(@"%f",event.transferDuration);
    return event.numberOfBytesTransferred/1024.0/time;
}


#pragma mark 相关手势方法
-(void)addPlayerClick{
    //单机手势监听
    UITapGestureRecognizer * tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreenSingleTap:)];
    tapGes.numberOfTapsRequired=1;
    tapGes.delegate=self;
    [self.viewContainer addGestureRecognizer:tapGes];
    
    //双击手势监听
    UITapGestureRecognizer * tapGesDouble=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreenDoubleTap)];
    tapGesDouble.numberOfTapsRequired=2;
    [self.viewContainer addGestureRecognizer:tapGesDouble];
    
    //双击手势确定监测失败才会触发单击手势的相应操作
    [tapGes requireGestureRecognizerToFail:tapGesDouble];
}

-(void)fullScreenSingleTap:(UITapGestureRecognizer*)recognizer{
    self.isHideToolBar=!self.isHideToolBar;
    if (self.isHideToolBar) {
        [self dismissToolBar];
    }else{
        [self showToolBar];
    }
    
}

-(void)fullScreenDoubleTap{
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([[touch.view superview] isKindOfClass:[SMSliderBar class]]||touch.view==self.smallBar)
        return NO;
    else
        return YES;
}



#pragma mark loadingView
-(void)initLoadingView{
    self.viewLoading=[self getViewFromNib:@"BTAvLoadingView" withOwer:self];
    self.labelLoading=[self.viewLoading viewWithTag:1];
    self.labelLoading.text=@"loading...";
    self.indicatorLoading=[self.viewLoading viewWithTag:2];
    self.viewLoading.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    self.viewLoading.layer.cornerRadius=10;
    self.viewLoading.hidden=YES;
    [self.indicatorLoading startAnimating];
    [self.viewContainer addSubview:self.viewLoading];
}

-(void)showLoadingView{
    self.viewLoading.hidden=NO;
    [self.indicatorLoading startAnimating];
}

-(void)dismissLoadingView{
    self.viewLoading.hidden=YES;
    [self.indicatorLoading stopAnimating];
}





-(void)dealloc{
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self.player removeTimeObserver:self.timeObserver];
}



@end
