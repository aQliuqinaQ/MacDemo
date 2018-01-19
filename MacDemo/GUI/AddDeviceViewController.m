//
//  AddDeviceViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/18.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "Common.h"
#import "AddDeviceByIPView.h"
#import "AddDeviceByDDNSView.h"
@interface AddDeviceViewController (){
    
    __weak IBOutlet NSView *_contentView;
    __weak IBOutlet NSSegmentedControl *_seg;
    AddDeviceByIPView *_ipView;
    AddDeviceByDDNSView *_ddnsView;
}

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ipView = [[AddDeviceByIPView alloc] initWithFrame:_contentView.frame];
    _ddnsView = [[AddDeviceByDDNSView alloc] initWithFrame:_contentView.frame];
    _ddnsView.hidden = YES;
    [_contentView addSubview:_ddnsView];
    [_contentView addSubview:_ipView];
}
- (IBAction)changeAddMethod:(id)sender {
    NSSegmentedControl *seg = (NSSegmentedControl *)sender;
    if(seg.selectedSegment == 0){
        _ddnsView.hidden = YES;
        _ipView.hidden = NO;
    }else{
        _ddnsView.hidden = NO;
        _ipView.hidden = YES;
    }
}
- (IBAction)showOnlineDevice:(id)sender {
}
- (IBAction)addDevice:(id)sender {
    int success = -1;
    if(_seg.selectedSegment == 0){
       success = [[Common getInstance] addDeviceWithDeviceName:_ipView.deviceName.stringValue ip:_ipView.address.stringValue domain:@"" port:_ipView.port.intValue domainName:@"" username:_ipView.userName.stringValue password:_ipView.password.stringValue connType:0];
    }else{
       success = [[Common getInstance] addDeviceWithDeviceName:_ddnsView.deviceName.stringValue ip:@"" domain:_ddnsView.address.stringValue port:0  domainName:_ddnsView.domainName.stringValue username:_ddnsView.userName.stringValue password:_ddnsView.password.stringValue connType:1];
    }
    if(success == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Add Device" object:nil];
        [self.view.window orderOut:self];
    }else if(success == ERR_CAPTION_EXSIT){
        if(_seg.selectedSegment == 0){
            [self showPopOverWithMessage:@"设备名称已存在" toview:_ipView.deviceName];
        }else{
            [self showPopOverWithMessage:@"设备名称已存在" toview:_ddnsView.deviceName];
        }
    }else if(success == ERR_DEVICE_ADDRESS_EXSIT){
        [self showPopOverWithMessage:@"设备IP已存在" toview:_ipView.address];
    }else if(success == ERR_DEVICE_DOMAIN_EXSIT){
        [self showPopOverWithMessage:@"Domain已存在" toview:_ddnsView.address];
    }else if(success == ERR_DEVICE_DOMAIN_NAME_EXSIT){
        [self showPopOverWithMessage:@"Domain名称已存在" toview:_ddnsView.domainName];
    }
}
-(void)showPopOverWithMessage:(NSString *)message toview:(NSView *)view{
    NSViewController *popController = [[NSViewController alloc] initWithNibName:nil bundle:nil];
    NSTextField * textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 25)];
    textField.editable = NO;
    textField.stringValue = message;
    popController.view = textField;
    NSPopover *pop = [[NSPopover alloc] init];
    pop.contentViewController = popController;
    /**
     applicationDefined : 默认值,不会自动关闭popover,ESC键也不能关闭,应用关闭时,popovoer会关闭
     semitransient: 点击popover以外的界面部分,不会自动关闭,但ESC按键可以关闭popover
     transient:  点击popvoer界面以外的部分,popover会自动关闭,ESC键可以关闭popover
     */
    pop.behavior = NSPopoverBehaviorSemitransient;
    [pop showRelativeToRect:view.bounds ofView:view preferredEdge:NSRectEdgeMaxX];
    
}
- (IBAction)cancel:(id)sender {
    [self.view.window orderOut:self];
}

@end
