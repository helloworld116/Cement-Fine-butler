//
//  CalloutMapAnnotation.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司 rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;


@end
