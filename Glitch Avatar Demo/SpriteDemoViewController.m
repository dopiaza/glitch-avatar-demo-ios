//
//  SpriteDemoViewController.m
//  GlitchTestApp
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen Services Limited. All rights reserved.
//

#import "SpriteDemoViewController.h"
#import "AuthenticationRequiredViewController.h"

@implementation SpriteDemoViewController

@synthesize sprite = _sprite;
@synthesize buttonPanel = _buttonPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [GlitchCentral sharedInstance].delegate = nil;

    [_sprite release];
    _sprite = nil;
    
    [_buttonPanel release];
    _buttonPanel = nil;
    [super dealloc];
}



#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)adjustViewsForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) 
    {
        self.sprite.center = CGPointMake(80, 140);
        self.buttonPanel.frame = CGRectMake(180, 50, 280, 167);
    }
    else
    {
        self.sprite.center = CGPointMake(160, 320);
        self.buttonPanel.frame = CGRectMake(20, 20, 280, 167);
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustViewsForOrientation:interfaceOrientation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonPanel.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [GlitchCentral sharedInstance].delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GlitchCentral sharedInstance].delegate = self;
    
    if ([[GlitchCentral sharedInstance] isAuthenticated])
    {
        [[GlitchCentral sharedInstance] refreshData];
    }
    else
    {
        AuthenticationRequiredViewController *vc = [[AuthenticationRequiredViewController alloc] initWithNibName:@"AuthenticationRequiredViewController" bundle:nil];
        [self presentModalViewController:vc animated:YES];
        [vc release];
    }
}

-(void)authenticated
{
    [self dismissModalViewControllerAnimated:YES];
    [[GlitchCentral sharedInstance] refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    [self.sprite unpause];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sprite pause];
}


-(IBAction)happy
{
    [self.sprite playAnimation:@"happy" repeat:1];        
}

-(IBAction)surprise
{
    [self.sprite playAnimation:@"surprise" repeat:1];        
}

-(IBAction)angry
{
    [self.sprite playAnimation:@"angry" repeat:1];        
}

-(IBAction)walk
{
    [self.sprite playAnimation:@"walk1x" repeat:0];    
}

-(IBAction)idle
{
    [self.sprite showIdle];        
}

-(IBAction)climb
{
    [self.sprite playAnimation:@"climb" repeat:0];        
}

-(IBAction)sleep
{
    [self.sprite playAnimation:@"idleSleepyLoop" repeat:0];        
}

-(IBAction)jump
{
    [self.sprite playAnimation:@"jumpOver_test_sequence" repeat:1];        
}

-(IBAction)run
{
    [self.sprite playAnimation:@"walk3x" repeat:0];        
}

- (void)dataRefreshed
{
    self.sprite.animationSet = [[GlitchCentral sharedInstance] playerAnimations];
}

-(void)spriteDataLoaded:(GlitchSprite *)sprite
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    self.buttonPanel.alpha = 0.0;
    self.buttonPanel.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^(void) 
     {
         self.buttonPanel.alpha = 1.0;
     } 
    completion:^(BOOL finished) 
     {
         [self.sprite showIdle];
         
     }];
}

-(void)sprite:(GlitchSprite *)sprite animationEndedWithName:(NSString *)name
{
    [self.sprite showIdle];
}


@end
