//
//  BugData.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "BugData.h"

@implementation BugData
-(instancetype)initWithTitle:(NSString *)title rating:(float)rating{
    if(self = [super init]){
        self.title = title;
        self.rating = rating;
    }
    return self;
}
@end
