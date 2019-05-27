//
//  KSYStreamerVC.h
//  KSYStreamerVC
//
//  Created by yiqian on 10/15/15.
//  Copyright (c) 2015 qyvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "KSYUIView.h"
#import "KSYUIVC.h"
#import "KSYPresetCfgView.h"
#import "KSYCtrlView.h"
#import "KSYStreamerVC.h"
#import "KSYFilterView.h"
#import "KSYBgmView.h"
#import "KSYPipView.h"
#import "KSYAudioCtrlView.h"
#import "KSYMiscView.h"
#import "KSYStateLableView.h"
#import "KSYDecalBGView.h"
#import "KSYCollectionView.h"

#import <libksygpulive/KSYGPUStreamerKit.h>

/**
 KSY 推流SDK的主要演示视图
 
 主要演示了SDK 提供的API的基本使用方法
 */
@interface KSYStreamerVC : KSYUIVC

// 切到当前VC后， 界面自动开启推流   /// forTest ///
@property BOOL  bAutoStart;     /// forTest ///

//初始化函数, 通过传入的presetCfgView来配置默认参数

/**
 @abstract   构造函数
 @param      presetCfgView    含有用户配置的启动参数的视图 (前一个页面)
 @discussion presetCfgView 为nil时, 使用默认参数
 */
- (id) initWithCfg:(KSYPresetCfgView*)presetCfgView;
// presetCfgs
@property (nonatomic, readonly) KSYPresetCfgView * presetCfgView;

#pragma mark - sub views
/// 摄像头的基本控制视图
@property (nonatomic, readonly) KSYCtrlView   * ctrlView;
@property (nonatomic, readwrite) NSArray       * menuNames;
/// 背景音乐配置页面
@property (nonatomic, readonly) KSYBgmView    * ksyBgmView;
/// 视频滤镜相关参数配置页面
@property (nonatomic, readonly) KSYFilterView * ksyFilterView;
/// 声音配置页面
@property (nonatomic, readonly) KSYAudioCtrlView * audioView;
/// 其他功能配置页面
@property (nonatomic, readonly) KSYMiscView   *miscView;
//贴纸页面
@property (nonatomic, readonly)KSYCollectionView *colView;
//所有decal添加到该view上
@property (nonatomic, readonly) KSYDecalBGView *decalBGView;

#pragma mark - preview rotation
/// 预览视图父控件（用于处理转屏，保持画面相对手机静止）
@property (nonatomic, strong) UITraitCollection *curCollection;

#pragma mark - kit instance
@property (nonatomic, retain) KSYGPUStreamerKit * kit;
// 适配iphoneX用到的背景视图(在iphoneX上为了保持主播和观众的画面一致, 竖屏时需要上下填一点黑边, 不再全屏预览)
@property (nonatomic, readonly) UIView* bgView;

// 推流地址 完整的URL
@property NSURL * hostURL;
@property NSMutableDictionary *obsDict;

// 采集的参数设置
- (void) setCaptureCfg;
// 推流的参数设置
- (void) setStreamerCfg;

- (void) initObservers;
- (void) addObservers;
- (void) rmObservers;

- (void) addSubViews;
- (void) onMenuBtnPress:(UIButton *)btn;
- (void) onQuit;

- (void) setupLogoRect;

#define SEL_VALUE(SEL_NAME) [NSValue valueWithPointer:@selector(SEL_NAME)]

@end
