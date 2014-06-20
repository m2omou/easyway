//
//  DifficultyWithPicView.m
//  accessibility
//
//  Created by Tchikovani on 18/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "DifficultyWithPicView.h"

@implementation DifficultyWithPicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.description.layer.borderColor = [UIColor blackColor].CGColor;
        self.description.layer.borderWidth = 1.0f;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
