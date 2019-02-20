//
//  VideoPlayView.m
//  MacDemo
//
//  Created by liuqin on 2019/2/13.
//  Copyright © 2019 liuqin. All rights reserved.
//

#import "VideoPlayView.h"
#import "VideoPlayFullWindow.h"
@implementation VideoPlayView{
    BOOL _isDrag;
    NSImageView *_dragStartIV;
    NSImageView *_dragEndIV;
    NSImageView *_rightSelectedView;
    NSMutableArray *_imageViewArr;
    int _im;
    int _in;
    int _showCount;
    double _clickTime;
    VideoPlayFullWindow *_newWindow;
    NSMenuItem *fullScreenItem;
}
- (id)initWithFrame:(NSRect)frameRect{
    if(self = [super initWithFrame:frameRect]){
        _imageViewArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self resetFrame];
}
- (BOOL)isFlipped{
    return YES;
}
-(void)setViewsWithM:(int)m N:(int)n{
    _im = m;
    _in = n;
    _showCount = m*n;
    [self removeImageViewFromVideoPlayView];
    for (int i = 0; i < m*n; i++) {
        NSImageView *imageView = [[NSImageView alloc] init];
        imageView.wantsLayer = YES;
        imageView.layer.borderColor = [NSColor grayColor].CGColor;
        imageView.layer.borderWidth = 1.0;
        [self addSubview:imageView];
        [_imageViewArr addObject:imageView];
    }
    [self resetFrame];
}
- (void)resetFrame{
    for (int i = 0; i < _im*_in; i++) {
        float width = self.frame.size.width/_im;
        float height = self.frame.size.height/_in;
        float x = (i%_im)*width;
        float y = (i/_im)*height;
        NSImageView *imageView = _imageViewArr[i];
        [imageView setFrame:CGRectMake(x,y,width,height)];
    }
}
-(void)removeImageViewFromVideoPlayView{
    for (NSImageView *view in _imageViewArr) {
        [view removeFromSuperview];
    }
    [_imageViewArr removeAllObjects];
}

