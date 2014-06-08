//
//  GooglePlacesAPI.h
//  accessibility
//
//  Created by Tchikovani on 08/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GooglePlacesAPI;

@protocol googlePlacesAPIDelegate

@optional
-(void)resultSearchForPOIPlaces:(NSMutableArray *)results;
-(void)resultSearchForPOIDetail:(NSMutableDictionary *)result;

@end

@interface GooglePlacesAPI : NSObject

@property (nonatomic, weak) id  delegate;

- (void)searchGooglePlaces:(NSString *)searchInput;
- (void)searchGooglePlaceDetail:(NSString *)reference;

@end
