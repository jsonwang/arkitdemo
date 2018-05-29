//
//  JPARRecord.m
//  AR的录屏demo(有声音)
//
//  Created by LJP on 30/1/18.
//  Copyright © 2018年 poco. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "JPARRecord.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface JPARRecord()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAssetWriter * writer; //负责写的类
@property (nonatomic, strong) AVAssetWriterInput * videoInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor * pixelBufferAdaptor; //输入的缓存
@property (nonatomic, strong) dispatch_queue_t  videoQueue;    //写入的队列
@property (nonatomic, strong) dispatch_queue_t  audioQueue;    //写入的队列

@property (nonatomic, copy)   NSString * videoPath;   //路径
@property (nonatomic, copy)   NSString * audioPath;   //路径
@property (nonatomic, assign) CGSize outputSize;      //输出的分辨率

@property (nonatomic, assign) BOOL isFirstWriter;  //是否是第一次写入

@property (nonatomic, assign) CMTime initialTime;
@property (nonatomic, assign) CMTime currentTime;

@property (nonatomic, strong) CADisplayLink * displayLink;

@property (nonatomic, strong) AVAudioSession * recordingSession;
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;


@end

@implementation JPARRecord

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}


- (void)initData {
    
    // 创建队列
    self.videoQueue = dispatch_queue_create("ljp.video.queue", NULL);
    self.audioQueue = dispatch_queue_create("ljp.audio.queue", NULL);
    
    // 设置输出分辨率
    self.outputSize = CGSizeMake(SCREEN_WIDTH+1, SCREEN_HEIGHT);
    
    // 是否是第一次写入
    self.isFirstWriter = YES;
    
    // 创建SCNRenderer
    self.renderer = [SCNRenderer rendererWithDevice:nil options:nil];
    
    // 清理旧文件
    [self clearPath];
    
}

- (void)clearPath {
    
    self.videoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"video.mp4"];
    self.audioPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"recorder.caf"];
    NSString * output = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"output.mp4"];
    
    //如果有就先清除
    [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.audioPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:output error:nil];
    
}


- (void)startRecording {
    
    //设置存储路径
    self.writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeQuickTimeMovie error:nil];
    
    [self initVideoInPut];
    
    [self initPixelBufferAdaptor];
    
    // 开始写入
    [self.writer startWriting];
    
    self.initialTime = kCMTimeInvalid;
    self.initialTime = [self getCurrentCMTime];
    
    //设置写入时间
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    
    //启动定时器
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink)];
    self.displayLink.preferredFramesPerSecond = 60;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

//先录制视频 录取到第一帧后开始录制音频
- (void)updateDisplayLink {

    dispatch_async(self.videoQueue, ^{
        
        //视频缓存
        CVPixelBufferRef pixelBuffer = [self capturePixelBuffer];
        
        if (pixelBuffer) {
            
            self.currentTime = [self getCurrentCMTime];
            
            if (CMTIME_IS_VALID(self.getCurrentCMTime)) {
                NSLog(@"有效");
            }
            
            CMTime appendTime = [self getAppendTime];
            
            if (CMTIME_IS_VALID(appendTime)) {
                NSLog(@"也有效");
            }
            
            @try {
                
                [self.pixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:appendTime];
                
                CFRelease(pixelBuffer);
                
                if (self.isFirstWriter == YES) {
                    
                    self.isFirstWriter = NO;
                    
                    [self recorderAudio];
                }
                
            } @catch (NSException *exception) {
                NSLog(@"又录不到了~");
            } @finally {
            }
        }
    });
    
}

// 生成CVPixelBufferRef
-(CVPixelBufferRef)capturePixelBuffer {
    
    //从着色器里获取到图片
    CFTimeInterval time = CACurrentMediaTime();
    
    UIImage *image = [self.renderer snapshotAtTime:time withSize:CGSizeMake(self.outputSize.width, self.outputSize.height) antialiasingMode:SCNAntialiasingModeMultisampling4X];
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CVPixelBufferPoolCreatePixelBuffer(NULL, [self.pixelBufferAdaptor pixelBufferPool], &pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    void * data = CVPixelBufferGetBaseAddress(pixelBuffer);
    
    CGContextRef context = CGBitmapContextCreate(data, self.outputSize.width, self.outputSize.height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), CGColorSpaceCreateDeviceRGB(),  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, self.outputSize.width, self.outputSize.height), image.CGImage);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    CGContextRelease(context);
    
    return pixelBuffer;
}

