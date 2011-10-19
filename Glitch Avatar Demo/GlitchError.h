//
//  GlitchError.h
//  GlitchInventory
//
//  Created by David Wilkinson on 19/03/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GlitchErrorNetworkNotReachable = 1,
    GlitchErrorAPIFailed,
    GlitchErrorInvalidToken
} GlitchErrorCode;

@interface GlitchError : NSError 
{
    
}

+(id)errorWithCode:(GlitchErrorCode)code description:(NSString *)description;

-(id)initWithCode:(GlitchErrorCode)code description:(NSString *)description;


@end
