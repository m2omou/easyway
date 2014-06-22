//
//  DifficultiesAPI.h
//  accessibility
//
//  Created by Tchikovani on 19/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Difficulty.h"

@protocol DifficultiesAPIDelegate

@optional
-(void)sendDifficultyAnswer:(Difficulty *)difficulty answer:(BOOL)isSucceed;
-(void)sendDifficultiesPin:(NSArray *)difficulties;

@end

@interface DifficultiesAPI : NSObject

@property (nonatomic, weak) id  delegate;

- (void)sendDifficulty:(Difficulty *)difficulty;
- (void)getDifficultiesPin:(int)radius for:(CLLocationCoordinate2D)center;

@end
