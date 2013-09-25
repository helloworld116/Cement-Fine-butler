//
//  SearchCondition.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCondition : NSObject
@property int timeType;//时间类型，0表示全年，1表示本季度，2表示本月，3表示今天，4表示自定义时间段
@property long lineID;//产线id
@property long productID;//产品id
@property int stockType;//库存类型，0表示原材料库存，1表示成品库存

-(id)initWithStockType:(int)inventoryType timeType:(int)typeType lineID:(long)lineID productID:(long)productID;
@end
