//
//  GooglePlacesAPI.m
//  accessibility
//
//  Created by Tchikovani on 08/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "AFNetworking.h"
#import "GooglePlacesAPI.h"

#define kGOOGLE_API_KEY @"AIzaSyChDT7OcuZVbbBTrpixoG6rP_0ws4HuZH4"

@implementation GooglePlacesAPI

- (void)searchGooglePlaces:(NSString *)searchInput
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=fr&sensor=true&key=%@", searchInput, kGOOGLE_API_KEY];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *predictions = [responseObject valueForKeyPath:@"predictions"];
        if ([predictions count] > 0) {
            NSMutableArray *searchResults = [NSMutableArray arrayWithArray:predictions];
            [self.delegate resultSearchForPOIPlaces:searchResults];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)searchGooglePlaceDetail:(NSString *)reference
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", reference, kGOOGLE_API_KEY];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate resultForSearchGooglePlaceDetail:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate errorGoogleAPIGetDetail:error];
    }];
}

@end
