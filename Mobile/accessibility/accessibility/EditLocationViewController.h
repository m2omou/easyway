//
//  EditLocationViewController.h
//  accessibility
//
//  Created by Tchikovani on 13/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <UIKit/UIKit.h>

// define the protocol for the delegate
@protocol EditLocationDelegate

// define protocol functions that can be used in any class using this delegate
-(void)newLocationSelected:(NSMutableDictionary *)results forLocation:(NSMutableDictionary *)location;

@end

@interface EditLocationViewController : UIViewController

@property (nonatomic, weak) id  delegate;
@property (nonatomic, strong) NSMutableDictionary *location;


@end
