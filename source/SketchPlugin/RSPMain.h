//
//  RSPMain.h
//  SketchPlugin
//
//  Created by aboyko on 3/6/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

@import AppKit;
@import Foundation;

@class RSPMainPanel;
@class MSDocument;
NS_ASSUME_NONNULL_BEGIN

@interface RSPMain : NSObject

///
/// Main Panel
@property(strong) IBOutlet RSPMainPanel *mainPanel;

///
/// Debug Panel
@property(strong) IBOutlet NSPanel *debugPanel;

///
/// Output for debug information
@property(weak) IBOutlet NSTextView *textView;

///
/// Context
@property(strong) MSDocument *document;
@end

NS_ASSUME_NONNULL_END
