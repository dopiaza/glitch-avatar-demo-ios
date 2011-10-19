//
//  Glitch.h
//  GlitchInventory
//
//  Created by David Wilkinson on 20/02/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Glitch.h"
#import "GlitchAnimationSet.h"
#import "GlitchError.h"

@protocol GlitchDelegate <NSObject>

@optional
- (void)dataRefreshed;
- (void)authenticated;
- (void)glitchError:(GlitchError *)error;

@end

@protocol GlitchApiDelegate <NSObject>

@optional
- (void)glitchPlayerAnimationsLoaded:(GlitchAnimationSet *)animations;
- (void)glitchAPIError:(NSError *)error;

@end

@interface GlitchCentral : NSObject 
<GCSessionDelegate, GCRequestDelegate>
{
}

+(GlitchCentral *)sharedInstance;

-(void)refreshData;

-(void)authenticate;
-(BOOL)isAuthenticated;

-(void)handleOpenURL:(NSURL *)url;

@property (nonatomic, assign) id<GlitchDelegate> delegate;

@property (nonatomic, readonly) GlitchAnimationSet *playerAnimations;

@end
