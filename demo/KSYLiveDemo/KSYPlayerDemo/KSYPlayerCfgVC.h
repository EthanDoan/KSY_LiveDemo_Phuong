//
//  KSYPlayerCfgVC.h
//  KSYPlayerDemo
//
//  Created by zhengWei on 2017/4/17.
//  Copyright © 2017年 kingsoft. All rights reserved.
//
#import "KSYUIVC.h"
#import <libksygpulive/KSYMoviePlayerController.h>

@interface KSYPlayerCfgVC : KSYUIVC

- (instancetype)initWithURL:(NSURL *)url fileList:(NSArray *)fileList;

@property (nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSArray *fileList;
//解码模式/Decoding mode
@property(nonatomic, assign) MPMovieVideoDecoderMode decodeMode;
//填充模式/Fill mode
@property(nonatomic, assign) MPMovieScalingMode contentMode;
//自动播放/Autoplay

@property(nonatomic, assign) BOOL bAutoPlay;
//反交错模式/Antiparallel pattern
@property(nonatomic, assign) MPMovieVideoDeinterlaceMode deinterlaceMode;
//音频打断模式/Audio interrupt mode
@property(nonatomic, assign) BOOL bAudioInterrupt;
//循环播放/Loop
@property(nonatomic, assign)  BOOL bLoop;
//连接超时/Connection timed out
@property(nonatomic, assign) int connectTimeout;
//读超时/Read overtime
@property(nonatomic, assign) int readTimeout;
//
@property(nonatomic, assign) double bufferTimeMax;
//
@property(nonatomic, assign) int bufferSizeMax;

@end
