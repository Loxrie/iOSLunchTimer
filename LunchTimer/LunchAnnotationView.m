//
//  LunchAnnotationView.m
//  LunchTimer
//
//  Created by Paul Downs on 04/01/2013.
//  Copyright (c) 2013 Paul Downs. All rights reserved.
//

#import "LunchAnnotationView.h"
#import "LunchAnnotation.h"

@implementation LunchAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:[annotation title]];
    
    if (self) {
        self.canShowCallout = YES;
        self.multipleTouchEnabled = NO;
        self.draggable = YES;
        self.animatesDrop = YES;
        self.map = nil;
        self.lunchAnnotation = (LunchAnnotation *)annotation;
        self.pinColor = MKPinAnnotationColorPurple;
        radiusOverlay = [MKCircle circleWithCenterCoordinate:self.lunchAnnotation.coordinate radius:self.lunchAnnotation.radius];
        
        [self.map addOverlay:radiusOverlay];
    }
    
    return self;
}


- (void)removeRadiusOverlay {
    // Find the overlay for this annotation view and remove it if it has the same coordinates.
    for (id overlay in [self.map overlays]) {
        if ([overlay isKindOfClass:[MKCircle class]]) {
            MKCircle *circleOverlay = (MKCircle *)overlay;
            CLLocationCoordinate2D coord = circleOverlay.coordinate;
            
            if (coord.latitude == self.lunchAnnotation.coordinate.latitude &&
                coord.longitude == self.lunchAnnotation.coordinate.longitude) {
                
                [self.map removeOverlay:overlay];
            }
        }
    }
    
    isRadiusUpdated = NO;
}


- (void)updateRadiusOverlay {
    if (!isRadiusUpdated) {
        isRadiusUpdated = YES;
        
        [self removeRadiusOverlay];
        
        self.canShowCallout = NO;
        
        [self.map addOverlay:[MKCircle circleWithCenterCoordinate:self.lunchAnnotation.coordinate
                                                           radius:self.lunchAnnotation.radius]];
        
        self.canShowCallout = YES;
    }
}

@end
