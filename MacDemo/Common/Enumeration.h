//
//  Enumeration.h
//  MacDemo
//
//  Created by liuqin on 2018/1/19.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

typedef NS_ENUM(NSInteger,DB_CODE) {
    ERR_PARAM_ERROR=-1,
    ERR_DB_ERROR = -2,
    ERR_CAPTION_EXSIT = -30,
    ERR_DEVICE_ADDRESS_EXSIT = -31,
    ERR_ID_EXSIT = -32,
    ERR_DEVICE_DOMAIN_EXSIT=-33,
    ERR_DEVICE_DOMAIN_NAME_EXSIT = -34,
    DB_SUCCESS = 0,
    ERR_HOST_NOT_EXSIT = -35,
};
#endif /* Enumeration_h */
