//
//  BuildJourneyViewController.m
//  accessibility
//
//  Created by Tchikovani on 05/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BuildJourneyViewController.h"
#import "GooglePlacesAPI.h"
#import "AccessibilityItineraireAPI.h"
#import "MBProgressHUD.h"
#import "JourneyViewController.h"
#import "EditLocationViewController.h"

@interface BuildJourneyViewController () <CLLocationManagerDelegate, UITextFieldDelegate, GooglePlacesAPIDelegate, AccessibilityItineraireAPIDelegate, EditLocationDelegate>
{
    GooglePlacesAPI *googleAPICaller;
    AccessibilityItineraireAPI *accessibilityAPICaller;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) UITextField *fromInput;
@property (nonatomic, strong) UITextField *destinationInput;
@property (nonatomic, strong) UIButton *switchFromAndTo;
@property (nonatomic, strong) UIView *walkingBtnContainer;
@property (nonatomic, strong) UIButton *walkingBtn;
@property (nonatomic, strong) UIView *publicTransportBtnContainer;
@property (nonatomic, strong) UIButton *publicTransportBtn;
@property (nonatomic, strong) UIButton *itineraireRequest;
@property (nonatomic, strong) MBProgressHUD *journeyCalculatorIndicator;

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
    accessibilityAPICaller = [[AccessibilityItineraireAPI alloc] init];
    accessibilityAPICaller.delegate = self;
    [self.destination setObject:@"false" forKey:@"isGeocalisation"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithRed:125.0f/255.0f green:167.0f/255.0f blue:212.0f/255.0f alpha:1];
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
    self.fromInput.delegate = self;
    [itineraireFrame addSubview:self.fromInput];
    self.from = [[NSMutableDictionary alloc] init];
    [self.from setObject:@"Ma localisation" forKey:@"description"];
    [self.from setObject:@"true" forKey:@"isGeocalisation"];

    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(5, 30, 280, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [itineraireFrame addSubview:separator];
    
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 34, 30, 20)];
    destinationLabel.text = @"Vers";
    destinationLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    destinationLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    [itineraireFrame addSubview:destinationLabel];
    
    self.destinationInput = [[UITextField alloc] initWithFrame:CGRectMake(40, 35, 250, 20)];
    self.destinationInput.text = [self.destination objectForKey:@"description"];
    self.destinationInput.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    self.destinationInput.delegate = self;
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
    [self.walkingBtn setBackgroundImage:[UIImage imageNamed:@"walking.png"] forState:UIControlStateNormal];
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
    [self.publicTransportBtn setBackgroundImage:[UIImage imageNamed:@"transport.png"] forState:UIControlStateNormal];
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

#pragma mark - Edit Location Delegate

- (void)newLocationSelected:(NSMutableDictionary *)results forLocation:(NSMutableDictionary *)location
{
    if ([self.from isEqualToDictionary:location]) {
        self.from = [[NSMutableDictionary alloc] initWithDictionary:results];
        self.fromInput.text = [self.from objectForKey:@"description"];
    }
    else {
        self.destination = [[NSMutableDictionary alloc] initWithDictionary:results];
        self.destinationInput.text = [self.destination objectForKey:@"description"];
    }
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    EditLocationViewController *editView = [[EditLocationViewController alloc] initWithNibName:@"EditLocationViewController" bundle:nil];
    editView.delegate = self;
    if ([textField.text isEqualToString:self.fromInput.text]) {
        editView.location = [[NSMutableDictionary alloc] initWithDictionary:self.from];
    }
    else {
        editView.location = [[NSMutableDictionary alloc] initWithDictionary:self.destination];
    }
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:editView];
    navigationController.navigationBar.translucent = NO;
    [self.navigationController presentViewController:navigationController animated:YES completion: nil];
    return NO;
}

#pragma mark - Google API delegate methods

-(void)errorGoogleAPIGetDetail:(NSError *)error;
{
    NSLog(@"Error Google PAI GET DETAIL = %@", error);
    [self.journeyCalculatorIndicator hide:YES];
}

