//
//  BMKVersion.h
//  BMapKit
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/*****������־��*****
 V0.1.0�� ���԰�
 ֧�ֵ�ͼ�������������
 ֧��POI����
 ֧��·������
 ֧�ֵ�����빦��
 --------------------
 V1.0.0����ʽ������
 ��ͼ�������������㴥��������
 ��ע��������
 POI��·������
 ������롢���������
 ��λͼ��
 --------------------
 V1.1.0��
 ���ߵ�ͼ֧��
 --------------------
 V1.1.1��
 ����suggestionSearch�ӿ�
 ���Զ�̬����annotation title
 fixС�ڴ�й¶����
 --------------------
 V1.2.1��
 ����busLineSearch�ӿ�
 �޸���λȦ��Χ�ڲ����϶���ͼ��bug
 
 --------------------
 V2.0.0
 
 ������
 ȫ�µ�3Dʸ����ͼ��Ⱦ
 BMKMapView�趨��ͼ��ת���ӽǶȣ�rotation��overlooking
 BMKMapView�趨ָ������ʾλ�ã�compassPosition
 BMKMapView�����������ڣ�viewWillAppear��viewWillDisappear
 ��ͼ��ע�ɵ㣬BMKMapViewDelegate�����ӿڻص��ӿ�onClickedMapPoi
 BMKAnnotationView����annotation�Ƿ�����3Dģʽ��enabled3D
 overlay���Ʒ�ʽ�ı䣬����opengl���ƣ�
 BMKOverlayViewʹ��opengl��Ⱦ�ӿڣ�glRender�������ش˺���ʵ��gl����
 ����opengl�߻��ƣ�renderLinesWithPoints
 ����opengl����ƣ�renderRegionWithPointsl
 ȫ�µ�ʸ�����ߵ�ͼ���ݣ�
 BMKOfflineMap�������ߵ�ͼ��start
 BMKOfflineMap�������ߵ�ͼ��update
 BMKOfflineMap��ͣ���ػ���£�pasue
 ����ȵ�����б�getHotCityList
 ���֧���������ݵĳ��У�getOfflineCityList
 ���ݳ�������ѯ������Ϣ��searchCity
 ���£�
 BMKMapView�����ż���zoomLevel����Ϊfloat�ͣ�ʵ���޼�����
 ���µ�ͼ����ö�٣�
 enum {   BMKMapTypeStandard  = 1,              ///< ��׼��ͼ
 BMKMapTypeTrafficOn = 2,              ///< ʵʱ·��
 BMKMapTypeSatellite = 4,              ///< ���ǵ�ͼ
 BMKMapTypeTrafficAndSatellite = 8,    ///< ͬʱ��ʵʱ·�������ǵ�ͼ
 };
 
 
 --------------------
 v2.0.1
 ������
 ��	MapView�����¼�����
 BMKMapviewDelegate��- mapView: onClickedMapBlank:����������ͼ�����¼�
 BMKMapviewDelegate��- mapView: onDoubleClick:����������ͼ˫���¼�
 BMKMapviewDelegate��- mapView: onLongClick:����������ͼ�����¼�
 ��	��ͼ��ͼ����
 BMKmapview�� -(UIImage*) takeSnapshot;
 ��	·���滮����;����
 BMKSearch��- (BOOL)drivingSearch: startNode: endCity: endNode: throughWayPoints:
 ��	suggestion����֧�ְ���������
 �Ż���
 ��	ȫ��֧��iPad
 ��	�Ż���Ӻ���annotation�߼�
 ��	BMKOfflineMap�У�
 - (BOOL)pasue:(int)cityID;
 ��Ϊ
 - (BOOL)pause:(int)cityID
 ��	BMKMapview�У�
 @property (nonatomic) CGPoint compassPositon;
 ��Ϊ
 @property (nonatomic) CGPoint compassPosition;
 ��	BMKRouteAddrResult�ṹ������ԣ�
 @synthesize wayPointPoiList;
 @synthesize wayPointCityList;
 ��	BMKPlanNode��������ԣ�
 @synthesize cityName; ��ӳ�������
 ��	BMKSuggestionresult�ṹ������ԣ�
 @synthesize districtList; ���������б�
 �޸���
 ��	�޸������������ͻ������
 �޸���gzip��Reachability��png��jpeg��json��xml��sqlite�ȵ���������ͻ����
 
 
 --------------------
 v2.0.2
 ������
 1.ȫ�µ�key��֤��ϵ
 
 2.���Ӷ̴�����ӿ�
 1����BMKType���������ݽṹ��BMK_SHARE_URL_TYPE�������������ͣ�
 2����BMKSearch�������ӿ�-(BOOL)poiDetailShareUrl:(NSString*) uid; ����poi�̴�����
 3����BMKSearch�������ӿ�-(BOOL)reverseGeoShareUrl:(CLLocationCoordinate2D)coor
                              poiName:(NSString*)name
                              poiAddress:(NSString*)address; ����geo�̴�����
 4����BMKSearchDelegate�������ӿ�-(void)onGetShareUrl:(NSString*) url
                                      withType:(BMK_SHARE_URL_TYPE) urlType
                                      errorCode:(int)error; ���ض̴�����url
 3.�����߿ؼ�
 1����BMKMapview����������@property (nonatomic) BOOL showMapScaleBar;�������Ƿ���ʾ
 2����BMKMapview����������@property (nonatomic) CGPoint mapScaleBarPosition;��������ʾλ��
 
 4.��λ����Ч��
 1����BMKMapview���������ݽṹ��BMKUserTrackingMode����λģʽ��
 2����BMKMapview����������@property (nonattomic) BMKUserTrackingMode userTrackingMode; �趨��λģʽ
 
 5.�ݳ�����ӵ�²���
 1����BMKSearch�������ݳ��������Գ���BMKCarTrafficFIRST = 60,///<�ݳ��������Գ��������ӵ��
 
 6.·����ѯ����ʱ�䡢�򳵷��ý��
 1����BMKSearch�������ࣺBMKTime���������һ��ʱ��Σ�ÿ�����Զ���һ��ʱ��Ρ���
 2����BMKTransitRoutePlan����������@property (nonatomic) float price; ����򳵹��ۣ���λ(Ԫ)
 3����BMKTransitRoutePlan����������@property (nonatomic, retain) BMKTime* time; ��������ʱ��
 4����BMKRoutePlan����������@property (nonatomic, retain) BMKTime* time; ����Ԥ�Ƶ���ʻʱ��
  
 �Ż���
 1������BMKMapview�еĽӿ�- (void)removeAnnotations:(NSArray *)annotations;���Ƴ�һ���ע���������Ż�
 
 �޸���
 1���޸����ߵ�ͼ����֧�����߰��ĳ����б���ʡ�������ӳ��е�����
 2���޸�ǰ̨���������������̨opengl������Ⱦ��Ӧ��Crash������
 *********************/


/**
 *��ȡ��ǰ��ͼAPI�İ汾��
 *return  ���ص�ǰAPI�İ汾��
 */
UIKIT_STATIC_INLINE NSString* BMKGetMapApiVersion()
{
	return @"2.0.2";
}
