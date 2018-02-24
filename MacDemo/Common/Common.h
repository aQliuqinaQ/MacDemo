//
//  Common.h
//  EasyLive
//
//  Created by liuqin on 16/8/25.
//  Copyright © 2016年 tiandy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumeration.h"
@interface Common : NSObject
+ (Common *) getInstance;
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) NSString *appPath;
-(int)addDeviceWithDeviceName:(NSString *)deviceName ip:(NSString *)ip domain:(NSString *)domain port:(int)port domainName:(NSString *)domainName username:(NSString *)username password:(NSString *)passowrd connType:(int)connType;
-(int)updateDeviceWithDeviceId:(NSString *)deviceId deviceName:(NSString *)deviceName ip:(NSString *)ip domain:(NSString *)domain port:(int)port domainName:(NSString *)domainName username:(NSString *)username password:(NSString *)passowrd;
-(NSMutableArray *)getAllDevice;
-(BOOL)deleteDeviceById:(NSString *)deviceId;
@end
