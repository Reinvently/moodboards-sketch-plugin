//
//  Config.h
//  SketchPlugin
//
//  Created by aboyko on 6/2/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Config

typedef struct {

    CGSize moodboardGridSize;
    CGSize artboardGridSize;

    CGSize imageSize;

    NSEdgeInsets imagesInsets;
    NSEdgeInsets artboardInsets;

} RSPMoodboardConfig;

///
/// return default config (size, insets etc) for moodboard
extern RSPMoodboardConfig defaultMoodboardConfig(void);


extern CGSize const DefaultPanelSize;

#pragma mark - Keys

extern NSString *const kSketchDocument;

#pragma mark - View Const

extern NSString *const kPanelThread;

extern NSString *const kDebugPanelThread;

extern NSString *const kProcessThread;
