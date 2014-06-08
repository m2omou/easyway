//
//  BuildJourneyViewController.m
//  accessibility
//
//  Created by Tchikovani on 05/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "BuildJourneyViewController.h"
#import "GooglePlacesAPI.h"

@interface BuildJourneyViewController () <googlePlacesAPIDelegate>
{
    GooglePlacesAPI *googleAPICaller;
}

@property (nonatomic, strong) UITextField *fromInput;
@property (nonatomic, strong) UITextField *destinationInput;
@property (nonatomic, strong) UIButton *switchFromAndTo;
@property (nonatomic, strong) UIView *walkingBtnContainer;
@property (nonatomic, strong) UIButton *walkingBtn;
@property (nonatomic, strong) UIView *publicTransportBtnContainer;
@property (nonatomic, strong) UIButton *publicTransportBtn;
@property (nonatomic, strong) UIButton *itineraireRequest;

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
    googleAPICaller = [[GooglePlacesAPI alloc] init];
    googleAPICaller.delegate = self;
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
    self.view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1];
    self.title = @"Itinéraire";
    
    UIView *itineraireFrame = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 60)];
    itineraireFrame.layer.borderWidth = 1.0f;
    itineraireFrame.backgroundColor = [UIColor whiteColor];
    itineraireFrame.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIImage *switchImage = [UIImage imageNamed:@"switch.png"];
    self.switchFromAndTo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchFromAndTo.frame = CGRectMake(285.0, 20.0, 20.0, 20.0);
    [self.switchFromAndTo setBackgroundImage:switchImage forState:UIControlStateNormal];
    [self.switchFromAndTo addTarget:self action:@selector(switchFromAndToButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [itineraireFrame addSubview:self.switchFromAndTo];
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,4, 30, 20)];
    fromLabel.text = @"De";
    fromLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    fromLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    [itineraireFrame addSubview:fromLabel];
    
    self.fromInput = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, 250, 20)];
    self.fromInput.text = @"Ma localisation";
    self.fromInput.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    [itineraireFrame addSubview:self.fromInput];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(5, 30, 280, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [itineraireFrame addSubview:separator];
    
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 34, 30, 20)];
    destinationLabel.text = @"Vers";
    destinationLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    destinationLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    [itineraireFrame addSubview:destinationLabel];
    
    self.destinationInput = [[UITextField alloc] initWithFrame:CGRectMake(40, 35, 250, 20)];
    self.destinationInput.text = [self.googleDestination objectForKey:@"description"];
    self.destinationInput.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    [self.googleDestination setObject:@"To" forKey:@"FromOrTo"];
    [itineraireFrame addSubview:self.destinationInput];
    [self.view addSubview:itineraireFrame];
    
    UIView *transportModeFrame = [[UIView alloc] initWithFrame:CGRectMake(5, 70, self.view.frame.size.width - 10, 90)];
    transportModeFrame.layer.borderWidth = 1.0f;
    transportModeFrame.backgroundColor = [UIColor whiteColor];
    transportModeFrame.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *transportModeInstruction = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 10, 20)];
    transportModeInstruction.textAlignment = NSTextAlignmentCenter;
    transportModeInstruction.text = @"Mode de transport";
    transportModeInstruction.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    [transportModeFrame addSubview:transportModeInstruction];
    
    UIView *separatorTransportMode = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width - 10, 1)];
    separatorTransportMode.backgroundColor = [UIColor blackColor];
    [transportModeFrame addSubview:separatorTransportMode];
    
    self.walkingBtnContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 26, transportModeFrame.frame.size.width / 2, transportModeFrame.frame.size.height - 27)];
    self.walkingBtnContainer.tag = 1;
    self.walkingBtnContainer.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:233.0f/255.0f alpha:1];
    
    UITapGestureRecognizer *tapOnWalkingContainer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(walkingBtnSelected:)];
    [self.walkingBtnContainer addGestureRecognizer:tapOnWalkingContainer];
    self.walkingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.walkingBtn.frame = CGRectMake(50, 5, 50, 50);
    [self.walkingBtn setBackgroundImage:[UIImage imageNamed:@"accessibility.png"] forState:UIControlStateNormal];
    [self.walkingBtn addTarget:self action:@selector(walkingBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.walkingBtnContainer addSubview:self.walkingBtn];
    [transportModeFrame addSubview:self.walkingBtnContainer];
    
    UIView *separatorBtwWalkingAndBus = [[UIView alloc] initWithFrame:CGRectMake(self.walkingBtnContainer.frame.size.width, 26, 1, self.walkingBtnContainer.frame.size.height)];
    separatorBtwWalkingAndBus.backgroundColor = [UIColor blackColor];
    [transportModeFrame addSubview:separatorBtwWalkingAndBus];
    
    self.publicTransportBtnContainer = [[UIView alloc] initWithFrame:CGRectMake(self.walkingBtnContainer.frame.size.width + 1, 26, (transportModeFrame.frame.size.width / 2) - 1, transportModeFrame.frame.size.height - 27)];
    UITapGestureRecognizer *tapOnPublicTransportContainer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(publicTransportBtnSelected:)];
    [self.publicTransportBtnContainer addGestureRecognizer:tapOnPublicTransportContainer];
    self.publicTransportBtnContainer.tag = 0;
    self.publicTransportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.publicTransportBtn.frame = CGRectMake(50,5, 50, 50);
    [self.publicTransportBtn addTarget:self action:@selector(publicTransportBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.publicTransportBtn setBackgroundImage:[UIImage imageNamed:@"bus.png"] forState:UIControlStateNormal];
    [self.publicTransportBtnContainer addSubview:self.publicTransportBtn];
    [transportModeFrame addSubview:self.publicTransportBtnContainer];
    [self.view addSubview:transportModeFrame];
    
    self.itineraireRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itineraireRequest.frame = CGRectMake(70, 170, 200, 30);
    [self.itineraireRequest setTitle:@"Demander itinéraire" forState:UIControlStateNormal];
    [self.itineraireRequest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.itineraireRequest.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
    self.itineraireRequest.backgroundColor = [UIColor whiteColor];
    self.itineraireRequest.layer.borderColor = [UIColor blackColor].CGColor;
    self.itineraireRequest.layer.borderWidth = 1.0f;
    [self.itineraireRequest addTarget:self action:@selector(itineraireRequestBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.itineraireRequest];
}

- (void)resultSearchForPOIDetail:(NSMutableDictionary *)result
{
    NSLog(@"Latitude and longitude = %@ and %@", [result valueForKey:@"result"][@"geometry"][@"location"][@"lat"], [result valueForKey:@"result"][@"geometry"][@"location"][@"lng"]);
}

#pragma mark - buttons handlers

- (IBAction)itineraireRequestBtnTapped:(id)sender
{
    [googleAPICaller searchGooglePlaceDetail:[self.googleDestination valueForKey:@"reference"]];
}

- (IBAction)walkingBtnSelected:(id)sender
{
    if (self.walkingBtnContainer.tag == 0) {
        self.walkingBtnContainer.tag = 1;
        self.walkingBtnContainer.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:233.0f/255.0f alpha:1];
        self.publicTransportBtnContainer.tag = 0;
        self.publicTransportBtnContainer.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.walkingBtnContainer.tag = 0;
        self.walkingBtnContainer.backgroundColor = [UIColor whiteColor];
        self.publicTransportBtnContainer.tag = 1;
        self.publicTransportBtnContainer.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:233.0f/255.0f alpha:1];
    }
}

- (IBAction)publicTransportBtnSelected:(id)sender
{
    if (self.publicTransportBtnContainer.tag == 0) {
        self.publicTransportBtnContainer.tag = 1;
        self.publicTransportBtnContainer.backgroundColor =[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:233.0f/255.0f alpha:1];
        self.walkingBtnContainer.tag = 0;
        self.walkingBtnContainer.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.publicTransportBtnContainer.tag = 0;
        self.publicTransportBtnContainer.backgroundColor = [UIColor whiteColor];
        self.walkingBtnContainer.tag = 1;
        self.walkingBtnContainer.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:233.0f/255.0f alpha:1];
    }
}

- (IBAction)switchFromAndToButtonClicked:(id)sender
{
    
}

@end
