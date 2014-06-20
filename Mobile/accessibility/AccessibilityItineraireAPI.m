//
//  AccessibilityItineraireAPI.m
//  accessibility
//
//  Created by Tchikovani on 08/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "AFNetworking.h"
#import "AccessibilityItineraireAPI.h"

#define URL_SERVER "http://54.183.73.49:3000/journeys.json?"

@implementation AccessibilityItineraireAPI

- (void)searchJourney:(NSMutableDictionary *)from to:(NSMutableDictionary *)direction
{
    NSString *fromString = [NSString stringWithFormat:@"%@,%@", [from valueForKey:@"longitude"], [from valueForKey:@"latitude"]];
    NSString *toString = [NSString stringWithFormat:@"%@,%@", [direction valueForKey:@"longitude"], [direction valueForKey:@"latitude"]];
    NSString *url = [NSString stringWithFormat:@"%sfrom=%@&to=%@&datetime=20140620T0800", URL_SERVER, fromString, toString];
    NSLog(@"URL POUR JOURNEY = %@", url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate resultSearchForJourney:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate errorForJourneyRequest:error];
    }];
}

@end
