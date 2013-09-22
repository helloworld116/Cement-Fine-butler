//
//  Line.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-22.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

//产线
@interface Line : NSObject
@property long lineID;
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
@property (nonatomic,retain) NSString *name;
@property long factoryid;
@property int enable;
@property (nonatomic,retain) NSString *creatTime;
@property (nonatomic,retain) NSString *productsJson;
@property (nonatomic,retain) NSMutableArray *lineProducts;
@property (nonatomic,retain) NSString *productids;
@property int type;
@property long parentid;
@end
