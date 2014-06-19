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

@interface WalkingPathViewController () <GMSMapViewDelegate, UIAlertViewDelegate, AddDifficultyDelegate>

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
    UILabel *infoAddDifficulty = [[UILabel alloc] initWithFrame:CGRectMake(7, self.mapView.frame.size.height, self.view.frame.size.width - 14, 50)];
    infoAddDifficulty.text = @"Pressez la localisation pour y rajouter une difficulté";
    CGSize size = [infoAddDifficulty.text sizeWithFont:infoAddDifficulty.font constrainedToSize:CGSizeMake(135, 50) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = infoAddDifficulty.frame;
    
    // Resize only if needs to grow, don't shrink
    if (frame.size.height < size.height) {
        frame.size.height = size.height;
    }
    
    infoAddDifficulty.frame = frame;
    infoAddDifficulty.textAlignment = NSTextAlignmentCenter;
    infoAddDifficulty.numberOfLines = 0;
    [self.view addSubview:infoAddDifficulty];
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAddDifficulty
{
    self.mapView.selectedMarker.map = nil;
}

- (void)difficultySaved:(Difficulty *)difficulty
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(coordinate.latitude + 0.002,coordinate.longitude)];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    marker.icon = [UIImage imageNamed:@"warning"];
    marker.map = mapView;
    [self.mapView setSelectedMarker:marker];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rajout de difficulté"
                                                    message:@"Voulez vous rajoutez une difficulté à cet endroit ?"
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"Oui", nil];
    [alert show];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    if ([self.difficultiesArray count] > 0) {
        NSArray *results = [self.difficultiesArray filteredArrayUsingPredicate:[NSPredicate
                                                                                       predicateWithFormat:@"(latitude == %lf) AND (longitude == %lf)", marker.position.latitude, marker.position.longitude]];
        if ([results count] == 0) {
            return nil;
        }
        Difficulty *difficulty = [results objectAtIndex:0];
        DifficultyWithPicView *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"DifficultyWithPicView" owner:self options:nil] objectAtIndex:0];
        infoWindow.description.text = [NSString stringWithString:difficulty.description];
        infoWindow.pictureView.image = [UIImage imageWithCGImage:difficulty.picture.CGImage scale:1.0 orientation:UIImageOrientationRight];
        return infoWindow;
    }
    return nil;
}

/*
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(marker.position.latitude + 0.002, marker.position.longitude)];
    return YES;
}*/

@end
