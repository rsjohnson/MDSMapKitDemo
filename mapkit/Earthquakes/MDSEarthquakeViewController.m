//
//  MDSEarthquakeViewController.m
//  MapKit Demo
//
//  Created by Ryan Johnson on 4/8/12.
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


#import "MDSEarthquakeViewController.h"
#import "MDSEarthquake.h"

@interface MDSEarthquakeViewController ()
{
  IBOutlet MKMapView * _mapView;
  NSMutableArray * _earthquakes;
}

- (void) loadEarthquakes;

@end

@implementation MDSEarthquakeViewController

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
  [self loadEarthquakes];
  [_mapView addAnnotations:_earthquakes];
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

- (void) loadEarthquakes 
{
  _earthquakes = [NSMutableArray array];
  
  NSURL * jsonURL = [[NSBundle mainBundle] URLForResource:@"earthquakes" withExtension:@"json"];
  NSData * jsonData = [NSData dataWithContentsOfURL:jsonURL];

  NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:0
                                                          error:nil];
  
  NSArray * earthquakes = [json objectForKey:@"earthquakes"];
  for (NSDictionary * jsonEarthquake in earthquakes) {
    MDSEarthquake * earthquake = [MDSEarthquake instanceFromDictionary:jsonEarthquake];
    [_earthquakes addObject:earthquake];
  }
}

#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  NSString * const kAnnotationIdentifier = @"Pin";
  MKAnnotationView * view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];

  if (!view)
    view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                        reuseIdentifier:kAnnotationIdentifier];
  else
    view.annotation = annotation;

  view.canShowCallout = YES;


  //[(MKPinAnnotationView*)view setPinColor:[(MDSEarthquake*)annotation pinColor]];
  view.image = [(MDSEarthquake*)annotation annotationImage];
  view.draggable = YES;

  return view;
}

@end
