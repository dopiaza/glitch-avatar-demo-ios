//
//  GlitchSprite.m
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import "GlitchSprite.h"
#import "GlitchSpriteSheet.h"
#import "GlitchAnimationFrame.h"
#import "GlitchAnimation.h"
#import "DZDataCache.h"
#import "DZDataLoader.h"

#define kTimerInterval 0.03

@interface GlitchSpriteImageData : NSObject 
{
@public
    NSMutableData *data;
    NSURL *url;
    NSString *name;
}

@end

@implementation GlitchSpriteImageData

-(void)dealloc
{
    [data release];
    [url release];
    [name release];
    [super dealloc];
}

@end


@interface GlitchSprite ()

-(void)setupAnimations;
-(void)loadImage:(NSString *)imageUrl withName:(NSString *)name;
-(void)processImage:(UIImage *)image withName:(NSString *)name;
-(void)checkForComplete;

                                               
@property (retain, nonatomic) NSMutableDictionary *animations;
@property (retain, nonatomic) NSMutableDictionary *frames;
@property (retain, nonatomic) NSMutableDictionary *images;
@property (retain, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) NSUInteger counter;
@property (retain, nonatomic) NSMutableDictionary *connectionMap;               // counter -> NSURLConnection
@property (retain, nonatomic) NSMutableDictionary *dataMap;               // counter -> GlitchSpriteImageData

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger currentAnimationFrameIndex;
@property (assign, nonatomic) NSInteger animationIterations;
@property (retain, nonatomic) GlitchAnimation* currentAnimation;
@property (assign, nonatomic) BOOL idle;

@end

@implementation GlitchSprite

@synthesize animationSet = _animationSet;
@synthesize animations = _animations;
@synthesize frames = _frames;
@synthesize images = _images;
@synthesize counter = _counter;
@synthesize dataMap = _dataMap;
@synthesize connectionMap = _connectionMap;
@synthesize imageView = _imageView;
@synthesize spriteDelegate = _spriteDelegate;
@synthesize timer = _timer;
@synthesize currentAnimation = _currentAnimation;
@synthesize currentAnimationFrameIndex = _currentAnimationFrameIndex;
@synthesize animationIterations = _animationIterations;
@synthesize idle = _idle;

-(void)initData
{
    self.animations = [NSMutableDictionary dictionaryWithCapacity:12];
    self.frames = [NSMutableDictionary dictionaryWithCapacity:100];
    self.images = [NSMutableDictionary dictionaryWithCapacity:12];
    self.dataMap = [NSMutableDictionary dictionaryWithCapacity:12];
    self.connectionMap = [NSMutableDictionary dictionaryWithCapacity:12];
    
    self.imageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    self.imageView.autoresizingMask = UIViewAutoresizingNone;    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    self.clipsToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) 
    {
        [self initData];
    }
    return self;    
}

-(void)setAnimationSet:(GlitchAnimationSet *)theAnimationSet
{
    GlitchAnimationSet *tmp = [_animationSet retain];
    [_animationSet release];
    _animationSet = [theAnimationSet retain];
    [tmp release];
    
    [self setupAnimations];
}

-(void)setupAnimations
{
    // Load all the images
    for (NSString *name in self.animationSet.spritesheets)
    {
        GlitchSpriteSheet *ss = [self.animationSet.spritesheets objectForKey:name];
        [self loadImage:ss.url withName:name];
    }
    [self checkForComplete];
}

-(void)processImage:(UIImage *)image withName:(NSString *)name
{
    GlitchSpriteSheet *ss = [self.animationSet.spritesheets objectForKey:name];
    CGSize sheetSize = image.size;
    CGSize frameSize = CGSizeMake(sheetSize.width/ss.columns, sheetSize.height/ss.rows);
    [self.images setObject:image forKey:name];
    
    int row = 0;
    int col = 0;
    for (NSNumber *frameNumber in ss.frames)
    {
        CGRect f = CGRectMake(col * frameSize.width, row * frameSize.height, frameSize.width, frameSize.height);
        GlitchAnimationFrame *frame = [GlitchAnimationFrame animationFrameWithImage:image frame:f];
        [self.frames setObject:frame forKey:frameNumber];
        if (++col >= ss.columns)
        {
            col = 0;
            row++;
        }
    }
}

