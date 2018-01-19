//
//  AppDelegate.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "BugDoc.h"
#import "TabViewController.h"
#import "Common.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,strong)MasterViewController *masterViewController;
@property(nonatomic,strong)TabViewController *tabController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.tabController = [[TabViewController alloc] initWithNibName:@"TabViewController" bundle:nil];
    [self.window.contentView addSubview:self.tabController.view];
    self.tabController.view.frame = NSMakeRect(0, 0, self.window.contentView.frame.size.width, self.window.contentView.frame.size.height-20);
    [self.window setMovableByWindowBackground:YES];
    
    NSError *pNSError;
    NSFileManager *pNSFileManager = [NSFileManager defaultManager];
    NSString *pNSStrDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * pNSStrWritableDBPath = [pNSStrDocumentsDirectory stringByAppendingPathComponent:@"DB"];
    NSString * appPath = [pNSStrDocumentsDirectory stringByAppendingPathComponent:@"DownLoad"];
    BOOL exists = [pNSFileManager fileExistsAtPath:pNSStrWritableDBPath];
    if (!exists) {
        [pNSFileManager createDirectoryAtPath:pNSStrWritableDBPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (![pNSFileManager fileExistsAtPath:pNSStrWritableDBPath]) {
            [NSException raise:@"FailedToCreateDBDirectory" format:@"Failed to create a directory for the home at '%@'",pNSStrWritableDBPath];
        }
    }
    exists = [pNSFileManager fileExistsAtPath:appPath];
    if (!exists) {
        [pNSFileManager createDirectoryAtPath:appPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (![pNSFileManager fileExistsAtPath:appPath]) {
            [NSException raise:@"FailedToCreateAPPDirectory" format:@"Failed to create a directory for the home at '%@'",appPath];
        }
    }
    
    pNSStrWritableDBPath = [pNSStrWritableDBPath stringByAppendingPathComponent:@"test.db"];
    exists = [pNSFileManager fileExistsAtPath:pNSStrWritableDBPath];
    if(!exists)
    {
        NSString *pNSStrDefaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.db"];
        exists = [pNSFileManager copyItemAtPath:pNSStrDefaultDBPath toPath:pNSStrWritableDBPath error:&pNSError];
        if(!exists)
        {
            NSLog(@"%@", [pNSError localizedDescription]);
            exists = NO;
        }else{
            NSLog(@"dbpath:%@",pNSStrWritableDBPath);
        }
    }
     [Common getInstance].dbPath = pNSStrWritableDBPath;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
