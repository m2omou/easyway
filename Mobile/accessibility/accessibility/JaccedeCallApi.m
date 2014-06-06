//
//  jaccedeCallApi.m
//  accessibility
//
//  Created by Tchikovani on 04/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "JaccedeCallApi.h"
#import "MF_Base64Additions.h"
#import "AFNetworking.h"

#define kJxdHeaderTimestamp @"x-jispapi-timestamp"
#define kJxdHeaderAuth @"Authorization"
#define kJxdApiAccessKey @"test-jispapi-secret-access-key"
#define kJxdApiAccessKeyId @"test-jispapi-access-key-id"

@implementation JaccedeCallApi



- (NSDictionary *)jxdAuthHeadersForPath:(NSString *)path requestMethod:(NSString *)method atTime:(long)now {
    
    
    NSString *signature = [self signatureForRequestMethod:method urlPath:path atTime:now];
    NSString *authHeader = [NSString stringWithFormat:@"%@ %@:%@", kJxdHeaderAuth, kJxdApiAccessKeyId, signature];
    
    NSString *timestampHeader = [NSString stringWithFormat:@"%ld", now];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:timestampHeader forKey:kJxdHeaderTimestamp];
    [headers setObject:authHeader forKey:kJxdHeaderAuth];
    
    return headers;
}

- (NSString *)signatureForRequestMethod:(NSString *)method urlPath:(NSString *)path atTime:(long)now {
    
    NSString *toSign = [NSString stringWithFormat:@"%@\n%@:%ld\n%@",
                        [method uppercaseString], kJxdHeaderTimestamp, now, path];
    
    const char* cKey = [kJxdApiAccessKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char* cData = [toSign cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMACDest[CC_SHA1_DIGEST_LENGTH]; //dest buffer
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMACDest);
    
    NSData *hmacData = [[NSData alloc] initWithBytes:cHMACDest length:CC_SHA1_DIGEST_LENGTH];
    
    const uint8_t *bytes = [hmacData bytes];
    size_t length = [hmacData length];
    char dest[2*length+1];
    char *dst = &dest[0];
    for( size_t i=0; i<length; i+=1 )
        dst += sprintf(dst,"%02x", bytes[i]);
    
    NSString *hmacString = [[NSString alloc] initWithBytes: dest length: 2*length encoding: NSUTF8StringEncoding];
    return [hmacString base64String];
}

- (NSMutableArray *)searchPlaces:(NSString *)what where:(NSString *)location
{
    int numberOfParameters = 0;
    
    NSString *url = [NSString stringWithFormat:@"http://dev.jaccede.com/api/v2/places/search/?"];
    if (what != nil) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"what=%@", what]];
        numberOfParameters += 1;
    }
    if (location != nil) {
        if (numberOfParameters == 1) {
            url = [url stringByAppendingString:@"&"];
        }
        url = [url stringByAppendingString:[NSString stringWithFormat:@"where=%@", location]];
    }
    double unixTs = [[NSDate date] timeIntervalSince1970];
    NSNumber *nowSecs = [NSNumber numberWithDouble:unixTs];
    NSDictionary *headers = [self jxdAuthHeadersForPath:@"/api/v2/places/search/" requestMethod:@"GET" atTime:[nowSecs longValue]];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    for (NSString* HTTPHeaderField in headers) {
        id value = [headers objectForKey:HTTPHeaderField];
        [manager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderField];
    }
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *results = [responseObject valueForKeyPath:@"results"];
        results = [results valueForKey:@"items"];
        [self.delegate resultSearch:results];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    return NULL;
}

@end
