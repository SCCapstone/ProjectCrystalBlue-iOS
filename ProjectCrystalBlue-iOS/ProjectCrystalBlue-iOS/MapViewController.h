//
//  MapViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/21/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate>
{
    IBOutlet MKMapView *mapView;
}

- (id)initWithKey:(NSString*)initKey
          withLat:(NSString*)initLat
         withLong:(NSString*)initLong;
@end
