//
//  DifficultiesAPI.m
//  accessibility
//
//  Created by Tchikovani on 19/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "AFNetworking.h"
#import "DifficultiesAPI.h"

#define URL_SERVER "http://54.183.73.49:3000/warnings.json"

@implementation DifficultiesAPI

- (void)sendDifficulty:(Difficulty *)difficulty
{    
    NSString *url = [NSString stringWithFormat:@"%s", URL_SERVER];
    
    NSData *dataToUpload = UIImageJPEGRepresentation(difficulty.picture, 1.0);
    NSDictionary *parameters = @{@"utf8" : @"✓",
                                 @"warning[description]" : difficulty.description,
                                 @"warning[longitude]" : @(difficulty.longitude),
                                 @"warning[latitude]" : @(difficulty.latitude)
                                };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain", @"text/html", @"text/json", @"application/json"]];
    manager.responseSerializer = serializer;
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataToUpload name:@"warning[picture]" fileName:@"difficulty.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *responseDictionnary = (NSMutableDictionary *)responseObject;
        difficulty.idDifficulty = [[responseDictionnary valueForKey:@"id"] intValue];
        difficulty.thumbUrl = [NSString stringWithString:[responseDictionnary valueForKey:@"picture"][@"thumb"][@"url"]];
        difficulty.pictureUrl = [NSString stringWithString:[responseDictionnary valueForKey:@"picture"][@"url"]];
        [self.delegate sendDifficultyAnswer:difficulty answer:YES];
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate sendDifficultyAnswer:difficulty answer:NO];
        NSLog(@"Error: %@", error);
    }];
}

- (void)getDifficultiesPin:(int)radius for:(CLLocationCoordinate2D)center
{
    NSString *url = [NSString stringWithFormat:@"%s?radius=%d&latitude=%f&longitude=%f", URL_SERVER, 10000, center.latitude, center.longitude];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate sendDifficultiesPin:[(NSDictionary *)responseObject valueForKey:@"result"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
