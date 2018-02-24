//
//  Host.h
//  Easy cloud
//
//  Created by tiandy on 15-1-9.
//  Copyright (c) 2015年 tiandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Host : NSObject
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strCaption;
@property (nonatomic, copy) NSString *strIPAddress;
@property (nonatomic, assign) NSInteger iPort;
@property (nonatomic, copy) NSString *strDomainAddress;
@property (nonatomic, copy) NSString *strDomainName;
@property (nonatomic, copy) NSString *strUsername;
@property (nonatomic, copy) NSString *strPassword;
@property (nonatomic, assign)NSInteger iConnType;
@property (nonatomic,assign)BOOL isOnline;
@end
