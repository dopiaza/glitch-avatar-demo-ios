//
//  LLDictionary.m
//  Lumen
//
//  Created by David Wilkinson on 08/05/2011.
//  Copyright 2011 Lumen Services Limited. All rights reserved.
//

#import "LLDictionary.h"


@implementation NSDictionary (LLDictionary)

-(NSInteger)intValueForKey:(NSString *)key
{
    NSInteger ret = 0;
    
    NSObject *o = [self objectForKey:key];
    if ([o isKindOfClass:[NSNumber class]])
    {
        ret = [(NSNumber *)o intValue];
    }
    else if ([o isKindOfClass:[NSString class]])
    {
        ret = [(NSString *)o intValue];
    }
    
    return ret;
}

-(long)longValueForKey:(NSString *)key
{
    NSInteger ret = 0;
    
    NSObject *o = [self objectForKey:key];
    if ([o isKindOfClass:[NSNumber class]])
    {
        ret = [(NSNumber *)o longValue];
    }
    else if ([o isKindOfClass:[NSString class]])
    {
        ret = [(NSString *)o intValue];
    }
    
    return ret;
}

-(float)floatValueForKey:(NSString *)key;
{
    float ret = 0.0;
    
    NSObject *o = [self objectForKey:key];
    if ([o isKindOfClass:[NSNumber class]])
    {
        ret = [(NSNumber *)o floatValue];
    }
    else if ([o isKindOfClass:[NSString class]])
    {
        ret = [(NSString *)o floatValue];
    }

    
    return ret;
}

@end
