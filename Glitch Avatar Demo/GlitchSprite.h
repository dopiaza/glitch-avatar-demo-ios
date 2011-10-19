//
//  GlitchSprite.h
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlitchAnimationSet.h"

@class GlitchSprite;

@protocol GlitchSpriteDelegate <NSObject>

@optional
-(void)spriteDataLoaded:(GlitchSprite *)sprite; 
-(void)sprite:(GlitchSprite *)sprite animationEndedWithName:(NSString *)name; 

@end
@interface GlitchSprite : UIView

-(id)initWithFrame:(CGRect)frame;
-(void)playAnimation:(NSString *)name repeat:(NSInteger)numberOfTimes;
-(void)stopAnimation;
-(void)showIdleFrame;
-(void)showIdle;
-(void)pause;
-(void)unpause;


@property (retain, nonatomic) GlitchAnimationSet *animationSet;
@property (assign, nonatomic) IBOutlet NSObject<GlitchSpriteDelegate> *spriteDelegate;
@property (readonly, nonatomic) BOOL loaded;

@end
