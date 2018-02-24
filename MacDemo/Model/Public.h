//
//  Public.h
//  EasyLive
//
//  Created by Tiandy on 2017/8/3.
//  Copyright © 2017年 tiandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Public : NSObject
@property(nonatomic,copy)NSString *strId;
@property(nonatomic,copy)NSString *hostId;
@property(nonatomic)int channelNum;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *shareName;
@property(nonatomic,copy)NSString *imageUrl;
@end
