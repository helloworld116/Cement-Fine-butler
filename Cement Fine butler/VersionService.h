//
//  VersionService.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionService : NSObject
+ (id)sharedInstance;
-(void)checkVersion;
-(void)checkVersionDaily;
-(void)checkVersionWeekly;
@end
