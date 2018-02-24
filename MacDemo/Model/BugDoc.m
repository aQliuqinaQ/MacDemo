//
//  BugDoc.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "BugDoc.h"

@implementation BugDoc
-(instancetype)initWithTitle:(NSString *)title rating:(float)rating thumbImg:(NSImage *)thumImg fullImg:(NSImage *)fullImg{
    if(self = [super init]){
        self.data = [[BugData alloc] initWithTitle:title rating:rating];
        self.thumbImg = thumImg;
        self.fullImg = fullImg;
    }
    return self;
}
@end
