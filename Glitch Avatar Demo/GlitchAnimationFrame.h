//
//  GlitchAnimationFrame.h
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlitchAnimationFrame : NSObject

+(id)animationFrameWithImage:(UIImage *)theImage frame:(CGRect)theFrame;

-(id)initWithImage:(UIImage *)theImage frame:(CGRect)theFrame;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGRect frame;

@end
