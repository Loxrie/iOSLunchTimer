//
//  ViewController.m
//  LunchTimer
//
//  Created by Paul Downs on 13/12/2012.
//  Copyright (c) 2012 Paul Downs. All rights reserved.
//

#import "ViewController.h"
#import "LunchAnnotation.h"
#import "LunchAnnotationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *hitmeButton;

@property (strong) CLLocationManager *locationManager;
@property (strong) NSDate *startTime;
@property (strong) NSTimer *tickingClock;

@property (strong) LunchAnnotation *lunchAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CLLocationCoordinate2D homeless;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(homeless, 350, 350);
//    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:viewRegion animated:NO];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyBest;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTimer:(id)sender {
    self.timerLabel.text = @"00 : 00 : 00";
    self.startTime = [NSDate date];
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        CLCircularRegion *lunchRegion = [[CLCircularRegion alloc] initWithCenter:self.mapView.centerCoordinate
                                                                  radius:LUNCH_RADIUS
                                                              identifier:@"AlarmRegion"];
        
        // Make annotation.
        self.lunchAnnotation = [[LunchAnnotation alloc] initWithCLCircularRegion:lunchRegion];
        self.lunchAnnotation.coordinate = lunchRegion.center;
        self.lunchAnnotation.radius = lunchRegion.radius;
        
        [self.mapView addAnnotation:self.lunchAnnotation];
        [self.locationManager startMonitoringForRegion:lunchRegion];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                            message:@"Region monitoring not available."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.tickingClock invalidate];
    self.tickingClock = nil;
    self.startTime = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Stopped Monitoring"
                                                        message:@"You're back from lunch!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
    [self.locationManager stopMonitoringForRegion:self.lunchAnnotation.region];
    [self.mapView removeAnnotation:self.lunchAnnotation];
    self.lunchAnnotation = nil;
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    self.tickingClock = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(updateClock)
                                                       userInfo:nil
                                                        repeats:YES];
    self.startTime = [NSDate date];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Started Monitoring"
                                                        message:@"You're on lunch?"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    self.mapView.centerCoordinate = currentLocation.coordinate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[LunchAnnotation class]]) {
        LunchAnnotation *currentAnnotation = (LunchAnnotation *)annotation;
        NSString *annotationIdentifier = [currentAnnotation title];
        LunchAnnotationView *regionView = (LunchAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (!regionView) {
            regionView = [[LunchAnnotationView alloc] initWithAnnotation:annotation];
            regionView.map = mapView;
            
            // Create a button for the left callout accessory view of each annotation to remove the annotation and region being monitored.
            UIButton *removeRegionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [removeRegionButton setFrame:CGRectMake(0., 0., 25., 25.)];
            [removeRegionButton setImage:[UIImage imageNamed:@"RemoveRegion"] forState:UIControlStateNormal];
            
            regionView.leftCalloutAccessoryView = removeRegionButton;
        } else {
            regionView.annotation = annotation;
            regionView.lunchAnnotation = annotation;
        }
        
        // Update or add the overlay displaying the radius of the region around the annotation.
        [regionView updateRadiusOverlay];
        
        return regionView;
    }
    
    return nil;
}

- (void)updateClock {
    NSDate *now = [NSDate date];
    
    NSTimeInterval delta = [now timeIntervalSinceDate:self.startTime];
    
    NSUInteger h,m,s;
    h =  (delta/3600);
    m = ((NSUInteger)(delta / 60)) % 60;
    s = ((NSUInteger) delta) % 60;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02d : %02d : %02d", h, m, s];
}

@end
