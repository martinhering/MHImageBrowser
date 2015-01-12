//
//  NSIndexPath+MHImageBrowser.m
//  MHImageBrowser
//
//  Created by Martin Hering on 12.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "NSIndexPath+MHImageBrowser.h"

@implementation NSIndexPath (MHImageBrowser)

+ (NSIndexPath *)indexPathForItem:(NSUInteger)item inGroup:(NSUInteger)group
{
    const NSUInteger indexes[] = {group, item};
    return [[NSIndexPath alloc] initWithIndexes:indexes length:2];
}

- (NSUInteger) group {
    return [self indexAtPosition:0];
}

- (NSUInteger) item {
    return [self indexAtPosition:1];
}
@end
