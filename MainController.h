//
//  MainController.h
//  IMRemoval
//
//  Created by zonble on 2009/4/19.
//  Copyright 2009 zonble.net. All rights reserved.
//

@import Cocoa;

@interface MainController : NSWindowController
{
	NSMutableArray *_inputMethodArray;
	IBOutlet NSArrayController *_arrayController;
	IBOutlet NSTableView *_tableView;
}

- (void)scanAllFolder;
- (void)scanFolder:(NSString *)path;
- (BOOL)removeWithAuthorization:(NSString *)path;
- (IBAction)removeAction:(id)sender;
- (IBAction)homepageAction:(id)sender;
@end
