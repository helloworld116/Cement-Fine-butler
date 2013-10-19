//
//  CementViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentMapViewController : UIViewController<BMKMapViewDelegate>

@property (strong,nonatomic) IBOutlet BMKMapView* mapView;

@property (nonatomic,retain) NSMutableArray *equipmentList;
@end
