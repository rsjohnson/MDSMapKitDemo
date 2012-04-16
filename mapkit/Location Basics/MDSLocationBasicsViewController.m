//
//  MDSLocationBasicsViewController.m
//  MapKit Demo
//
//  Created by Ryan Johnson on 3/18/12.
//  Copyright (c) 2012 mobile data solutions.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "MDSLocationBasicsViewController.h"


@interface MDSLocationBasicsViewController ()
< CLLocationManagerDelegate, 
  MKMapViewDelegate >
{
  CLLocationManager * _locationManager;
  IBOutlet MKMapView * _mapView;
  IBOutlet UITextView * _locationLog;
}


@end

@implementation MDSLocationBasicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
  _locationManager = [[CLLocationManager alloc] init];
  
  // Set the text which tells the user why we need their location
  _locationManager.purpose = @"We need your location so we can collect your location data,"
  "store it in our database, and sell it to advertisers and the NSA.";
  
  _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  _locationManager.delegate = self;
  [_locationManager startUpdatingLocation];

  CLLocationCoordinate2D regionCenter = {42.438917, -71.116146};
  CLLocationDistance regionRadius = 200; // CLLocationDistances are in meters
  CLRegion * region = [[CLRegion alloc] initCircularRegionWithCenter:regionCenter
                                                              radius:regionRadius
                                                          identifier:@"A Monitored Region"];
  [_locationManager startMonitoringForRegion:region
                             desiredAccuracy:0];
  
  
  
  
  
  MKCircle * circle = [MKCircle circleWithCenterCoordinate:regionCenter
                                                    radius:regionRadius];
  [_mapView addOverlay:circle];
  
  
  _mapView.showsUserLocation = YES;
  [_mapView setUserTrackingMode:MKUserTrackingModeFollow
                       animated:YES]; // new to iOS 5

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
  
  [_locationManager stopUpdatingLocation];
  for (CLRegion * region in [_locationManager monitoredRegions])
    [_locationManager stopMonitoringForRegion:region];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - CLLocationManagerDelegate Methods
- (void) locationManager:(CLLocationManager *)manager 
           didExitRegion:(CLRegion *)region {
  NSString * message = [NSString stringWithFormat:@"Exited Region: %@", region.identifier];
  _locationLog.text = message;
  _locationLog.backgroundColor = [UIColor whiteColor];
  
  if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
    UILocalNotification * notif = [[UILocalNotification alloc] init];
    notif.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
  }
  else {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Exited Region"
                                                     message:region.identifier
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];            
  }
}

- (void) locationManager:(CLLocationManager *)manager 
          didEnterRegion:(CLRegion *)region {
  NSString * message = [NSString stringWithFormat:@"Entered Region :%@", region.identifier];
  _locationLog.text = message;
  _locationLog.backgroundColor = [UIColor colorWithRed:.3 green:0 blue:0 alpha:1];

  if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
    UILocalNotification * notif = [[UILocalNotification alloc] init];
    notif.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
  }
  else {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Entered Region"
                                                     message:region.identifier
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];            
  }
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
  NSLog(@"Begun Monitoring Region:%@", region.identifier);
}

- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  NSLog(@"Region Monitoring For Region:%@ Failed With Error:%@", region.identifier, error.debugDescription);

}


- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {

  // Update the log text
  _locationLog.text = newLocation.description;
}

#pragma mark - MKMapViewDelegate Methods
- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
  if ([overlay isMemberOfClass:[MKCircle class]]) {
    MKCircleView * circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    
    circleView.fillColor = [UIColor colorWithWhite:.3 alpha:.3];
    circleView.strokeColor = [UIColor darkGrayColor];
      
    return circleView;
  }
  return nil;
}

@end
