//
//  RSPMainPanel.m
//  SketchPlugin
//
//  Created by aboyko on 6/20/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPMainPanel.h"

@interface RSPMainPanel ()

///
/// Outlets
@property(strong) IBOutlet NSTextField *searchTextField;
@property(strong) IBOutlet NSLayoutConstraint *expandedHeightConstraint;
@property(strong) IBOutlet NSLayoutConstraint *expandedWidthConstraint;
@property(strong) IBOutlet NSView *searchForm;
@property(strong) IBOutlet NSProgressIndicator *activityIndicator;

@end

@implementation RSPMainPanel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpPanel];
}

- (void)setUpPanel {
    self.searchForm.wantsLayer = YES;
    NSTextFieldCell *cell = self.searchTextField.cell;
    NSColor *color = [NSColor colorWithWhite:1.f alpha:0.5f];
    NSFont *font = cell.font;
    NSString *text = cell.placeholderString;
    if (text && color && font) {
        cell.placeholderAttributedString = [[NSAttributedString alloc] initWithString:text
                                                                           attributes:@{
                                                                                   NSForegroundColorAttributeName: color,
                                                                                   NSFontAttributeName: cell.font}];
    }
    [self expandPanel:NO];
}

- (void)startActivityIndication {
    [self.activityIndicator startAnimation:nil];
    self.searchForm.alphaValue = 0.5;
}

- (void)stopActivityIndication {
    [self.activityIndicator stopAnimation:nil];
    self.searchForm.alphaValue = 1.0;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        [self.button performClick:self];
        return YES;
    }
    return NO;
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if (textField == self.searchTextField) {
        self.delegate = nil;
        [self.panelDelegate mainPanel:self didChangeSearchQuery:textField.stringValue];
    }
}

///
/// Expand/Collapse Panel
/// @param expand Expand
- (void)expandPanel:(BOOL)expand {
    dispatch_block_t dispatchBlock = ^{
        self.expandedWidthConstraint.active = expand;
        self.expandedHeightConstraint.active = expand;
    };
    if (expand) {
        CGRect frame = self.frame;
        frame.size = DefaultPanelSize;
        [self setFrame:frame display:YES animate:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), dispatchBlock);
    } else {
        dispatchBlock();
        [self setContentSize:self.contentMinSize];
    }
    self.searchForm.hidden = !expand;
}
@end
