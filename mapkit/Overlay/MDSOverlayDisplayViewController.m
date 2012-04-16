//
//  MDSOverlayDisplayViewController.m
//  MapKit Demo
//
//  Created by Ryan Johnson on 4/9/12.
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


#import "MDSOverlayDisplayViewController.h"

@interface MDSOverlayDisplayViewController ()
{
  IBOutlet MKMapView * _mapView;
}

- (IBAction) showOverlaySelectionAlert:(id)sender;
- (void) showPolylineOverlay;
- (void) showCircleOverlay;
- (void) showPolygonOverlay;
- (void) zoomMapToOverlay:(id<MKOverlay>)overlay;

@end

@implementation MDSOverlayDisplayViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - General

NSString * const kMKPolylineButtonTitle = @"MKPolyline";
NSString * const kMKCircleButtonTitle = @"MKCircle";
NSString * const kMKPolygonButtonTitle = @"MKPolygon";

- (IBAction) showOverlaySelectionAlert:(id)sender
{
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Select Overlay"
                                                   message:nil 
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:kMKPolylineButtonTitle, kMKCircleButtonTitle, kMKPolygonButtonTitle, nil];
  [alert show];
}

- (void) showPolylineOverlay
{
  NSURL * jsonURL = [[NSBundle mainBundle] URLForResource:@"polyline" withExtension:@"json"];
  NSData * jsonData = [NSData dataWithContentsOfURL:jsonURL];
  NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:0
                                                              error:nil];
  NSArray * jsonCoordinateArray = [jsonDict objectForKey:@"coordinates"];
  
  

  
  NSUInteger coordinateCount = [jsonCoordinateArray count]/2;
  CLLocationCoordinate2D coordinates[coordinateCount];
  for (NSUInteger i = 0; i < [jsonCoordinateArray count]; i +=2) {
    CLLocationDegrees lat = [[jsonCoordinateArray objectAtIndex:i] doubleValue];
    CLLocationDegrees lng = [[jsonCoordinateArray objectAtIndex:i+1] doubleValue];
    coordinates[i/2] = CLLocationCoordinate2DMake(lat, lng);
  }
  
  /* 
   Polylines can be created with either CLLocationCoordinate2Ds or with MKMapPoints. 
   We'll use Coordinates and let Apple handle the translation for us.
   */
  MKPolyline * polyline = [MKPolyline polylineWithCoordinates:coordinates 
                                                        count:coordinateCount];
  
  [_mapView addOverlay:polyline];
  [self zoomMapToOverlay:polyline];
}

- (void) showCircleOverlay
{
  CLLocationCoordinate2D centerCoordinate = {44.824949, -93.112988};
  CLLocationDistance radius = 5000; // Distance is in meters
  MKCircle * circle = [MKCircle circleWithCenterCoordinate:centerCoordinate
                                                    radius:radius];
  [_mapView addOverlay:circle];
  [self zoomMapToOverlay:circle];
}

- (void) showPolygonOverlay
{
  NSURL * jsonURL = [[NSBundle mainBundle] URLForResource:@"minnesota" withExtension:@"json"];
  NSData * jsonData = [NSData dataWithContentsOfURL:jsonURL];
  NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:0
                                                              error:nil];
  NSArray * jsonCoordinateArray = [jsonDict objectForKey:@"Minnesota"];
  
  
  
  
  NSUInteger coordinateCount = [jsonCoordinateArray count]/2;
  CLLocationCoordinate2D coordinates[coordinateCount];
  for (NSUInteger i = 0; i < [jsonCoordinateArray count]; i +=2) {
    CLLocationDegrees lat = [[jsonCoordinateArray objectAtIndex:i] doubleValue];
    CLLocationDegrees lng = [[jsonCoordinateArray objectAtIndex:i+1] doubleValue];
    coordinates[i/2] = CLLocationCoordinate2DMake(lat, lng);
  }
  
  MKPolygon * polygon = [MKPolygon polygonWithCoordinates:coordinates
                                                    count:coordinateCount];
  [_mapView addOverlay:polygon];
  [self zoomMapToOverlay:polygon];
}

- (void) zoomMapToOverlay:(id<MKOverlay>)overlay 
{
  [_mapView setVisibleMapRect:overlay.boundingMapRect
                     animated:YES];
}


#pragma mark - MapView Delegate Methods

- (MKOverlayView*) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {

  
  if ([overlay isKindOfClass:[MKPolyline class]]) {
    MKPolylineView * polylineView = [[MKPolylineView alloc] initWithPolyline:overlay]; 
    polylineView.lineWidth = 2;
    polylineView.strokeColor = [UIColor redColor];
    return polylineView;
  }
  else if ([overlay isKindOfClass:[MKCircle class]]) {
    MKCircleView * circleView = [[MKCircleView alloc] initWithCircle:overlay];
    circleView.lineWidth = 2;
    circleView.strokeColor = [UIColor colorWithWhite:.2 alpha:.5];
    circleView.fillColor = [UIColor colorWithWhite:.2 alpha:.3];
    return circleView;
  }
  else if ([overlay isKindOfClass:[MKPolygon class]]) {
    MKPolygonView * polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    polygonView.lineWidth = 5;
    polygonView.strokeColor = [UIColor blueColor];
    polygonView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.5];
    return polygonView;
  }

  
  
  return nil;
}


#pragma mark - UIAlertViewDelegate Methods
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == alertView.cancelButtonIndex)
    return;

  // Remove any displayed overlays
  [_mapView removeOverlays:_mapView.overlays];

  NSString * buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
  if ([buttonTitle isEqualToString:kMKPolylineButtonTitle]) {
      [self showPolylineOverlay];
  }
  else if ([buttonTitle isEqualToString:kMKCircleButtonTitle]) {
    [self showCircleOverlay];
  }
  else if ([buttonTitle isEqualToString:kMKPolygonButtonTitle]) {
    [self showPolygonOverlay];
  }

}


@end
