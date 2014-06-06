//
//  BuildJourneyViewController.m
//  accessibility
//
//  Created by Tchikovani on 05/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "BuildJourneyViewController.h"

@interface BuildJourneyViewController ()

@property (nonatomic, strong) UITextField *destinationInput;
@property (nonatomic, strong) UILabel *destinationLabel;

@end

@implementation BuildJourneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 45, 35)];
    self.destinationLabel.text = @"To";
    
    [self.view addSubview:self.destinationLabel];
    self.destinationInput = [[UITextField alloc] initWithFrame:CGRectMake(55, 120, 220, 35)];
    self.destinationInput.text = [self.googleDestination objectForKey:@"description"];
    [self.googleDestination setObject:@"To" forKey:@"FromOrTo"];
    [self.view addSubview:self.destinationInput];

}

@end
