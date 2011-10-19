//
//  GlitchAnimationFrame.m
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchAnimationFrame.h"

@implementation GlitchAnimationFrame

@synthesize image = _image;
@synthesize frame = _frame;

+(id)animationFrameWithImage:(UIImage *)theImage frame:(CGRect)theFrame
{
    return [[[GlitchAnimationFrame alloc] initWithImage:theImage frame:theFrame] autorelease];
}

-(id)initWithImage:(UIImage *)theImage frame:(CGRect)theFrame
{
    self = [super init];
    if (self) 
    {
        self.image = theImage;
        self.frame = theFrame;
    }
    
    return self;
}

-(void)dealloc
{
    [_image release];
    _image = nil;
    
    [super dealloc];
}

@end