-(void)resultForSearchGooglePlaceDetail:(NSMutableDictionary *)googleDetail
{
    if ([self.from objectForKey:@"latitude"] == nil) {
        [self.from setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lat"] forKey:@"latitude"];
        [self.from setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lng"] forKey:@"longitude"];
        NSLog(@"ON A RECU LES DETAILS POUR LE FROM");
    
        if ([[self.destination valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
            //CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
            //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"lat"];
            //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"lng"];
            [self.destination setObject:[NSString stringWithFormat:@"%f", 48.83256] forKey:@"latitude"];
            [self.destination setObject:[NSString stringWithFormat:@"%f", 2.287685] forKey:@"longitude"];
        }
        else if ([self.destination valueForKeyPath:@"latitude"] == nil) {
            NSLog(@"APRES AVOIR RECU DETAIL DE FROM, ON DEMANDE DETAIL POUR LATITUDE");
            [googleAPICaller searchGooglePlaceDetail:[self.destination valueForKey:@"reference"]];
        }
        else {
            NSLog(@"APRES AVOIR RECU DETAIL DE FROM, ON A DEJA LE DEST DONC ON DEMANDE ITINERAIRE");
            [accessibilityAPICaller searchJourney:self.from to:self.destination];
        }
    }
    else {
        NSLog(@"ON A RECU LES DETAILS POUR LE DESTINATION");
        [self.destination setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lat"] forKey:@"latitude"];
        [self.destination setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lng"] forKey:@"longitude"];
        [accessibilityAPICaller searchJourney:self.from to:self.destination];
    }
}

#pragma mark - Accessibility Journey API

- (void)resultSearchForJourney:(NSMutableDictionary *)journey
{
    if ([[journey valueForKey:@"result"][@"result"] isEqual:[NSNull null]]) {
        [self.journeyCalculatorIndicator setLabelText:@"Aucun itinéraire trouvé"];
        self.journeyCalculatorIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x-mark.png"]];
        self.journeyCalculatorIndicator.customView.frame = CGRectMake(0, 0, 30, 30);
        self.journeyCalculatorIndicator.mode = MBProgressHUDModeCustomView;
        [self.journeyCalculatorIndicator hide:YES afterDelay:2];
    }
    else {
        NSLog(@"JOURNEY = %@", [journey valueForKey:@"result"][@"result"]);
        [self.journeyCalculatorIndicator hide:YES];
        JourneyViewController *journeyView = [[JourneyViewController alloc]
                                              initWithJourney:[[journey valueForKey:@"result"][@"result"] objectAtIndex:0]];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:journeyView];
        navigationController.navigationBar.translucent = NO;
        [self.navigationController presentViewController:navigationController animated:YES completion: nil];
    }
}

- (void)errorForJourneyRequest:(NSError *)error
{
    NSLog(@"ERROR FOR JOURNEY = %@", error);
}

#pragma mark - buttons handlers

- (IBAction)itineraireRequestBtnTapped:(id)sender
{
    self.journeyCalculatorIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.journeyCalculatorIndicator.labelText = @"Calcul de l'itinéraire";
    if ([[self.from valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
        //CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
        //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"lat"];
        //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"lng"];
        [self.from setObject:[NSString stringWithFormat:@"%f", 48.838094] forKey:@"latitude"];
        [self.from setObject:[NSString stringWithFormat:@"%f", 2.286793] forKey:@"longitude"];
    }
    else if ([self.from valueForKeyPath:@"latitude"] == nil) {
        [googleAPICaller searchGooglePlaceDetail:[self.from valueForKey:@"reference"]];
        return;
    }
    
    if ([[self.destination valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
        //CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
        //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"lat"];
        //[self.pointA setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"lng"];
        [self.destination setObject:[NSString stringWithFormat:@"%f", 48.838094] forKey:@"latitude"];
        [self.destination setObject:[NSString stringWithFormat:@"%f", 2.286793] forKey:@"longitude"];
    }
    else if ([self.destination valueForKeyPath:@"latitude"] == nil) {
        [googleAPICaller searchGooglePlaceDetail:[self.destination valueForKey:@"reference"]];
        return;
    }
    
    if ([self.destination valueForKeyPath:@"latitude"] != nil
        && [self.destination valueForKeyPath:@"latitude"] != nil) {
        [accessibilityAPICaller searchJourney:self.from to:self.destination];
    }
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
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.from];
    self.from = [[NSMutableDictionary alloc] initWithDictionary:self.destination];
    self.destination = tmp;
    self.fromInput.text = [self.from valueForKey:@"description"];
    self.destinationInput.text = [self.destination valueForKey:@"description"];
}

@end
