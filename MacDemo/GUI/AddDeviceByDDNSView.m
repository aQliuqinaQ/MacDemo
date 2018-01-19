//
//  AddDeviceByDDNSView.m
//  MacDemo
//
//  Created by liuqin on 2018/1/19.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "AddDeviceByDDNSView.h"

@implementation AddDeviceByDDNSView
-(instancetype)initWithFrame:(NSRect)frameRect{
    if(self = [super initWithFrame:frameRect]){
        NSNib * nib = [[NSNib alloc] initWithNibNamed:@"AddDeviceByDDNSView" bundle:nil];
        NSArray * topLevelObjects;
        if([nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]){
            for(id topLevelObject in topLevelObjects){
                if([topLevelObject isKindOfClass:[AddDeviceByDDNSView class]]){
                    self = topLevelObject;
                    break;
                }
            }
        }
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
