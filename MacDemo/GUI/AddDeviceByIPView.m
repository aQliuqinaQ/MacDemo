//
//  AddDeviceByIPView.m
//  MacDemo
//
//  Created by liuqin on 2018/1/19.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "AddDeviceByIPView.h"
@interface AddDeviceByIPView(){
}
@end
@implementation AddDeviceByIPView
-(instancetype)initWithFrame:(NSRect)frameRect{
    if(self = [super initWithFrame:frameRect]){
        NSNib * nib = [[NSNib alloc] initWithNibNamed:@"AddDeviceByIPView" bundle:nil];
        NSArray * topLevelObjects;
        if([nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]){
            for(id topLevelObject in topLevelObjects){
                if([topLevelObject isKindOfClass:[AddDeviceByIPView class]]){
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
    
}

@end
