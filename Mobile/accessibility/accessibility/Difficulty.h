//
//  Difficulty.h
//  accessibility
//
//  Created by Tchikovani on 18/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Difficulty : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) UIImage *picture;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (nonatomic, strong) GMSMarker *marker;

@end
