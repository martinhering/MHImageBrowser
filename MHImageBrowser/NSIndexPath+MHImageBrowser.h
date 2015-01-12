//
//  NSIndexPath+MHImageBrowser.h
//  MHImageBrowser
//
//  Created by Martin Hering on 12.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (MHImageBrowser)
+ (NSIndexPath *)indexPathForItem:(NSUInteger)item inGroup:(NSUInteger)group;
@property (nonatomic, readonly) NSUInteger group;
@property (nonatomic, readonly) NSUInteger item;
@end
