//
//  WalkingPathViewController.m
//  accessibility
//
//  Created by Tchikovani on 13/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "WalkingPathViewController.h"
#import "AddDifficultyViewController.h"
#import "DifficultyWithPicView.h"

@interface WalkingPathViewController () <GMSMapViewDelegate, UIAlertViewDelegate, AddDifficultyDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray *difficultiesArray;

@end

@implementation WalkingPathViewController

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
    self.difficultiesArray = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager stopUpdatingLocation];
}

- (void)loadView
{
    self.title = @"Path";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSMutableArray *startCoordinates = [self.geoJson objectForKey:@"coordinates"][0];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[startCoordinates objectAtIndex:1] doubleValue]
                                                            longitude: [[startCoordinates objectAtIndex:0]  doubleValue]
                                                                 zoom:16];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 125) camera:camera];
    
    self.mapView.delegate = self;
    GMSMutablePath *path = [GMSMutablePath path];
    
    NSMutableArray *coordinates = [self.geoJson objectForKey:@"coordinates"];
    
    GMSMarker *start = [[GMSMarker alloc] init];
    start.position = CLLocationCoordinate2DMake([[startCoordinates objectAtIndex:1] doubleValue], [[startCoordinates objectAtIndex:0]  doubleValue]);
    start.icon = [UIImage imageNamed:@"start"];
    start.map = self.mapView;
    for (NSMutableArray *coordinate in coordinates)
    {
        [path addLatitude:[[coordinate objectAtIndex:1] doubleValue] longitude:[[coordinate objectAtIndex:0] doubleValue]];
    }
    
    NSMutableArray *endCoordinates = [[self.geoJson objectForKey:@"coordinates"] lastObject];
    
    GMSMarker *end = [[GMSMarker alloc] init];
    end.position = CLLocationCoordinate2DMake([[endCoordinates objectAtIndex:1] doubleValue],[[endCoordinates objectAtIndex:0] doubleValue]);
    end.icon = [UIImage imageNamed:@"end"];
    end.map = self.mapView;
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = self.mapView;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height, self.view.frame.size.width, 50)];
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(addDifficultyBtn:)];
    [footer addGestureRecognizer:singleFingerTap];
    UIImageView *warningBtn = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    warningBtn.image = [UIImage imageNamed:@"big_warning"];
    [footer addSubview:warningBtn];
    
    UILabel *infoAddDifficulty = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 150, 50)];
    infoAddDifficulty.text =  @"Declarer une difficulté";
    infoAddDifficulty.textColor = [UIColor blackColor];
    infoAddDifficulty.font =  [UIFont fontWithName:@"Helvetica" size:(15.0)];
    infoAddDifficulty.textAlignment = NSTextAlignmentCenter;
    infoAddDifficulty.numberOfLines = 0;
    [footer addSubview:infoAddDifficulty];
    [self.view addSubview:footer];
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons handlers

- (IBAction)addDifficultyBtn:(id)sender
{
    [locationManager startUpdatingLocation];
    CLLocationCoordinate2D coordinates = [[locationManager location] coordinate];
    [locationManager stopUpdatingLocation];
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(coordinates.latitude + 0.002, coordinates.longitude)];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinates;
    marker.icon = [UIImage imageNamed:@"small_warning"];
    marker.map = self.mapView;
    [self.mapView setSelectedMarker:marker];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rajout de difficulté"
                                                    message:@"Voulez vous rajoutez a votre localisation ?"
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"Oui", nil];
    [alert show];
}

- (void)cancelAddDifficulty
{
    self.mapView.selectedMarker.map = nil;
}

- (void)difficultySaved:(Difficulty *)difficulty
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    difficulty.marker = self.mapView.selectedMarker;
    [self.difficultiesArray addObject:difficulty];
    [self.mapView setSelectedMarker:self.mapView.selectedMarker];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.mapView.selectedMarker.map = nil;
    }
    else if (buttonIndex == 1) {
        AddDifficultyViewController *view = [[AddDifficultyViewController alloc] initWithNibName:@"AddDifficultyViewController" bundle:nil];
        view.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:view];
        view.position = self.mapView.selectedMarker.position;
        navigationController.navigationBar.translucent = NO;
        [self.navigationController presentViewController:navigationController animated:YES completion: nil];
    }
}

#pragma mark - Google Map View Delegates methods

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    if ([self.difficultiesArray count] > 0) {
        NSArray *results = [self.difficultiesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(marker == %@)", marker]];
        NSLog(@"DIFFICULTIES ARRAY = %d\nRESULTS ARRAY = %d", [self.difficultiesArray count], [results count]);
        if ([results count] == 0) {
            return nil;
        }
        Difficulty *difficulty = [results objectAtIndex:0];
        DifficultyWithPicView *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DifficultyWithPicView" owner:self options:nil] objectAtIndex:0];
        infoWindow.description.text = [NSString stringWithString:difficulty.description];
        infoWindow.pictureView.image = difficulty.picture;
        infoWindow.description.layer.borderColor = [UIColor blackColor].CGColor;
        infoWindow.description.layer.borderWidth = 1.0f;
        return infoWindow;
    }
    return nil;
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if (self.mapView.selectedMarker == marker) {
        return NO;
    }
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(marker.position.latitude + 0.002, marker.position.longitude)];
    self.mapView.selectedMarker = marker;
    return YES;
}

@end
