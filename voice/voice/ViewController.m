//
//  ViewController.m
//  voice
//
//  Created by stonemover on 2017/8/7.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "ViewController.h"
#import "SMDialogView.h"
#import "BTRecordVoice.h"
#import "BTUtils.h"
#import "BTVoicePlayer.h"


@interface ViewController ()

@property (nonatomic, strong) NSString * oriPath;

@property (nonatomic, strong) NSString * savePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    BTRecordVoice * voiceView=[[BTRecordVoice alloc]init];
    voiceView.maxRecordTime=100;
    voiceView.block = ^(NSString *path, int recordTime) {
        self.oriPath=path;
    };
    SMDialogView * dialogView=[[SMDialogView alloc]initCustomStyle:voiceView];
    [dialogView show:self.view];
}

- (IBAction)convert:(id)sender {
    NSString * mp3Name=[BTUtils getCurrentTime:@"YYYYMMddHHmmss"];
    NSString * mp3Path=[NSString stringWithFormat:@"%@/%@.mp3",[BTUtils getCacheVoice],mp3Name];
    self.savePath=mp3Path;
    [BTRecordVoice convertWavToMp3:self.oriPath withSavePath:mp3Path withBlock:^(NSString *errorInfo) {
        if (!errorInfo) {
            NSLog(@"转化成功!");
        }
    }];
    
}
- (IBAction)play:(id)sender {
    [[BTVoicePlayer share]play:self.savePath];
}
@end
