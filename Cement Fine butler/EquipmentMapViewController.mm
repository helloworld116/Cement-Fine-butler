//
//  CementViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EquipmentMapViewController.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"
#import "Cell.h"

@interface EquipmentMapViewController ()
@property (nonatomic,retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic,retain) NSMutableArray *annotationList;
@end

@implementation EquipmentMapViewController

- (void)mapView:(BMKMapView *) mapView didSelectAnnotationView:(BMKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else{
        //        if([delegate respondsToSelector:@selector(customBMKMapViewDidSelectedWithInfo:)]){
        //            [delegate customBMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        //        }
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationView class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            Cell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil] objectAtIndex:0];
            [annotationView.contentView addSubview:cell];
            
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
            annotationView.canShowCallout = NO;
            annotationView.annotation = annotation;
        }
		return annotationView;
    }
	return nil;
}


-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list) {
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude, longitude);
        //
        //        BMKCoordinateRegion region=BMKCoordinateRegionMakeWithDistance(location,span ,span );
        //        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        //        [_mapView setRegion:adjustedRegion animated:YES];
        //
        //        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
        //        [_mapView addAnnotation:annotation];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.title= @"cnm";
        annotation.coordinate = coordinate;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)resetAnnitations:(NSArray *)data
{
//    [_annotationList removeAllObjects];
//    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}

- (NSArray *)testData{
//    NSDictionary *dict1 =@{@"longitude": @"116.404",@"latitude":@"39.915"};
    NSDictionary *dict2 =@{@"longitude": @"113.958871",@"latitude":@"22.542872"};
    NSDictionary *dict3 =@{@"longitude": @"113.957971",@"latitude":@"22.548972"};
    NSDictionary *dict4 =@{@"longitude": @"113.954671",@"latitude":@"22.543672"};
    NSDictionary *dict5 =@{@"longitude": @"113.955671",@"latitude":@"22.542672"};
    NSArray *arr = @[dict2,dict3,dict4,dict5];
    return arr;
}

- (void)viewDidLoad
{
    _annotationList = [[NSMutableArray alloc] init];
    [_annotationList addObjectsFromArray:[self testData]];
    //设置地图缩放级别
    [_mapView setZoomLevel:11];
    
    //  给view中心定位
    BMKCoordinateRegion region;
    region.center.latitude  = [[[self.annotationList objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
    region.center.longitude = [[[self.annotationList objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
    region.span.latitudeDelta  = 0.01;
    region.span.longitudeDelta = 0.01;
    self.mapView.region = region;

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void) viewDidAppear:(BOOL)animated {
    [self resetAnnitations:self.annotationList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView removeAnnotation:_calloutAnnotation];
    _calloutAnnotation = nil;
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end