//录制音频
- (void)recorderAudio {
    // 音频
    dispatch_async(self.audioQueue, ^{
        
        self.recordingSession = [AVAudioSession sharedInstance];
        
        [self.recordingSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        
        [self.recordingSession setActive:YES error:NULL];
        
        if (![self.audioRecorder isRecording]) {
            [self.audioRecorder record];
        }
        
    });
}

//结束录制
- (void)endRecording {
    
    [self.audioRecorder stop];
    
    self.displayLink.paused = YES;
    
    self.isFirstWriter = YES;
    
    [self.videoInput markAsFinished];
    
    [self.writer finishWritingWithCompletionHandler:^{
        //合并
        [self merge];
    }];
    
}

- (void)merge {
    
    AVMutableComposition * mixComposition = [[AVMutableComposition alloc]init];
    AVMutableCompositionTrack * mutableCompositionVideoTrack = nil;
    AVMutableCompositionTrack * mutableCompositionAudioTrack = nil;
    AVMutableVideoCompositionInstruction * totalVideoCompositionInstruction = [[AVMutableVideoCompositionInstruction alloc]init];
    
    AVURLAsset * aVideoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.videoPath]];
    AVURLAsset * aAudioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.audioPath]];
    
    mutableCompositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    mutableCompositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    dispatch_semaphore_t videoTrackSynLoadSemaphore;
    videoTrackSynLoadSemaphore = dispatch_semaphore_create(0);
    dispatch_time_t maxVideoLoadTrackTimeConsume = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    [aVideoAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    [aAudioAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    NSArray<AVAssetTrack *> * videoTrackers = [aVideoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (0 >= videoTrackers.count) {
        NSLog(@"VideoTracker获取失败----");
        return;
    }
    NSArray<AVAssetTrack *> * audioTrackers = [aAudioAsset tracksWithMediaType:AVMediaTypeAudio];
    if (0 >= audioTrackers.count) {
        NSLog(@"AudioTracker获取失败");
        return;
    }
    
    AVAssetTrack * aVideoAssetTrack = videoTrackers[0];
    AVAssetTrack * aAudioAssetTrack = audioTrackers[0];
    
    
    [mutableCompositionVideoTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aVideoAssetTrack atTime:kCMTimeZero error:nil];
    [mutableCompositionAudioTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aAudioAssetTrack atTime:kCMTimeZero error:nil];
    
    
    totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration);
    
    AVMutableVideoComposition * mutableVideoComposition = [[AVMutableVideoComposition alloc]init];
    
    mutableVideoComposition.frameDuration = CMTimeMake(1, 60);
    mutableVideoComposition.renderSize = self.outputSize;
    
    NSURL * savePathUrl = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"output.mp4"]];
    
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputFileType = AVFileTypeAppleM4V;
    assetExport.outputURL = savePathUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    self.videoPath = [savePathUrl path];
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        UISaveVideoAtPathToSavedPhotosAlbum(self.videoPath, nil, nil, nil);
        
        [self.delegate endMerge];
        
    }];
    
}

#pragma mark ======================================= 和时间有关的方法 =======================================

- (CMTime)getCurrentCMTime {
    return CMTimeMakeWithSeconds(CACurrentMediaTime(), 1000);
}

- (CMTime)getAppendTime {
    self.currentTime = CMTimeSubtract([self getCurrentCMTime], self.initialTime);
    return self.currentTime;
}

#pragma mark ======================================= 代理方法 =======================================

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"音频错误");
    NSLog(@"error == %@",error);
    
}

#pragma mark ============================ 初始化方法 ============================

- (void)initVideoInPut {
    
    self.videoInput = [[AVAssetWriterInput alloc]
                       initWithMediaType:AVMediaTypeVideo
                       outputSettings   :@{AVVideoCodecKey:AVVideoCodecTypeH264,
                                           AVVideoWidthKey: @(self.outputSize.width),
                                           AVVideoHeightKey: @(self.outputSize.height)}];
    
    if ([self.writer canAddInput:self.videoInput]) {
        [self.writer addInput:self.videoInput];
    }
    
}

- (void)initPixelBufferAdaptor {
    
    self.pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.videoInput sourcePixelBufferAttributes:
                               @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA),
                                 (id)kCVPixelBufferWidthKey:@(self.outputSize.width),
                                 (id)kCVPixelBufferHeightKey:@(self.outputSize.height)}];
    
}

/* 初始化录音器 */
- (AVAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        
        //创建URL
        NSString *filePath = self.audioPath;
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        //设置录音格式
        [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [settings setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [settings setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [settings setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [settings setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        //创建录音器
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:settings
                                                        error:&error];
        if (error) {
            NSLog(@"初始化录音器失败");
            NSLog(@"error == %@",error);
        }
        
        _audioRecorder.delegate = self;//设置代理
        [_audioRecorder prepareToRecord];//为录音准备缓冲区
        
    }
    return _audioRecorder;
}

@end
