//
//  SpriteDemoViewController.h
//  GlitchTestApp
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlitchCentral.h"
#import "GlitchSprite.h"

@interface SpriteDemoViewController : UIViewController
<GlitchDelegate, GlitchSpriteDelegate>
{
}

-(IBAction)happy;
-(IBAction)surprise;
-(IBAction)angry;
-(IBAction)walk;
-(IBAction)idle;
-(IBAction)climb;
-(IBAction)sleep;
-(IBAction)run;
-(IBAction)jump;

@property (nonatomic, retain) IBOutlet GlitchSprite* sprite;
@property (nonatomic, retain) IBOutlet UIView* buttonPanel;

@end
