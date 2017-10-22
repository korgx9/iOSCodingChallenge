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

@end
