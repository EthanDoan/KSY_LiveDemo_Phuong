//
//  KSYStateLableView.m
//  KSYDemo
//
//  Created by pengbin on 16/9/5.
//  Copyright © 2016年 ksyun. All rights reserved.
//

#import "KSYUIVC.h"
#import "KSYStateLableView.h"
#import "KSYPresetCfgView.h"


@interface KSYStateLableView ()

@end

@implementation KSYStateLableView

- (id) init {
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor redColor];
    self.numberOfLines = 9;
    self.textAlignment = NSTextAlignmentLeft;
    [self initStreamStat];
    return self;
}

// 将推流状态信息清0
- (void) initStreamStat{
    memset(&_lastStD, 0, sizeof(_lastStD));
    _startTime  = [[NSDate date]timeIntervalSince1970];
    _notGoodCnt = 0;
    _bwRaiseCnt = 0;
    _bwDropCnt  = 0;
}

- (void) updateState:(KSYStreamerBase*)str {
    KSYStreamerQosInfo *info = [str qosInfo];
    
    StreamState curState = {0};
    curState.timeSecond     = [[NSDate date]timeIntervalSince1970];
    curState.uploadKByte    = [str uploadedKByte];
    curState.encodedFrames  = [str encodedFrames];
    curState.droppedVFrames = [str droppedVideoFrames];
    
    StreamState deltaS  = {0};
    deltaS.timeSecond    = curState.timeSecond    -_lastStD.timeSecond    ;
    deltaS.uploadKByte   = curState.uploadKByte   -_lastStD.uploadKByte   ;
    deltaS.encodedFrames = curState.encodedFrames -_lastStD.encodedFrames ;
    deltaS.droppedVFrames= curState.droppedVFrames-_lastStD.droppedVFrames;
    _lastStD = curState;
    
    double realTKbps   = deltaS.uploadKByte*8 / deltaS.timeSecond;
    double encFps      = deltaS.encodedFrames / deltaS.timeSecond;
    double dropPercent = deltaS.droppedVFrames * 100.0 /MAX(curState.encodedFrames, 1);
    
    NSString* liveTime =[KSYUIVC timeFormatted: (int)(curState.timeSecond-_startTime) ] ;
    NSString *uploadDateSize = [KSYUIVC sizeFormatted:curState.uploadKByte];
    NSString* stateurl  = [NSString stringWithFormat:@"%@\n", [str.hostURL absoluteString]];
    NSString* statekbps = [NSString stringWithFormat:@"Real-time bit rate(kbps)%4.1f\tA%4.1f\tV%4.1f\n", realTKbps, [str encodeAKbps], [str encodeVKbps] ];//实时码率
    NSString* statefps  = [NSString stringWithFormat:@"Real-time frame rate(fps)%2.1f\t总上传:%@\n", encFps, uploadDateSize ];//实时帧率
    NSString* videoqosinfo = [NSString stringWithFormat:@"Video buffering %d B  %d ms  %d packets \n",
                                                    info->videoBufferDataSize, info->videoBufferTimeLength, info->videoBufferPackets];//视频缓冲
    NSString* audioqosinfo = [NSString stringWithFormat:@"Audio buffering %d B  %d ms  %d packets \n",
                                                    info->audioBufferDataSize, info->audioBufferTimeLength, info->audioBufferPackets];//音频缓冲
    NSString* statedrop = [NSString stringWithFormat:@"Video dropped frames %4d\t %2.1f%% \n", curState.droppedVFrames, dropPercent ];//视频丢帧
    NSString* netEvent = [NSString stringWithFormat:@"Network event count %d bad\n\tbw %d Raise %d drop\t fps %d Raise %d drop\n",
                                            _notGoodCnt, _bwRaiseCnt, _bwDropCnt, _fpsRaiseCnt, _fpsDropCnt];//网络事件计数
    NSString *cpu_use = [NSString stringWithFormat:@"%@ \tcpu: %.2f mem: %.1fMB",liveTime, [KSYUIVC cpu_usage], [KSYUIVC memory_usage] ];
    
    self.text = [ stateurl   stringByAppendingString:statekbps ];
    self.text = [ self.text  stringByAppendingString:statefps  ];
    self.text = [ self.text stringByAppendingString:videoqosinfo ];
    self.text = [ self.text stringByAppendingString:audioqosinfo ];
    self.text = [ self.text  stringByAppendingString:statedrop ];
    self.text = [ self.text  stringByAppendingString:netEvent  ];
    self.text = [ self.text  stringByAppendingString:cpu_use  ];
    
}

- (void)drawTextInRect:(CGRect) rect {
    if (self.text == nil){
        return;
    }
    CGFloat oldH = rect.size.height;
    NSAttributedString *attributedText;
    attributedText = [[NSAttributedString alloc] initWithString:self.text
                                                     attributes:@{NSFontAttributeName:self.font}];
    rect.size.height = [attributedText boundingRectWithSize:rect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size.height;
    if (self.numberOfLines != 0) {
        rect.size.height = MIN(rect.size.height, self.numberOfLines * self.font.lineHeight);
    }
    rect.origin.y = oldH - rect.size.height;  // 底部对齐 将一段文字移动到最底部
    [super drawTextInRect:rect];
}
@end
