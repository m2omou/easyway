//
//  AddDifficultyViewController.h
//  accessibility
//
//  Created by Tchikovani on 18/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <UIKit/UIKit.h>
#import "Difficulty.h"

@protocol AddDifficultyDelegate

// define protocol functions that can be used in any class using this delegate
-(void)cancelAddDifficulty;
-(void)difficultySaved:(Difficulty *)difficulty;

@end

@interface AddDifficultyViewController : UIViewController

@property (nonatomic, weak) id  delegate;
@property(assign, nonatomic) CLLocationCoordinate2D position;

@end
