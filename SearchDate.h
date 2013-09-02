//
//  SearchDate.h
//  CustomerSystem
//
//  Created by wzg on 13-4-23.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDate : NSObject

@property (nonatomic,copy) NSString *benginDate;
@property (nonatomic,copy) NSString *endDate;

-(id)initWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate;
@end
