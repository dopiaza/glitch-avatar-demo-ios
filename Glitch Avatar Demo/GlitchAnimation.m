//
//  GlitchAnimation.m
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchAnimation.h"

@implementation GlitchAnimation

@synthesize name = _name;
@synthesize frames = _frames;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    [_name release];
    _name = nil;
    
    [_frames release];
    _frames = nil;
    
    [super dealloc];
}


@end
