//
//  KSYAudioCtrlView.m
//  KSYGPUStreamerDemo
//
//  Created by 孙健 on 16/6/24.
//  Copyright © 2016年 ksyun. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "KSYPresetCfgView.h"
#import "KSYAudioCtrlView.h"
#import "KSYNameSlider.h"
@interface KSYAudioCtrlView() {
    
}

@property UILabel       * lblPlayCapture;
@property UILabel       * lblMuteSt;
@property UILabel       * lblReverb;
@property UILabel       * lblVPIO;
@property UILabel       * lblStereo;
@end
@implementation KSYAudioCtrlView

- (id)init{
    self = [super init];
    // 混音音量
    _micVol = [self addSliderName:@"Microphone volume" From:0.0 To:2.0 Init:0.9];//麦克风音量
    _bgmVol = [self addSliderName:@"Background music volume"  From:0.0 To:2.0 Init:0.5];//背景乐音量
    _bgmMix = [self addSwitch:YES];


    _micInput = [self addSegCtrlWithItems:@[ @"Built-in mic", @"Headset", @"Bluetooth mic"]];//内置mic", @"耳麦", @"蓝牙mic
    [self initMicInput];
    
    _lblAudioOnly    = [self addLable:@"Pure audio stream"]; // 关闭视频
    _swAudioOnly     = [self addSwitch:NO]; // 关闭视频
    _lblMuteSt       = [self addLable:@"Mute the flow"];//静音推流
    _muteStream      = [self addSwitch:NO];
    
    _lblStereo     = [self addLable:@"Stereo flow"];//立体声推流
    _stereoStream  = [self addSwitch:NO];
    _lblReverb  = [self addLable:@"reverberation"];//混响
    _reverbType = [self addSegCtrlWithItems:@[@"shutdown", @"studio",
                                              @"concert",@"KTV",@"small stage"]];
    _lblPlayCapture = [self addLable:@"ear back"];
    _swPlayCapture  = [self addSwitch:NO];
    _playCapVol= [self addSliderName:@"ear volume"  From:0.0 To:1.0 Init:0.5];
    _effectType  = [self addSegCtrlWithItems:@[@"turn off sound",@"uncle", @"lolita", @"solemn", @"robot"]];
    return self;
}
- (void)layoutUI{
    [super layoutUI];
    self.btnH = 30;

    [self putRow1:_micVol];
    [self putSlider:_bgmVol
          andSwitch:_bgmMix];
    [self putRow1:_micInput];
    [self putLable:_lblReverb andView:_reverbType];
    id nu = [NSNull null];
    [self putRowFit:@[_lblAudioOnly,_swAudioOnly,
                      nu, _lblMuteSt,_muteStream,
                      nu,_lblPlayCapture,_swPlayCapture] ];
    [self putRow1:_playCapVol];
    [self putRow1:_effectType];
    [self putRowFit:@[_lblStereo, _stereoStream]];
}
- (void) initMicInput {
    BOOL bHS = [AVAudioSession isHeadsetInputAvaible];
    BOOL bBT = [AVAudioSession isBluetoothInputAvaible];
    [_micInput setEnabled:YES forSegmentAtIndex:1];
    [_micInput setEnabled:YES forSegmentAtIndex:2];
    if (!bHS){
        [_micInput setEnabled:NO forSegmentAtIndex:1];
    }
    if (!bBT){
        [_micInput setEnabled:NO forSegmentAtIndex:2];
    }
}

static int micType2Int( KSYMicType t) {
    if (t == KSYMicType_builtinMic){
        return 0;
    }
    else if (t == KSYMicType_headsetMic){
        return 1;
    }
    else if (t == KSYMicType_bluetoothMic){
        return 2;
    }
    return 0;
}

static KSYMicType int2MicType( int t) {
    if (t == 0){
        return KSYMicType_builtinMic;
    }
    else if (t == 1){
        return KSYMicType_headsetMic;
    }
    else if (t == 2){
        return KSYMicType_bluetoothMic;
    }
    return KSYMicType_builtinMic;
}

@synthesize  micType = _micType;
- (void) setMicType:(KSYMicType)micType{
    _micType = micType;
    _micInput.selectedSegmentIndex = micType2Int(micType);
}

- (KSYMicType) micType{
    _micType = int2MicType((int)_micInput.selectedSegmentIndex);
    return _micType;
}
@synthesize audioEffect = _audioEffect;
- (void) setAudioEffect:(KSYAudioEffectType)audioEffect {
    _audioEffect = audioEffect;
    if (_audioEffect < 5 ) {
        _effectType.selectedSegmentIndex  = (NSInteger) _audioEffect;
    }
}
- (KSYAudioEffectType) audioEffect {
    _audioEffect =  _effectType.selectedSegmentIndex;
    return _audioEffect;
}
@end
