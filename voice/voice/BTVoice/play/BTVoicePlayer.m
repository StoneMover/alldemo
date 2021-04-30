//
//  BTVoicePlayer.m
//  road
//
//  Created by stonemover on 2017/6/28.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "BTVoicePlayer.h"

static BTVoicePlayer * selfPlayer;


@interface BTVoicePlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer * player;



@end

@implementation BTVoicePlayer

+(instancetype)share{
    if (!selfPlayer) {
        selfPlayer=[BTVoicePlayer new];
    }
    
    return selfPlayer;
}

-(void)play:(NSString*)url{
    NSError * error=nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSURL * urlResult=[NSURL fileURLWithPath:url];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlResult error:&error];
    self.player.delegate=self;
    self.player.volume=1;
    if ([self.player prepareToPlay]) {
        [self.player play];
    }
}


-(void)stop{
    [self.player stop];
}



#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

@end
