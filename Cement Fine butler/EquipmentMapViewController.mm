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
#import "EquipmentPointAnnotation.h"
#import "EquipmentAnnotationView.h"
#import "EquipmentListViewController.h"

@interface EquipmentMapViewController ()
@property (nonatomic,retain) CalloutMapAnnotation *calloutAnnotation;
@property (strong, nonatomic) UIBarButtonItem *rightButtonItem;
@end


@implementation EquipmentMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设备地图列表";
//    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(showListController:)];
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 40, 30)];
    [bt setImage:[UIImage imageNamed:@"list_icon"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"list_click_icon"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(showListController:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];
    [_mapView setZoomLevel:6];
    self.equipmentList = [NSMutableArray array];
    self.URL = kEquipmentList;
    [self sendRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView removeAnnotation:_calloutAnnotation];
    _calloutAnnotation = nil;
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(BMKMapView *) mapView didSelectAnnotationView:(BMKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[EquipmentPointAnnotation class]]) {
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
        _calloutAnnotation.equipmentInfo = ((EquipmentPointAnnotation *)view.annotation).equipmentInfo;
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
//        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
//        if (!annotationView) {
//            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
//            NSDictionary *equipmentInfo = ((CalloutMapAnnotation *)annotation).equipmentInfo;
//            Cell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil] objectAtIndex:0];
//            cell.lblEquipmentName.text = [@"设备" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"sn"]]];
//            cell.lblCompany.text = [kSharedApp.factory objectForKey:@"name"];
//            cell.lblBox.text = [@"控制盒编号：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"boxsn"]]];
//            cell.lblSN.text = [@"仪表编号：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"sn"]]];
//            cell.lblEquipmentType.text = [@"设备类型：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"typename"]]];
//            cell.lblMaterial.text = [@"物料：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"materialName"]]];
//            cell.lblLine.text = [@"生产线：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"linename"]]];
//            [annotationView.contentView addSubview:cell];
//        }
        CallOutAnnotationView *annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
        NSDictionary *equipmentInfo = ((CalloutMapAnnotation *)annotation).equipmentInfo;
        Cell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil] objectAtIndex:0];
        cell.lblEquipmentName.text = [@"设备" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"sn"]]];
        cell.lblCompany.text = [kSharedApp.factory objectForKey:@"name"];
        cell.lblStatus.text = [@"设备状态：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"statusLabel"]]];
        cell.lblBox.text = [@"控制盒编号：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"boxsn"]]];
        cell.lblSN.text = [@"仪表编号：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"sn"]]];
        cell.lblEquipmentType.text = [@"设备类型：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"typename"]]];
        cell.lblMaterial.text = [@"物料：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"materialName"]]];
        cell.lblLine.text = [@"生产线：" stringByAppendingString:[Tool stringToString:[equipmentInfo objectForKey:@"linename"]]];
        [annotationView.contentView addSubview:cell];
        return annotationView;
	} else if ([annotation isKindOfClass:[EquipmentPointAnnotation class]]) {
        EquipmentAnnotationView *annotationView = (EquipmentAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[EquipmentAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
            annotationView.canShowCallout = NO;
            annotationView.annotation = annotation;
            annotationView.equipmentInfo = ((EquipmentPointAnnotation *)annotation).equipmentInfo;
        }
		return annotationView;
    }
	return nil;
}


-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list) {
        CLLocationDegrees latitude=[Tool doubleValue:[dic objectForKey:@"latitude"]];
        CLLocationDegrees longitude=[Tool doubleValue:[dic objectForKey:@"longitude"]];
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude, longitude);
        //
        //        BMKCoordinateRegion region=BMKCoordinateRegionMakeWithDistance(location,span ,span );
        //        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        //        [_mapView setRegion:adjustedRegion animated:YES];
        //
        //        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
        //        [_mapView addAnnotation:annotation];
        EquipmentPointAnnotation *annotation = [[EquipmentPointAnnotation alloc] init];
        annotation.equipmentInfo = dic;
        annotation.title = @"";
        annotation.coordinate = coordinate;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)resetAnnitations:(NSArray *)data
{
    //    [_annotationList removeAllObjects];
    //    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:self.equipmentList];
}

-(void)showListController:(id)sender{
    EquipmentListViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentListViewController"];
    nextVC.list = self.equipmentList;
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    self.mapView.hidden = NO;
    [self.equipmentList addObjectsFromArray:[[self.responseData objectForKey:@"data"] objectForKey:@"equipments"]];
    if (self.equipmentList.count>0) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
//        //设置地图缩放级别
//        [_mapView setZoomLevel:10];
//        //给view中心定位
//        BMKCoordinateRegion region;
//        region.center.latitude  = [[[self.equipmentList objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
//        region.center.longitude = [[[self.equipmentList objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
//        region.span.latitudeDelta  = 0.01;
//        region.span.longitudeDelta = 0.01;
//        self.mapView.region = region;
    }
    [self resetAnnitations:self.equipmentList];
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    [self.request setPostValue:[NSNumber numberWithInt:100] forKey:@"count"];
    [self.request setPostValue:[NSNumber numberWithInt:1] forKey:@"page"];
}

-(void)clear{
    self.mapView.hidden = YES;
}
@end
