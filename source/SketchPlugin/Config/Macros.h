//
//  Macros.h
//  SketchPlugin
//
//  Created by aboyko on 7/13/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//
@import AppKit;

static inline NSString *RSPLocalizedString(NSString *key) {
    return NSLocalizedStringFromTableInBundle(key, nil, [NSBundle bundleWithIdentifier:@"com.reinvently.sketchPlugin.SketchPlugin"], @"");
}
