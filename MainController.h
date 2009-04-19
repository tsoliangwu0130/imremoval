//
//  MainController.h
//  IMRemoval
//
//  Created by zonble on 2009/4/19.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


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
@end
