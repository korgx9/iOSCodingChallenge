//
//  MapViewController.m
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

#import "MapViewController.h"
#import "iOSCodingChallenge-Swift.h"
@import Mapbox;

@interface MapViewController () <MGLMapViewDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property CLLocationCoordinate2D humburgCenterPoint;
@property (retain, atomic) NSMutableArray *poiAnnotations;
@property (weak, nonatomic) PoiWrapper* poList;
@property BOOL isRequestSent;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"TesTaxi", "View Title class MapViewControlelr");
    
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    _mapView.logoView.hidden = YES;
    _mapView.maximumZoomLevel = 22;
    _mapView.minimumZoomLevel = 8.5;

    _humburgCenterPoint = CLLocationCoordinate2DMake(53.546252, 10.008154);

    _poiAnnotations = [[NSMutableArray alloc] init];
    _isRequestSent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePoisByNotification:)
                                                 name:@"PoisLoaded"
                                               object:nil];
    
    [_mapView setCenterCoordinate: _humburgCenterPoint
                        zoomLevel: 10
                         animated: NO];
}

// MARK: - MGLMapView Delegates
- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera {
    MGLMapCamera *currentCamera = mapView.camera;
    CLLocationCoordinate2D newCameraCenter = newCamera.centerCoordinate;
    mapView.camera = newCamera;
    MGLCoordinateBounds newVisibleCoordinates = mapView.visibleCoordinateBounds;
    mapView.camera = currentCamera;
    
    MGLCoordinateBounds hamburgBounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(53.17245, 9.644633),
                                                                CLLocationCoordinate2DMake(53.868691, 10.372931));
    
    BOOL inside = MGLCoordinateInCoordinateBounds(newCameraCenter, hamburgBounds);
    BOOL intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, hamburgBounds)
    && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, hamburgBounds);
    return inside && intersects;
}

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!_isRequestSent) {
        _isRequestSent = YES;
        [self getListOfPoiWithBounds: mapView.visibleCoordinateBounds];
    }
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    return nil;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

// MARK: - Miscellaneous methods
- (void)receivePoisByNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"PoisLoaded"]) {
        NSDictionary *userInfo = [notification userInfo];
        _poList = userInfo[@"poiList"];
        [self putPoisOnMap];
        _isRequestSent = NO;
    }
}

- (void)putPoisOnMap {
    [_mapView removeAnnotations: _mapView.annotations];
    [_poiAnnotations removeAllObjects];
    
    for (int i = 0; i < _poList.pois.count; i++) {
        MGLPointAnnotation *poiAnnotation = [[MGLPointAnnotation alloc] init];
        poiAnnotation.title = _poList.pois[i].type;
        poiAnnotation.subtitle = _poList.pois[i].state;
        poiAnnotation.coordinate = [_poList.pois[i] getCoordinates];
        
        [_poiAnnotations addObject: poiAnnotation];
    }
    
    [_mapView addAnnotations: _poiAnnotations];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DEALLOC CALLED IN MAPVIEWCONTROLLER");
}

@end