- (void)mouseDown:(NSEvent *)event{
    //    NSLog(@"mouseDown");
    NSPoint eventLocation = [event locationInWindow];
    NSPoint point = [self convertPoint:eventLocation fromView:nil];
    NSLog(@"start point :%f %f",point.x,point.y);
    for (NSImageView *iv in _imageViewArr) {
        if (CGRectContainsPoint(iv.frame,point)) {
            _dragStartIV = iv;
            iv.layer.borderColor = [NSColor blueColor].CGColor;
        }else{
            iv.layer.borderColor = [NSColor grayColor].CGColor;
        }
    }
}
- (void)mouseDragged:(NSEvent *)event{
        NSLog(@"mouseDragged");
    _isDrag = YES;
}
- (void)mouseMoved:(NSEvent *)event{
    //    NSLog(@"mouseMoved");
}
- (void)mouseUp:(NSEvent *)event{
    //    NSLog(@"mouseUp");
    NSPoint eventLocation = [event locationInWindow];
    NSPoint point = [self convertPoint:eventLocation fromView:nil];
    NSLog(@"end point :%f %f",point.x,point.y);
    NSLog(@"clickcount :%ld",(long)event.clickCount);
    double time = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"last :%f~this: %f~time :%f",_clickTime,time,time-_clickTime);
    if (event.clickCount > 1 && time-_clickTime < 0.2) {
        //双击鼠标
        for (NSImageView *iv in _imageViewArr) {
            if (_showCount == 1) {
                if (CGRectContainsPoint(iv.frame,point)) {
                    int index = (int)[_imageViewArr indexOfObject:iv];
                    float width = self.frame.size.width/_im;
                    float height = self.frame.size.height/_in;
                    float x = (index%_im)*width;
                    float y = (index/_im)*height;
                    iv.frame = CGRectMake(x,y,width,height);
                }else{
                    iv.hidden = NO;
                }
            }else{
                if (CGRectContainsPoint(iv.frame,point)) {
                    iv.frame = self.frame;
                }else{
                    iv.hidden = YES;
                }
            }
        }
        _showCount = _showCount == 1? _im*_in:1;
    }
    _clickTime = time;
    if (_isDrag && _dragStartIV) {
        for (NSImageView *iv in _imageViewArr) {
            if (CGRectContainsPoint(iv.frame,point)) {
                _dragEndIV = iv;
            }else{
                iv.layer.borderColor = [NSColor grayColor].CGColor;
            }
        }
//        if (![_dragStartIV isEqual:_dragEndIV]) {
            CGRect frameStart = _dragStartIV.frame;
            CGRect frameEnd = _dragEndIV.frame;
            NSLog(@"start:%f %f %f %f",frameStart.origin.x,frameStart.origin.y,frameStart.size.width,frameStart.size.height);
            NSLog(@"end:%f %f %f %f",frameEnd.origin .x,frameEnd.origin.y,frameEnd.size.width,frameEnd.size.height);
            float x = MIN(frameStart.origin.x, frameEnd.origin.x);
            float y = MIN(frameStart.origin.y, frameEnd.origin.y);
            float width = 0;
            float height = 0;
            if (frameStart.origin.x > frameEnd.origin.x) {
                width = fabs(CGRectGetMaxX(frameStart)-CGRectGetMinX(frameEnd));
            }else{
                width = fabs(CGRectGetMaxX(frameEnd)-CGRectGetMinX(frameStart));
            }
            if (frameStart.origin.y > frameEnd.origin.y) {
                height = fabs(CGRectGetMaxY(frameStart)-CGRectGetMinY(frameEnd));
            }else{
                height = fabs(CGRectGetMaxY(frameEnd)-CGRectGetMinY(frameStart));
            }
            NSLog(@"%f %f %f %f",x,y,width,height);
            [_dragStartIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.top.mas_equalTo(y);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
//            _dragStartIV.layer.borderColor = [NSColor redColor].CGColor;
        
//        }
    }
    _isDrag = NO;
    _dragStartIV = nil;
    _dragEndIV = nil;
}
//鼠标右键点击事件
- (void)rightMouseUp:(NSEvent *)event{
    NSPoint eventLocation = [event locationInWindow];
    NSPoint point = [self convertPoint:eventLocation fromView:nil];
    if (CGRectContainsPoint(self.frame,point)) {
        NSLog(@"end point :%f %f",point.x,point.y);
        for (NSImageView *iv in _imageViewArr) {
            if (CGRectContainsPoint(iv.frame,point)) {
                _rightSelectedView = iv;
                _rightSelectedView.layer.borderColor = [NSColor yellowColor].CGColor;
            }else{
                iv.layer.borderColor = [NSColor grayColor].CGColor;
            }
        }
    }
    [self showRightMenu:eventLocation inView:_rightSelectedView];//鼠标右键菜单
}
//右键菜单
- (void)showRightMenu:(NSPoint)position inView:(NSView *)view{
    NSMenu *rightMenu= [[NSMenu alloc] init];
    rightMenu.autoenablesItems = NO;//不设置autoenablesitems属性,只改变item的isenable属性将无效果
    NSMenuItem *closeVideoItem = [[NSMenuItem alloc] initWithTitle:@"关闭视频" action:@selector(closeVideo) keyEquivalent:@"X"];
    [rightMenu addItem:closeVideoItem];
    [rightMenu addItem:[NSMenuItem separatorItem]];//菜单的分割线
    NSMenuItem *soundItem = [[NSMenuItem alloc] initWithTitle:@"音频预览" action:@selector(closeVideo) keyEquivalent:@""];
    soundItem.enabled = NO;
    [rightMenu addItem:soundItem];
    NSMenuItem *remoteVideoItem = [[NSMenuItem alloc] initWithTitle:@"即时回放" action:@selector(closeVideo) keyEquivalent:@""];
    [rightMenu addItem:remoteVideoItem];
    [rightMenu addItem:[NSMenuItem separatorItem]];
    fullScreenItem = [[NSMenuItem alloc] initWithTitle:@"全屏显示" action:@selector(fullScreen:) keyEquivalent:@""];
    [rightMenu addItem:fullScreenItem];
    [view setMenu:rightMenu];
    NSMenu *subMenu = [[NSMenu alloc] init];
    NSMenuItem *subItem1 = [[NSMenuItem alloc] initWithTitle:@"二级菜单1" action:@selector(fullScreen) keyEquivalent:@""];
    [subMenu addItem:subItem1];
    NSMenuItem *subItem2 = [[NSMenuItem alloc] initWithTitle:@"二级菜单2" action:@selector(fullScreen) keyEquivalent:@""];
    [subMenu addItem:subItem2];
    NSMenuItem *mutiItem = [[NSMenuItem alloc] initWithTitle:@"二级菜单" action:@selector(closeVideo) keyEquivalent:@""];
    [mutiItem setSubmenu:subMenu];
    [rightMenu addItem:mutiItem];
}
- (void)closeVideo{
    NSLog(@"点击了关闭视频菜单");
}
- (void)fullScreen:(NSMenuItem *)item{
    if (item.state == NSControlStateValueOff) {
        if (_newWindow == nil) {
            _newWindow = [[VideoPlayFullWindow alloc] initWithWindowNibName:@"VideoPlayFullWindow"];
        }
        [_newWindow.window.contentView addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_newWindow.window.contentView);
        }];
        [_newWindow showWindow:_newWindow];
    }
    item.state = !item.state;
    [_newWindow.window toggleFullScreen:_newWindow];
    if ([self.delegate respondsToSelector:@selector(fullScreen:)]) {
        [self.delegate fullScreen:item.state];
    }
}
- (void)setFullScreenItemState:(NSControlStateValue)state{
    fullScreenItem.state = state;
}
- (void)fullOrSmall{
    
}
@end

