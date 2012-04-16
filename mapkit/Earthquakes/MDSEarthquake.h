//
//  MDSEarthquake.h
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

#import <MapKit/MapKit.h>

@interface MDSEarthquake : NSObject 
< NSCoding,
  MKAnnotation > 

#pragma mark - MKAnnoation Properties
// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;

#pragma mark - JSON Properties / General
@property (nonatomic, copy) NSString *datetime;
@property (nonatomic, copy) NSNumber *depth;
@property (nonatomic, copy) NSString *eqid;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lng;
@property (nonatomic, copy) NSNumber *magnitude;
@property (nonatomic, copy) NSString *src;

@property (nonatomic, assign, readonly) MKPinAnnotationColor pinColor;
@property (nonatomic, assign, readonly) UIImage *annotationImage;

+ (MDSEarthquake *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
