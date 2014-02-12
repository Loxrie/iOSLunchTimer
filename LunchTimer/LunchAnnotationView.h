//
//  LunchAnnotationView.h
//  LunchTimer
//
//  Created by Paul Downs on 04/01/2013.
//  Copyright (c) 2013 Paul Downs. All rights reserved.
//

#import <MapKit/MapKit.h>

@class LunchAnnotation;

@interface LunchAnnotationView : MKPinAnnotationView {
@private
    MKCircle *radiusOverlay;
    BOOL isRadiusUpdated;
}

@property (nonatomic, assign) MKMapView *map;
@property (nonatomic, assign) LunchAnnotation *lunchAnnotation;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation;
- (void)updateRadiusOverlay;
- (void)removeRadiusOverlay;

@end
