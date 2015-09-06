//
//  SpeexViewController.m
//  speex
//
//  Created by guange on 09/06/2015.
//  Copyright (c) 2015 guange. All rights reserved.
//

#import "SpeexViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"

@interface SpeexViewController ()<RecordingDelegate, PlayingDelegate>

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *filename;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation SpeexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.recordBtn addTarget:self action:@selector(Record) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(Play) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Record {
    if (self.isPlaying) {
        return;
    }
    if ( ! self.isRecording) {
        self.isRecording = YES;
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
    }
    else {
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
    }
}


-(void)Play {
    if (self.isRecording) {
        return;
    }
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        NSString *msg = [NSString stringWithFormat:@"正在播放: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
        NSLog(msg);
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}


#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    self.filename = filePath;
   
}

- (void)recordingTimeout {
    self.isRecording = NO;
    NSLog(@"录音超时");
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    NSLog(@"录音失败");
}

- (void)levelMeterChanged:(float)levelMeter {
}

- (void)playingStoped {
    self.isPlaying = NO;
    NSString *msg = [NSString stringWithFormat:@"播放完成: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
    NSLog(msg);
}


@end
