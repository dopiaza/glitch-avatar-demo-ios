//
//  GlitchSpriteSheet.m
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchSpriteSheet.h"

@implementation GlitchSpriteSheet

@synthesize name = _name;
@synthesize columns = _columns;
@synthesize rows = _rows;
@synthesize frames = _frames;
@synthesize url = _url;

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
    
    [_url release];
    _url = nil;
    
    [super dealloc];
}

@end
