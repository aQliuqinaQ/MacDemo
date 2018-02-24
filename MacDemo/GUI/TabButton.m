//
//  TabButton.m
//  MacDemo
//
//  Created by liuqin on 2018/1/17.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "TabButton.h"
@interface TabButton (){
    
    __weak IBOutlet NSButton *_imageBtn;
    __weak IBOutlet NSButton *_closeBtn;
}

@end
@implementation TabButton
-(instancetype)initWithFrame:(NSRect)frameRect image:(NSImage *)image title:(NSString *)title tag:(NSString *)identifier{
    if(self = [super initWithFrame:frameRect]){
        NSNib * nib = [[NSNib alloc] initWithNibNamed:@"TabButton" bundle:nil];
        NSArray * topLevelObjects;
        if([nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]){
            for(id topLevelObject in topLevelObjects){
                if([topLevelObject isKindOfClass:[TabButton class]]){
                    self = topLevelObject;
                    break;
                }
            }
        }
        self.frame = frameRect;
        _imageBtn.image = image;
        _imageBtn.title = title;
        self.identifier = identifier;
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor redColor].CGColor;
        
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:_closeBtn.bounds options:NSTrackingMouseEnteredAndExited+NSTrackingActiveAlways owner:self userInfo:nil];
        [_closeBtn addTrackingArea:area];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (IBAction)closeView:(id)sender {
    if([self.delegate respondsToSelector:@selector(onClickTabCloseBtn:)]){
        [self.delegate onClickTabCloseBtn:self.identifier];
    }
}
- (IBAction)onClickTabBtn:(id)sender {
    if([self.delegate respondsToSelector:@selector(selecteTabBtn:)]){
        [self.delegate selecteTabBtn:self.identifier];
    }
}
-(void)setCloseBtnHide:(BOOL)hide{
    _closeBtn.hidden = hide;
}
#pragma mark 监听鼠标事件
-(void)mouseEntered:(NSEvent *)event{
    NSLog(@"鼠标移入closeBtn");
    _closeBtn.alphaValue = 1.0;
}
-(void)mouseExited:(NSEvent *)event{
    NSLog(@"鼠标移出closeBtn");
    _closeBtn.alphaValue = 0.0;
}
@end
