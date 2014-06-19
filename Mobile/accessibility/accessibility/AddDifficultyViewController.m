//
//  AddDifficultyViewController.m
//  accessibility
//
//  Created by Tchikovani on 18/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "AddDifficultyViewController.h"
#import "UIImage+fixOrientation.h"

@interface AddDifficultyViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UITextView *descriptionField;

@end

@implementation AddDifficultyViewController

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
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Annuler"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(cancelAddDifficulty:)];
    self.navigationItem.rightBarButtonItem = cancelBtn;
    self.pictureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-photo"]];
    self.pictureView.frame = CGRectMake(50, 20, self.view.frame.size.width - 100, 150);
    self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    self.pictureView.layer.borderColor = [UIColor blackColor].CGColor;
    self.pictureView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.pictureView];
    
    UIButton *addPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPicture setTitle:@"Rajouter une photo" forState:UIControlStateNormal];
    [addPicture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    addPicture.frame = CGRectMake(30, 180, 260, 30);
    addPicture.layer.borderWidth = 1.0f;
    addPicture.layer.borderColor = [UIColor blackColor].CGColor;
    [addPicture addTarget:self action:@selector(addPictureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPicture];
    
    self.descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(10, 220, self.view.frame.size.width - 20, 100)];
    self.descriptionField.layer.borderWidth = 1.0f;
    self.descriptionField.layer.borderColor = [UIColor blackColor].CGColor;
    self.descriptionField.delegate = self;
    [self.view addSubview:self.descriptionField];
    
    UIButton *envoyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [envoyerBtn setTitle:@"Envoyer" forState:UIControlStateNormal];
    [envoyerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    envoyerBtn.frame = CGRectMake(30, 325, 260, 30);
    envoyerBtn.layer.borderWidth = 1.0f;
    envoyerBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [envoyerBtn addTarget:self action:@selector(sendBtnPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:envoyerBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notification
/**
 *  Keyboard will show
 */
- (void)keyboardWillShow:(NSNotification*)notification {
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - 216, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

/**
 *  Keyboard will hide
 */
- (void)keyboardWillHide:(NSNotification*)notification {
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y + 216, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
	}
    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage]fixOrientation];
    self.pictureView.image = image;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate methods

/*
 Action sheet delegate
 This method is for catching answer for camera query
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showImagePicker:(int)sourceType {
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
	ipc.sourceType = sourceType;
	ipc.delegate = self;
	ipc.allowsEditing = NO;
	[self.navigationController presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.descriptionField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Button selectors

-(IBAction)addPictureButtonTapped:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        // Create action sheet
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:(id)self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:
                                     @"Prendre une photo",
                                     @"Prendre dans la Bibliothèque",
                                     nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupQuery showInView:self.view];
    }
}

- (IBAction)cancelAddDifficulty:(id)sender
{
    [self.delegate cancelAddDifficulty];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendBtnPushed:(id)sender
{
    Difficulty *difficulty = [[Difficulty alloc] init];
    difficulty.description = self.descriptionField.text;
    difficulty.picture = [UIImage imageWithCGImage:self.pictureView.image.CGImage];
    difficulty.longitude = self.position.longitude;
    difficulty.latitude = self.position.latitude;
    [self.delegate difficultySaved:difficulty];
}

@end
