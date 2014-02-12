//
//  LunchAnnotation.h
//  LunchTimer
//
//  Created by Paul Downs on 04/01/2013.
//  Copyright (c) 2013 Paul Downs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LunchAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) CLCircularRegion *region;
@property (nonatomic, unsafe_unretained) CLLocationCoordinate2D coordinate;
@property (nonatomic, unsafe_unretained) CLLocationDistance radius;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCLCircularRegion:(CLCircularRegion *)newRegion;

@end
