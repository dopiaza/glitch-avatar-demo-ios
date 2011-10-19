//
//  LLDictionary.h
//  Lumen
//
//  Created by David Wilkinson on 08/05/2011.
//  Copyright 2011 Lumen Services Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (LLDictionary)

-(NSInteger)intValueForKey:(NSString *)key;
-(long)longValueForKey:(NSString *)key;
-(float)floatValueForKey:(NSString *)key;

@end
