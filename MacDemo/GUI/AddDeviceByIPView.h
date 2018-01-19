//
//  AddDeviceByIPView.h
//  MacDemo
//
//  Created by liuqin on 2018/1/19.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddDeviceByIPView : NSView
@property (weak) IBOutlet NSTextField *deviceName;
@property (weak) IBOutlet NSTextField *address;
@property (weak) IBOutlet NSTextField *port;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSSecureTextField *password;

@end
