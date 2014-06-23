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
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;

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
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1];
    self.title = @"Itinéraire";
    
    UIView *itineraireFrame = [[UIView alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width - 10, 60)];
    itineraireFrame.backgroundColor = [UIColor whiteColor];
    itineraireFrame.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1].CGColor;
    itineraireFrame.layer.borderWidth = 1.0f;
    
    UIImage *switchImage = [UIImage imageNamed:@"switch"];
    self.switchFromAndTo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchFromAndTo.frame = CGRectMake(280.0, 15.0, 30.0, 30.0);
    [self.switchFromAndTo setBackgroundImage:switchImage forState:UIControlStateNormal];
    [self.switchFromAndTo addTarget:self action:@selector(switchFromAndToButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [itineraireFrame addSubview:self.switchFromAndTo];
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,4, 40, 20)];
    fromLabel.text = @"De";
    fromLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
    fromLabel.textColor = [UIColor colorWithRed:250.0f/255.0f green:130.0f/255.0f blue:77.0f/255.0f alpha:1];
    [itineraireFrame addSubview:fromLabel];
    
    self.fromInput = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, 240, 20)];
    self.fromInput.text = @"Ma localisation";
    self.fromInput.textColor = [UIColor colorWithRed:92.0f/255.0f green:173.0f/255.0f blue:96.0f/255.0f alpha:1];
    self.fromInput.font =  [UIFont fontWithName:@"Helvetica" size:(15.0)];
    self.fromInput.delegate = self;
    [itineraireFrame addSubview:self.fromInput];
    self.from = [[NSMutableDictionary alloc] init];
    [self.from setObject:@"Ma localisation" forKey:@"description"];
    [self.from setObject:@"true" forKey:@"isGeocalisation"];

    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(5, 30, 275, 1)];
    separator.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1];
    [itineraireFrame addSubview:separator];
    
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 34, 40, 20)];
    destinationLabel.text = @"Vers";
    destinationLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
    destinationLabel.textColor = [UIColor colorWithRed:250.0f/255.0f green:130.0f/255.0f blue:77.0f/255.0f alpha:1];
    [itineraireFrame addSubview:destinationLabel];
    
    self.destinationInput = [[UITextField alloc] initWithFrame:CGRectMake(45, 35, 240, 20)];
    self.destinationInput.text = [self.destination objectForKey:@"description"];
    self.destinationInput.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    self.destinationInput.font =  [UIFont fontWithName:@"Helvetica" size:(15.0)];
    self.destinationInput.delegate = self;
    [itineraireFrame addSubview:self.destinationInput];
    [self.view addSubview:itineraireFrame];
    
    UIView *transportModeFrame = [[UIView alloc] initWithFrame:CGRectMake(5, 80, self.view.frame.size.width - 10, 50)];
    transportModeFrame.layer.borderWidth = 1.0f;
    transportModeFrame.backgroundColor = [UIColor whiteColor];
    transportModeFrame.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1].CGColor;
    
    self.walkingBtnContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, transportModeFrame.frame.size.width / 2, 50)];
    self.walkingBtnContainer.tag = 1;
    self.walkingBtnContainer.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
    
    UITapGestureRecognizer *tapOnWalkingContainer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(walkingBtnSelected:)];
    [self.walkingBtnContainer addGestureRecognizer:tapOnWalkingContainer];
    self.walkingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.walkingBtn.frame = CGRectMake(50, 10, 30, 30);
    [self.walkingBtn setBackgroundImage:[UIImage imageNamed:@"walking"] forState:UIControlStateNormal];
    [self.walkingBtn addTarget:self action:@selector(walkingBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.walkingBtnContainer addSubview:self.walkingBtn];
    [transportModeFrame addSubview:self.walkingBtnContainer];
    
    UIView *separatorBtwWalkingAndBus = [[UIView alloc] initWithFrame:CGRectMake(self.walkingBtnContainer.frame.size.width, 0, 1, self.walkingBtnContainer.frame.size.height)];
    separatorBtwWalkingAndBus.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1];
    [transportModeFrame addSubview:separatorBtwWalkingAndBus];
    
    self.publicTransportBtnContainer = [[UIView alloc] initWithFrame:CGRectMake(self.walkingBtnContainer.frame.size.width + 1, 0, (transportModeFrame.frame.size.width / 2) - 1, 50)];
    UITapGestureRecognizer *tapOnPublicTransportContainer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(publicTransportBtnSelected:)];
    [self.publicTransportBtnContainer addGestureRecognizer:tapOnPublicTransportContainer];
    self.publicTransportBtnContainer.tag = 0;
    self.publicTransportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.publicTransportBtn.frame = CGRectMake(50,10, 30, 30);
    [self.publicTransportBtn addTarget:self action:@selector(publicTransportBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.publicTransportBtn setBackgroundImage:[UIImage imageNamed:@"transport"] forState:UIControlStateNormal];
    [self.publicTransportBtnContainer addSubview:self.publicTransportBtn];
    [transportModeFrame addSubview:self.publicTransportBtnContainer];
    [self.view addSubview:transportModeFrame];
    

    UIView *containerLabel = [[UIView alloc] initWithFrame:CGRectMake(5, 140, self.view.frame.size.width - 10, 40)];
    containerLabel.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1].CGColor;
    containerLabel.layer.borderWidth = 1.0f;
    containerLabel.backgroundColor = [UIColor whiteColor];
    UILabel *dateDepart = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, containerLabel.frame.size.width - 5, 40)];
    dateDepart.text = @"Date et heure de départ";
    dateDepart.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
    dateDepart.textColor = [UIColor colorWithRed:250.0f/255.0f green:130.0f/255.0f blue:77.0f/255.0f alpha:1];
    [containerLabel addSubview:dateDepart];
    [self.view addSubview:containerLabel];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.hidden = NO;
    self.datePicker.date = [NSDate date];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    UIView *datePickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 147, self.view.frame.size.width, 218)];
    datePickerContainer.transform = CGAffineTransformMakeScale(0.97f, 0.70f);
    [datePickerContainer addSubview:self.datePicker];
    datePickerContainer.layer.borderWidth = 1.0f;
    datePickerContainer.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1].CGColor;
    [self.view addSubview:datePickerContainer];
    
    self.itineraireRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itineraireRequest.frame = CGRectMake(70, 345, 200, 30);
    [self.itineraireRequest setTitle:@"Demander itinéraire" forState:UIControlStateNormal];
    // 135-206-250
    [self.itineraireRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.itineraireRequest.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:(15.0)];
    self.itineraireRequest.layer.cornerRadius = 8.0f;
    self.itineraireRequest.layer.masksToBounds= NO;
    self.itineraireRequest.layer.shadowColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1].CGColor;
    self.itineraireRequest.layer.shadowOpacity = 0.3;
    self.itineraireRequest.layer.shadowRadius = 1;
    self.itineraireRequest.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    self.itineraireRequest.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
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
    
    if ([self.fromInput.text isEqualToString:@"Ma localisation"]) {
        self.fromInput.textColor = [UIColor colorWithRed:92.0f/255.0f green:173.0f/255.0f blue:96.0f/255.0f alpha:1];
    }
    else {
        self.fromInput.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    }
    if ([self.destinationInput.text isEqualToString:@"Ma localisation"]) {
        self.destinationInput.textColor = [UIColor colorWithRed:92.0f/255.0f green:173.0f/255.0f blue:96.0f/255.0f alpha:1];
    }
    else {
        self.destinationInput.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
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
    [self.journeyCalculatorIndicator hide:YES];
}

