//
//  jaccedeCallApi.h
//  accessibility
//
//  Created by Tchikovani on 04/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <Foundation/Foundation.h>

// declare our class
@class jaccedeCallApi;

// define the protocol for the delegate
@protocol jaccedeCallApiDelegate

// define protocol functions that can be used in any class using this delegate
-(void)resultSearch:(NSMutableArray *)results;

@end

@interface jaccedeCallApi : NSObject

@property (nonatomic, weak) id  delegate;

- (NSMutableArray *)searchPlaces:(NSString *)what where:(NSString *)location;

@end
