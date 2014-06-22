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

- (void)searchJourney:(NSMutableDictionary *)from to:(NSMutableDictionary *)direction by:(NSString *)mode
{
    NSString *fromString = [NSString stringWithFormat:@"%@,%@", [from valueForKey:@"longitude"], [from valueForKey:@"latitude"]];
    NSString *toString = [NSString stringWithFormat:@"%@,%@", [direction valueForKey:@"longitude"], [direction valueForKey:@"latitude"]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                         | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.dateTime];
    [components setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];

    NSString *date = [NSString stringWithFormat:@"%d%02d%02dT%02d%02d", [components year], [components month], [components day], [components hour], [components minute]];
    NSString *url = [NSString stringWithFormat:@"%sfrom=%@&to=%@&datetime=%@", URL_SERVER, fromString, toString, date];
    if ([mode isEqualToString:@"walking"]) {
        url = [url stringByAppendingString:@"&mode=walking"];
    }
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
