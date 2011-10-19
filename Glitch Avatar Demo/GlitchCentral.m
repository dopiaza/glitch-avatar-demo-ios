//
//  Glitch.m
//  GlitchInventory
//
//  Created by David Wilkinson on 20/02/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchCentral.h"
#import "Glitch.h"
#import "LLDictionary.h"



GlitchCentral *_glitchSharedInstance;

@interface GlitchCentral ()

@property (nonatomic, retain) Glitch *api;
@property (nonatomic, assign) NSObject<GlitchDelegate> *apiDelegate;
@property (nonatomic, retain) GCRequest *infoRequest;
@property (nonatomic, retain) GCRequest *animationsRequest;

@end

@implementation GlitchCentral

@synthesize delegate = _delegate;
@synthesize apiDelegate = _apiDelegate;
@synthesize playerAnimations = _playerAnimations;
@synthesize api=_api;
@synthesize infoRequest = _infoRequest;
@synthesize animationsRequest = _animationsRequest;

+(GlitchCentral *)sharedInstance
{
    if (_glitchSharedInstance == nil) 
    {
        _glitchSharedInstance = [[GlitchCentral alloc] init];
    }
    
    return _glitchSharedInstance;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.api = [[[Glitch alloc] initWithDelegate:self] autorelease];
    }
    
    return self;
}

-(void)loadPlayerInfo 
{
    self.infoRequest = [self.api requestWithMethod:@"players.info" delegate:self];
    [self.infoRequest connect];
}


-(void)refreshData
{
    [self loadPlayerInfo];
}


-(void)dealloc
{
    [_api release];
    _api = nil;
    
    [_animationsRequest release];
    _animationsRequest = nil;
    
    [_infoRequest release];
    _infoRequest = nil;
    
    [super dealloc];
}

-(void)handleOpenURL:(NSURL *)url
{
    [self.api handleOpenURL:url];
}

-(void)glitchLoginSuccess
{
    if ([self.delegate respondsToSelector:@selector(authenticated)])
    {
        [self.delegate authenticated];
    }
}

-(void)glitchLoginFail:(NSError*)error
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Authentication Error" 
                                                 message:[error description] 
                                                delegate:nil 
                                       cancelButtonTitle:@"Close" 
                                       otherButtonTitles:nil];
    
    [av show];
    [av release];
}

-(void)authenticate
{
    [self.api authorizeWithScope:@"identity"];
}



-(BOOL)isAuthenticated
{
    return [self.api isAuthenticated];
}

// Called when request was completed
- (void)requestFinished:(GCRequest*)request withResult:(id)result
{
    // Perform validation on the response
    if ([result isKindOfClass:[NSDictionary class]])
    {
        // Get the status of the auth token
        id ok = [(NSDictionary*)result objectForKey:@"ok"];
        
        // Ensure that we're ok before proceeding! (the ok number is 1)
        if (ok && [ok isKindOfClass:[NSNumber class]] && [(NSNumber*)ok boolValue])
        {
            if (request == self.infoRequest)
            {
                NSString *tsid = [(NSDictionary*)result objectForKey:@"player_tsid"];
                self.animationsRequest = [self.api requestWithMethod:@"players.getAnimations" 
                                                            delegate:self 
                                                              params:[NSDictionary dictionaryWithObject:tsid forKey:@"player_tsid"]];
                
                [self.animationsRequest connect];
            }
            
            if (request == self.animationsRequest)
            {
                [_playerAnimations release];
                _playerAnimations = [[GlitchAnimationSet alloc] initWithDictionary:result];
                if ([self.delegate respondsToSelector:@selector(dataRefreshed)])
                {
                    [self.delegate dataRefreshed];
                }
            }
        }
    }
}


@end
