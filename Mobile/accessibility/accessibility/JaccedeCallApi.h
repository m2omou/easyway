//
//  jaccedeCallApi.h
//  accessibility
//
//  Created by Tchikovani on 04/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <Foundation/Foundation.h>

// declare our class
@class JaccedeCallApi;

// define the protocol for the delegate
@protocol JaccedeCallApiDelegate

// define protocol functions that can be used in any class using this delegate
-(void)resultSearch:(NSMutableArray *)results;

@end

@interface JaccedeCallApi : NSObject

@property (nonatomic, weak) id  delegate;

- (NSMutableArray *)searchPlaces:(NSString *)what where:(NSString *)location;

@end
