//
//  LeafModel.h
//  MacDemo
//
//  Created by liuqin on 2018/3/30.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafModel : NSObject
@property(nonatomic,copy)NSString *strId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic)BOOL hasChildren;
@property(nonatomic)int level;
@property(nonatomic)NSMutableArray *children;
@property(nonatomic)BOOL selected;
-(instancetype)initWithId:(NSString *)strId name:(NSString *)name  level:(int)level;
@end
