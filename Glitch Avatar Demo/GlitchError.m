//
//  GlitchError.m
//  GlitchInventory
//
//  Created by David Wilkinson on 19/03/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchError.h"


@implementation GlitchError


+(id)errorWithCode:(GlitchErrorCode)code description:(NSString *)description
{
    return [[[GlitchError alloc] initWithCode:code description:description] autorelease];
}

-(id)initWithCode:(GlitchErrorCode)code description:(NSString *)description
{
    self = [super initWithDomain:@"glitch" 
                            code:code
                         userInfo:[NSDictionary dictionaryWithObject:description 
                                                              forKey:NSLocalizedDescriptionKey]];

    return self;
}

@end
