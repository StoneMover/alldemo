//
//  BTVoicePlayer.h
//  road
//
//  Created by stonemover on 2017/6/28.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@interface BTVoicePlayer : NSObject

+(instancetype)share;

-(void)play:(NSString*)url;
-(void)stop;

@end
