//
//  MapViewController.m
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

#import "MapViewController.h"
@import Mapbox;

@interface MapViewController () <MGLMapViewDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property CLLocationCoordinate2D humburgCenterPoint;

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

@end
