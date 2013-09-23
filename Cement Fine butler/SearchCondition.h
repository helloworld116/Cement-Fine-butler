//
//  SearchCondition.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCondition : NSObject
@property int inventoryType;//库存类型0:原材料  1:产品
@property int timeType;//时间类型，0表示全年，1表示本季度，2表示本月，3表示今天，4表示自定义时间段
@property long lineID;//产线id
@property long productID;//产品id

-(id)initWithInventoryType:(int)inventoryType timeType:(int)typeType lineID:(long)lineID productID:(long)productID;
@end
