//
//  Config.m
//  SketchPlugin
//
//  Created by aboyko on 6/2/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "Config.h"

///
/// return default config (size, insets etc) for moodboard
RSPMoodboardConfig defaultMoodboardConfig(void) {
    static RSPMoodboardConfig DefaultMoodboardConfig = {
            .moodboardGridSize = {.width = 4, .height = FLT_MAX},
            .artboardGridSize = {.width = 3, .height = 4},
            .imageSize = {.width = 404, .height = 316},
            .imagesInsets = {.top = 10, .bottom = 10, .left = 10, .right = 10},
            .artboardInsets = {.top = 50, .bottom = 50, .left = 50, .right = 50}

    };
    return DefaultMoodboardConfig;
}