-(void)resultForSearchGooglePlaceDetail:(NSMutableDictionary *)googleDetail
{
    if ([self.from objectForKey:@"latitude"] == nil) {
        [self.from setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lat"] forKey:@"latitude"];
        [self.from setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lng"] forKey:@"longitude"];
        
        if ([[self.destination valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
            CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
            [self.destination setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"latitude"];
            [self.destination setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"longitude"];
            accessibilityAPICaller.dateTime = self.datePicker.date;
            [accessibilityAPICaller searchJourney:self.from to:self.destination by:(self.walkingBtnContainer.tag == 1 ? @"walking" : @"transport")];
        }
        else if ([self.destination valueForKeyPath:@"latitude"] == nil) {
            [googleAPICaller searchGooglePlaceDetail:[self.destination valueForKey:@"reference"]];
        }
       else {
            accessibilityAPICaller.dateTime = self.datePicker.date;
            [accessibilityAPICaller searchJourney:self.from to:self.destination by:(self.walkingBtnContainer.tag == 1 ? @"walking" : @"transport")];
        }
    }
    else {
        [self.destination setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lat"] forKey:@"latitude"];
        [self.destination setValue:[googleDetail valueForKey:@"result"][@"geometry"][@"location"][@"lng"] forKey:@"longitude"];
        accessibilityAPICaller.dateTime = self.datePicker.date;
        [accessibilityAPICaller searchJourney:self.from to:self.destination by:(self.walkingBtnContainer.tag == 1 ? @"walking" : @"transport")];
    }
}

#pragma mark - Accessibility Journey API

- (void)resultSearchForJourney:(NSMutableArray *)journey
{
    if ([journey isEqual:[NSNull null]]) {
        [self.journeyCalculatorIndicator setLabelText:@"Aucun itinéraire trouvé"];
        self.journeyCalculatorIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x-mark"]];
        self.journeyCalculatorIndicator.customView.frame = CGRectMake(0, 0, 30, 30);
        self.journeyCalculatorIndicator.mode = MBProgressHUDModeCustomView;
        [self.journeyCalculatorIndicator hide:YES afterDelay:2];
    }
    else {
        if ([[journey valueForKey:@"result"] valueForKey:@"sections"] == nil) {
            [self.journeyCalculatorIndicator setLabelText:@"Aucun itinéraire trouvé"];
            self.journeyCalculatorIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x-mark"]];
            self.journeyCalculatorIndicator.customView.frame = CGRectMake(0, 0, 30, 30);
            self.journeyCalculatorIndicator.mode = MBProgressHUDModeCustomView;
            [self.journeyCalculatorIndicator hide:YES afterDelay:2];
            return;
        }
        [self.journeyCalculatorIndicator hide:YES];
        JourneyViewController *journeyView = [[JourneyViewController alloc]
                                              initWithJourney:[journey valueForKey:@"result" ]];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:journeyView];
        navigationController.navigationBar.translucent = NO;
        [self.navigationController presentViewController:navigationController animated:YES completion: nil];
    }
}

- (void)errorForJourneyRequest:(NSError *)error
{
    [self.journeyCalculatorIndicator setLabelText:@"Erreur du serveur"];
    self.journeyCalculatorIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x-mark"]];
    self.journeyCalculatorIndicator.customView.frame = CGRectMake(0, 0, 30, 30);
    self.journeyCalculatorIndicator.mode = MBProgressHUDModeCustomView;
    [self.journeyCalculatorIndicator hide:YES afterDelay:2];
    NSLog(@"ERROR FOR JOURNEY = %@", error);
}

#pragma mark - buttons handlers

- (IBAction)itineraireRequestBtnTapped:(id)sender
{
    self.journeyCalculatorIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.journeyCalculatorIndicator.labelText = @"Calcul de l'itinéraire";
    if ([[self.from valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
        CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
        [self.from setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"latitude"];
        [self.from setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"longitude"];
    }
    else if ([self.from valueForKeyPath:@"latitude"] == nil) {
        [googleAPICaller searchGooglePlaceDetail:[self.from valueForKey:@"reference"]];
        return;
    }
    
    if ([[self.destination valueForKey:@"isGeocalisation"] isEqualToString:@"true"]) {
        CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
        [self.destination setObject:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"latitude"];
        [self.destination setObject:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"longitude"];
    }
    else if ([self.destination valueForKeyPath:@"latitude"] == nil) {
        [googleAPICaller searchGooglePlaceDetail:[self.destination valueForKey:@"reference"]];
        return;
    }
    
    if ([self.destination valueForKeyPath:@"latitude"] != nil
        && [self.destination valueForKeyPath:@"latitude"] != nil) {
        accessibilityAPICaller.dateTime = self.datePicker.date;
        [accessibilityAPICaller searchJourney:self.from to:self.destination by:(self.walkingBtnContainer.tag == 1 ? @"walking" : @"transport")];
    }
}

- (IBAction)walkingBtnSelected:(id)sender
{
    if (self.walkingBtnContainer.tag == 1) {
        return;
    }
    else {
        self.walkingBtnContainer.tag = 1;
        self.walkingBtnContainer.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
        self.publicTransportBtnContainer.tag = 0;
        self.publicTransportBtnContainer.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)publicTransportBtnSelected:(id)sender
{
    if (self.publicTransportBtnContainer.tag == 1) {
        return;
    }
    else {
        self.publicTransportBtnContainer.tag = 1;
        self.publicTransportBtnContainer.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
        self.walkingBtnContainer.tag = 0;
        self.walkingBtnContainer.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)switchFromAndToButtonClicked:(id)sender
{
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.from];
    self.from = [[NSMutableDictionary alloc] initWithDictionary:self.destination];
    self.destination = tmp;
    self.fromInput.text = [self.from valueForKey:@"description"];
    if ([self.fromInput.text isEqualToString:@"Ma localisation"]) {
        self.fromInput.textColor = [UIColor colorWithRed:92.0f/255.0f green:173.0f/255.0f blue:96.0f/255.0f alpha:1];
    }
    else {
        self.fromInput.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    }
    self.destinationInput.text = [self.destination valueForKey:@"description"];
    if ([self.destinationInput.text isEqualToString:@"Ma localisation"]) {
        self.destinationInput.textColor = [UIColor colorWithRed:92.0f/255.0f green:173.0f/255.0f blue:96.0f/255.0f alpha:1];
    }
    else {
        self.destinationInput.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    }
}

@end
