//
//  GlitchAnimationSet.h
//  Glitch
//
//  Created by David Wilkinson on 23/07/2011.
//  Copyright 2011 Lumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlitchAnimationSet : NSObject

-(id)initWithDictionary:(NSDictionary *)dict;
-(id)initWithObject:(NSObject *)object;

@property (readonly, nonatomic) NSMutableDictionary *spritesheets;
@property (readonly, nonatomic) NSMutableDictionary *animations;

@end
