//
//  BugDoc.h
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BugData.h"
@interface BugDoc : NSObject
@property(nonatomic,strong)BugData *data;
@property(nonatomic,strong)NSImage *thumbImg;
@property(nonatomic,strong)NSImage *fullImg;
-(instancetype)initWithTitle:(NSString *)title rating:(float)rating thumbImg:(NSImage *)thumImg fullImg:(NSImage *)fullImg;
@end
