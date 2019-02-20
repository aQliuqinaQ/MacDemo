//
//  VideoPlayController.m
//  MacDemo
//
//  Created by liuqin on 2019/2/13.
//  Copyright © 2019 liuqin. All rights reserved.
//

#import "VideoPlayController.h"
#import "VideoPlayView.h"
@interface VideoPlayController ()<NSSplitViewDelegate,VideoPlayViewDelegate>{
    __weak IBOutlet NSView *_videoPlayBgView;
    __weak IBOutlet NSView *_deviceTreeBgView;
    __weak IBOutlet NSSplitView *_splitView;
    VideoPlayView *_videPlayView;
}

@end

@implementation VideoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_deviceTreeBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@200);
        make.width.greaterThanOrEqualTo(@0);
    }];
    _deviceTreeBgView.wantsLayer = YES;
    _deviceTreeBgView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullWindowClosed:) name:@"fullWindowClosed" object:nil];
}
- (void)viewWillAppear{
    if (_videPlayView == nil) {
        _videPlayView = [[VideoPlayView alloc] initWithFrame:_videoPlayBgView.frame];
        _videPlayView.delegate = self;
        [_videoPlayBgView addSubview:_videPlayView];
        [_videPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_videoPlayBgView);
        }];
        [_videPlayView setViewsWithM:3 N:3];
    }
}
- (IBAction)onClickSplit1:(id)sender {
    [_videPlayView setViewsWithM:1 N:1];
}
- (IBAction)onClickSplit16:(id)sender {
    [_videPlayView setViewsWithM:4 N:4];
}
- (IBAction)onClickSplitMN:(id)sender {
}
- (IBAction)onClick1Big7Small:(id)sender {
}
#pragma mark NSSplitViewDelegate
- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
    return YES;
}

- (void)fullScreen:(NSControlStateValue)state{
    if (state) {
        [self.view.window orderBack:self];
    }else{
        [self.view.window orderFront:self];
    }
    
}
-(void)fullWindowClosed:(NSNotification *)notification{
    VideoPlayView *view = (VideoPlayView *)[notification object];
    [_videoPlayBgView addSubview:view];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_videoPlayBgView);
    }];
    [self.view.window orderFront:self];
    [view setFullScreenItemState:NSControlStateValueOff];
}
- (BOOL)acceptsFirstResponder{
    return YES;
}
- (void)keyDown:(NSEvent *)event{
    NSString *string = [event characters];
    NSLog(@"键盘点击了：%@",string);
}
@end
