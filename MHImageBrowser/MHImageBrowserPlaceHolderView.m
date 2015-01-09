//
//  MHImageBrowserPlaceHolderView.m
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "MHImageBrowserPlaceHolderView.h"

@implementation MHImageBrowserPlaceHolderView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    CGFloat w = NSWidth(self.bounds);
    
    [[NSColor colorWithWhite:1 alpha:0.05] set];
    
    NSRect r = NSInsetRect(self.bounds, w*0.1, w*0.1);
    
    NSBezierPath* roundedRectPath = [NSBezierPath bezierPathWithRoundedRect:r xRadius:10 yRadius:10];
    [roundedRectPath fill];
    
    [[NSColor colorWithWhite:0.35 alpha:1] set];
    
    CGFloat dashes[] = {w*0.1, w*0.02};
    [roundedRectPath setLineDash:dashes count:2 phase:0.0];
    [roundedRectPath setLineWidth:w*0.015];
    [roundedRectPath stroke];
}

@end
