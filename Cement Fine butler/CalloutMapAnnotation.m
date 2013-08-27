//
//  CalloutMapAnnotation.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司 rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end
