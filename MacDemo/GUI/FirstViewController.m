//
//  FirstViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "FirstViewController.h"
#import "TabButton.h"
#import "TDTextField.h"
@interface FirstViewController (){
    
    __weak IBOutlet NSButton *_deviceManagerBtn;
    __weak IBOutlet NSButton *_mainBtn;
    __weak IBOutlet NSButton *_userManagerBtn;
    __weak IBOutlet NSTextField *_noticeLab;
    
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTrackArea:_deviceManagerBtn];
}
-(void)viewWillAppear{
    [super viewWillAppear];
    NSLog(@"show first");
}

-(void)addTrackArea:(NSView *)view{
     NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:view.bounds options:NSTrackingActiveAlways+NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [view addTrackingArea:area];
}
- (IBAction)showMainViewController:(id)sender {
    if(self.mainBtnSelectedblock){
        self.mainBtnSelectedblock();
    }
}
- (IBAction)showDeviceManagerController:(id)sender {
    if(self.deviceManagerBtnSelectedblock){
        self.deviceManagerBtnSelectedblock();
    }
}
- (IBAction)showUserManagerController:(id)sender {
    if(self.userManagerBtnSelectedBlock){
        self.userManagerBtnSelectedBlock();
    }
}
#pragma mark 监听鼠标事件
-(void)mouseEntered:(NSEvent *)event{
    CGPoint point = event.locationInWindow;
    if(CGRectContainsPoint(_deviceManagerBtn.frame,point)){
        [self setNoticeMessage:@"在 MKMapView上画了一个区域；如何判断坐标点是否在这个区域内？"];
    }
}
-(void)mouseExited:(NSEvent *)event{
    
}
-(void)setNoticeMessage:(NSString *)message{
    _noticeLab.stringValue = message;
//    TDTextField *cell = _noticeLab.cell;
//    [cell adjustedFrameToVerticallyCenterText:_noticeLab.frame];
}
@end
