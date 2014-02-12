//
//  LunchAnnotation.m
//  LunchTimer
//
//  Created by Paul Downs on 04/01/2013.
//  Copyright (c) 2013 Paul Downs. All rights reserved.
//

#import "LunchAnnotation.h"

@implementation LunchAnnotation

- (id)init {
    self = [super init];
    if (self != nil) {
        self.title = @"Lunch Region";
    }
    
    return self;
}


- (id)initWithCLCircularRegion:(CLCircularRegion *)newRegion {
    self = [self init];
    
    if (self != nil) {
        self.region = newRegion;
        self.coordinate = newRegion.center;
        self.radius = newRegion.radius;
        self.title = @"Lunch Region";
    }
    
    return self;
}


/*
 This method provides a custom setter so that the model is notified when the subtitle value has changed.
 */
- (void)setRadius:(CLLocationDistance)newRadius {
    [self willChangeValueForKey:@"subtitle"];
    
    _radius = newRadius;
    
    [self didChangeValueForKey:@"subtitle"];
}


- (NSString *)subtitle {
    return [NSString stringWithFormat: @"Lat: %.4F, Lon: %.4F, Rad: %.1fm",
            self.coordinate.latitude,
            self.coordinate.longitude,
            self.radius];
}

@end
