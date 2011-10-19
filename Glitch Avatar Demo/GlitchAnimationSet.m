//
//  GlitchAnimationSet.m
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchAnimationSet.h"
#import "GlitchSpriteSheet.h"
#import "GlitchAnimation.h"
#import "LLDictionary.h"

@implementation GlitchAnimationSet

@synthesize spritesheets = _spritesheets;
@synthesize animations = _animations;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _spritesheets = [[NSMutableDictionary alloc] initWithCapacity:12];
        _animations = [[NSMutableDictionary alloc] initWithCapacity:12];

        NSObject *sheetsObject = [dict objectForKey:@"sheets"];
        if (sheetsObject)
        {
            NSMutableDictionary *sheetsList = (NSMutableDictionary *)[dict objectForKey:@"sheets"];
            
            for (NSString *name in [sheetsList allKeys]) 
            {
                NSDictionary *d = [sheetsList objectForKey:name];
                if ([d isKindOfClass:[NSDictionary class]])
                {
                    GlitchSpriteSheet *ss = [[GlitchSpriteSheet alloc] init];
                    ss.name = name;
                    ss.rows = [d intValueForKey:@"rows"];
                    ss.columns = [d intValueForKey:@"cols"];
                    ss.url = [d objectForKey:@"url"];
                    
                    NSArray *f = [d objectForKey:@"frames"];
                    if ([f isKindOfClass:[NSArray class]])
                    {
                        ss.frames = f;
                    }
                    [self.spritesheets setObject:ss forKey:name];
                    [ss release];
                }
            }
        }
        
        NSObject *animationsObject = [dict objectForKey:@"anims"];
        if (animationsObject)
        {
            NSMutableDictionary *animationsList = (NSMutableDictionary *)[dict objectForKey:@"anims"];
            
            for (NSString *name in [animationsList allKeys]) 
            {
                NSArray *a = [animationsList objectForKey:name];
                if ([a isKindOfClass:[NSArray class]])
                {
                    GlitchAnimation *anim = [[GlitchAnimation alloc] init];
                    anim.name = name;
                    anim.frames = a;
                    [self.animations setObject:anim forKey:name];
                    [anim release];
                }
            }
        }
    }
    
    return self;
}

-(id) initWithObject:(NSObject *)object
{
    if ([object isKindOfClass:[NSDictionary class]])
    {
        self = [self initWithDictionary:(NSDictionary *)object];
    }
    else
    {
        self = [super init];
    }
    
    return self;
}

-(void)dealloc
{
    [_spritesheets release];
    _spritesheets = nil;
    
    [_animations release];
    _animations = nil;
    
    [super dealloc];
}

@end
