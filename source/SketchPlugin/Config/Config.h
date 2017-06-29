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

#define DEFAULT_PANEL_SIZE CGSizeMake(970, 1076)
#pragma mark - Keys
#define DOCUMENT_KEY @"document"

#pragma mark - View Const
#define MAIN_NIB @"RSPMainPanel"
#define CELL_NIB @"PhotoCollectionViewItem"
#define PANEL_THREAD_KEY @"rsp_toolbar"
#define DEBUG_PANEL_THREAD_KEY @"rsp_debug"
#define PROCESS_THREAD_KEY @"rsp_main"

#pragma makr - String Literals
#define PageNameText @"Moodboard"
#define ArtboardNameText @"Moodboard %li"
#define GridHintText @"%i columns x %i rows"
#define SelectedHintText @"%lu images selected"
