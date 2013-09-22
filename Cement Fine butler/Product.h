//
//  Product.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-22.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property long productID;
@property (nonatomic,retain) NSString *ids;
@property (nonatomic,retain) NSString *page;
@property (nonatomic,retain) NSString *rows;
@property (nonatomic,retain) NSString *sort;
@property (nonatomic,retain) NSString *order;
@property (nonatomic,retain) NSString *offset;
@property (nonatomic,retain) NSString *startTime;
@property (nonatomic,retain) NSString *endTime;
@property (nonatomic,retain) NSString *startTimeStr;
@property (nonatomic,retain) NSString *endTimeStr;
@property (nonatomic,retain) NSString *productendes;
@property (nonatomic,retain) NSString *productzhdes;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *remark;
@property (nonatomic,retain) NSString *industry;
@property long factoryid;

@end
