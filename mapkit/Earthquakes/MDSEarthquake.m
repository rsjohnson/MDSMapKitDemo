//
//  MDSEarthquake.m
//  
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


#import <CoreLocation/CoreLocation.h>
#import "MDSEarthquake.h"

@implementation MDSEarthquake

@synthesize datetime = _datetime;
@synthesize depth = _depth;
@synthesize eqid = _eqid;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize magnitude = _magnitude;
@synthesize src = _src;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize pinColor = _pinColor;

- (id) init {
  self = [super init];
  if (self) {
    _pinColor = MKPinAnnotationColorGreen;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.datetime forKey:@"datetime"];
    [encoder encodeObject:self.depth forKey:@"depth"];
    [encoder encodeObject:self.eqid forKey:@"eqid"];
    [encoder encodeObject:self.lat forKey:@"lat"];
    [encoder encodeObject:self.lng forKey:@"lng"];
    [encoder encodeObject:self.magnitude forKey:@"magnitude"];
    [encoder encodeObject:self.src forKey:@"src"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.datetime = [decoder decodeObjectForKey:@"datetime"];
        self.depth = [decoder decodeObjectForKey:@"depth"];
        self.eqid = [decoder decodeObjectForKey:@"eqid"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.magnitude = [decoder decodeObjectForKey:@"magnitude"];
        self.src = [decoder decodeObjectForKey:@"src"];
    }
    return self;
}


+ (MDSEarthquake *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    MDSEarthquake *instance = [[MDSEarthquake alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.datetime = [aDictionary objectForKey:@"datetime"];
    self.depth = [aDictionary objectForKey:@"depth"];
    self.eqid = [aDictionary objectForKey:@"eqid"];
    self.lat = [aDictionary objectForKey:@"lat"];
    self.lng = [aDictionary objectForKey:@"lng"];
    self.magnitude = [aDictionary objectForKey:@"magnitude"];
    self.src = [aDictionary objectForKey:@"src"];

}

#pragma mark - Setters/Getters

- (void) setLat:(NSNumber *)lat {
  [self willChangeValueForKey:@"coordinate"];
  _lat = lat;
  [self didChangeValueForKey:@"coordinate"];
}

- (void) setLng:(NSNumber *)lng {
  [self willChangeValueForKey:@"coordinate"];
  _lng = lng;
  [self didChangeValueForKey:@"coordinate"];
}

- (void) setDatetime:(NSString *)datetime {
  _datetime = datetime;
  _title = datetime;
}

- (void) setMagnitude:(NSNumber *)magnitude {
  _subtitle = [NSString stringWithFormat:@"Magnitude: %i", magnitude.intValue];
  _magnitude = magnitude;
  
  // Set the Pin Color
  int magnitudeInt = [_magnitude intValue];
  if (magnitudeInt >= 6)
    _pinColor = MKPinAnnotationColorRed;
  else if (magnitudeInt == 5)
    _pinColor = MKPinAnnotationColorPurple;
  else 
    _pinColor = MKPinAnnotationColorGreen;
}

- (UIImage*) annotationImage {
  NSString * imageName = [NSString stringWithFormat:@"mag%i", _magnitude.intValue];
  return [UIImage imageNamed:imageName];
}

#pragma mark - MKOverlay Properties

- (CLLocationCoordinate2D) coordinate {
  return CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate {
  self.lat = [NSNumber numberWithDouble:newCoordinate.latitude];
  self.lng = [NSNumber numberWithDouble:newCoordinate.longitude];
  NSLog(@"Coordinate Updated:Lat:%@ Lng:%@",self.lat, self.lng);
}


@end
