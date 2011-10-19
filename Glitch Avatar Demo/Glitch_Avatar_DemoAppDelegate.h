//
//  Glitch_Avatar_DemoAppDelegate.h
//  Glitch Avatar Demo
//
//  Created by David Wilkinson on 16/10/2011.
//  Copyright 2011 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpriteDemoViewController;

@interface Glitch_Avatar_DemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SpriteDemoViewController *viewController;

@end