-(GlitchAnimation *)animationForName:(NSString *)animationName
{
    return [self.animationSet.animations objectForKey:animationName];
}

-(NSArray *)framesForAnimationName:(NSString *)name
{
    NSMutableArray *f = [self.frames objectForKey:name];
    if (f == nil)
    {
        GlitchAnimation *animation = [self animationForName:name];
        if (animation)
        {
            NSArray *frameList = animation.frames;
            if (frameList)
            {
                f = [NSMutableArray arrayWithCapacity:[frameList count]];
                for (NSNumber *frameNumber in frameList) 
                {
                    [f addObject:[self.frames objectForKey:frameNumber]];
                }
                [self.frames setObject:f forKey:name];
            }
        }
    }
    return f;
}

-(void)showFrame:(GlitchAnimationFrame *)frame 
{
    self.imageView.image = frame.image;
    CGRect f = frame.frame;
    
    // Resize to fit
    CGFloat dx = self.frame.size.width - f.size.width;
    CGFloat dy = self.frame.size.height - f.size.height;
    self.frame = CGRectMake(self.frame.origin.x + dx/2, self.frame.origin.y + dy/2, f.size.width, f.size.height);
    self.imageView.frame = CGRectMake(-f.origin.x, -f.origin.y, frame.image.size.width, frame.image.size.height);
}

-(void)startTimer
{
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)showIdleFrame
{
    [self stopAnimation];
    NSArray *frames = [self framesForAnimationName:@"idle0"];
    if ([frames count] > 0)
    {
        [self showFrame:[frames objectAtIndex:0]];
    }
}

-(void)playAnimation:(NSString *)name repeat:(NSInteger)numberOfTimes
{
    self.idle = NO;
    GlitchAnimation *animation = [self animationForName:name];
    NSArray *frames = [self framesForAnimationName:@"idle0"];
    if ([frames count] > 0)
    {
        [self startTimer];
        
        [self showFrame:[frames objectAtIndex:0]]; 
        self.currentAnimation = animation;
        self.currentAnimationFrameIndex = 0;
        self.animationIterations = numberOfTimes;
    }
}

-(void)stopAnimation
{
    self.idle = NO;
    if (self.timer)
    {
        [self stopTimer];
        self.currentAnimation = nil;
    }
}

-(void)pause
{
    [self stopTimer];
}

-(void)unpause
{
    if (self.currentAnimation)
    {
        [self startTimer];
    }
}

-(void)showIdle
{
    BOOL firstTime = !self.idle;
    
    NSString *name = @"idle4";
    if (!firstTime)
    {
        // Choose randomly
        int n = arc4random() % 16;
        switch (n) 
        {
            case 1:
            case 2:
                name = @"idle1";
                break;
                
            case 3:
            case 4:
                name = @"idle2";
                break;

            case 5:
                name = @"idle3";
                break;

            default:
                name = @"idle4";
                break;
        }
    }

    [self playAnimation:name repeat:1];
    self.idle = YES;
}

- (void)timerTick:(NSTimer*)theTimer
{
    NSArray *frames = [self framesForAnimationName:self.currentAnimation.name];
    
    if (frames && [frames count] > 0)
    {
        self.currentAnimationFrameIndex++;
        if (self.currentAnimationFrameIndex >= frames.count)
        {
            // Loop if required
            if (self.animationIterations >= 1)  // 0 is used for indefinitely
            {
                if (--self.animationIterations == 0)
                {
                    // We're done with this animation
                    // If we're in idle mode, choose another idle animation, otherwise quit
                    if (self.idle)
                    {
                        [self showIdle];
                    }
                    else
                    {
                        NSString *name = self.currentAnimation.name;
                        [self stopAnimation];
                        if (self.spriteDelegate && [self.spriteDelegate respondsToSelector:@selector(sprite:animationEndedWithName:)])
                        {
                            [self.spriteDelegate sprite:self animationEndedWithName:name];
                        }
                        return;
                    }
                }
            }
            
            // One more time
            self.currentAnimationFrameIndex = 0;
        }
        
        [self showFrame:[frames objectAtIndex:self.currentAnimationFrameIndex]];
    }
    else
    {
        // No frames
        [self stopAnimation];
    }
}

