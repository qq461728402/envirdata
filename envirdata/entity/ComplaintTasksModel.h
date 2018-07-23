//
//  ComplaintTasksModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/23.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplaintTasksModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * cname;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * ctime;
@property (nonatomic, strong) NSNumber * cuser;
@property (nonatomic, strong) NSNumber * depid;
@property (nonatomic, strong) NSString * dname;
@property (nonatomic, strong) NSString * handle_des;
@property (nonatomic, strong) NSString * handle_pics;
@property (nonatomic, strong) NSString * handle_time;
@property (nonatomic, strong) NSString * handler;
@property (nonatomic, strong) NSString * hname;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * pics;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * title;

@end