-(void)dealloc
{
    [_animationSet release];
    _animationSet = nil;
    
    [_animations removeAllObjects];
    [_animations release];
    _animations = nil;
    
    [_frames removeAllObjects];
    [_frames release];
    _frames = nil;
    
    [_images removeAllObjects];
    [_images release];
    _images = nil;
    
    for (NSURLConnection *c in _connectionMap) 
    {
        [c cancel];
    }
    [_connectionMap removeAllObjects];
    [_connectionMap release];
    _connectionMap = nil;
    
    [_dataMap removeAllObjects];
    [_dataMap release];
    _dataMap = nil;
    
    [_imageView release];
    _imageView = nil;
    
    [_timer invalidate];
    [_timer release];
    _timer = nil;
    
    [_currentAnimation release];
    _currentAnimation = nil;
    
    [super dealloc];
}

-(void)loadImage:(NSString *)imageUrl withName:(NSString *)name
{
    NSLog(@"Loading %@", name);
    if (imageUrl && [imageUrl length] > 0)
	{
		NSURL *theURL = [NSURL URLWithString:imageUrl];
		
		// First of all, check the cache.
		NSData *cachedImageData = [[DZDataCache sharedDataCache] cachedDataForUrl:theURL];
        
        if (cachedImageData)
		{
			UIImage *image = [[UIImage alloc] initWithData:cachedImageData];
            [self processImage:image withName:name];
			[image release];
		}
		else 
		{
			NSNumber *key = [NSNumber numberWithUnsignedInt:self.counter++];
			
            GlitchSpriteImageData *data = [[GlitchSpriteImageData alloc] init];
            data->data = [[NSMutableData dataWithCapacity:10000] retain];
            data->url = [theURL retain];
            data->name = [name retain];
			[self.dataMap setObject:data forKey:key];
            [data release];			
            
			// And start the load
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL: theURL
														cachePolicy: NSURLRequestUseProtocolCachePolicy
													timeoutInterval: 30.0];
			
			NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
			
			// and we save the connection for later
            [self.connectionMap setObject:connection forKey:key];
			[connection release];
		}
    }
}

-(NSNumber *)findKeyForConnection:(NSURLConnection *) connection
{
	NSNumber *number = nil;
	
	NSArray *keys = [self.connectionMap allKeysForObject:connection];
	if ([keys count] > 0)
	{
		number = [keys objectAtIndex:0];
	}
	
	return number;
}

-(void)checkForComplete
{
    if ([self.connectionMap count] == 0)
    {
        // We're done
        if (self.spriteDelegate)
        {
            [self.spriteDelegate spriteDataLoaded:self];
        }
    }
}

-(BOOL)loaded
{
    return (self.animationSet && [self.connectionMap count] == 0);
}

#pragma mark - NSURLConnection delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSNumber *key = [self findKeyForConnection:connection];
    GlitchSpriteImageData *d = [self.dataMap objectForKey:key];
	NSMutableData *imageData = d->data;
	[imageData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData: (NSData *) data
{
	NSNumber *key = [self findKeyForConnection:connection];
    GlitchSpriteImageData *d = [self.dataMap objectForKey:key];
	NSMutableData *imageData = d->data;
	[imageData appendData: data];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError: (NSError *) error
{
	NSNumber *key = [self findKeyForConnection:connection];
    [self.dataMap removeObjectForKey:key];
    [self.connectionMap removeObjectForKey:key];
    [self checkForComplete];
}

- (void)connectionDidFinishLoading: (NSURLConnection *) connection
{
	NSNumber *key = [self findKeyForConnection:connection];
    GlitchSpriteImageData *d = [self.dataMap objectForKey:key];
	NSMutableData *imageData = d->data;
	UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self processImage:image withName:d->name];
	[image release];
        
    [[DZDataCache sharedDataCache] storeDataInCache:imageData forUrl:d->url];
    
    [self.dataMap removeObjectForKey:key];
    [self.connectionMap removeObjectForKey:key];
    [self checkForComplete];
}



@end
