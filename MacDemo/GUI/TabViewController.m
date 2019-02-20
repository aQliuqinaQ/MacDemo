//
//  TabViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "TabViewController.h"
#import "FirstViewController.h"
#import "MainViewController.h"
#import "TabButton.h"
#import "MasterViewController.h"
#import "DeviceManagerViewController.h"
#import "TreeTableViewController.h"
#import "VideoPlayController.h"
#import "ControlsController.h"
#define identifier_main @"Public"
#define identifier_home @"Home"
#define identifier_device @"Device Manager"
#define identifier_user   @"User Manager"
#define identifier_tree   @"Tree Table"
#define identifier_videoplay   @"VideoPlay"
#define identifier_controls @"controls"
@interface TabViewController ()<NSToolbarDelegate,TabBtnDelegate>{
    NSToolbar *_toolBar;
    NSMutableArray *_identifiers;
    TabButton *_lastSelectedTabBtn;
}

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabStyle = NSTabViewControllerTabStyleUnspecified;
    _identifiers = [[NSMutableArray alloc] init];
    _toolBar = [[NSToolbar alloc] initWithIdentifier:@"ToolBar"];
    _toolBar.delegate = self;
    _toolBar.allowsUserCustomization = YES;
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [_identifiers addObject:identifier_home];
    NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:@"Control pannel"];
    item.viewController = first;
    [self insertTabViewItem:item atIndex:0];
    __weak typeof (self)weakself = self;
    first.mainBtnSelectedblock = ^(void){
        if(![_identifiers containsObject:identifier_main]){
            MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:main];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:identifier_main];
            [_toolBar insertItemWithItemIdentifier:identifier_main atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:identifier_main];
    };
    first.deviceManagerBtnSelectedblock = ^(void){
        if(![_identifiers containsObject:identifier_device]){
            DeviceManagerViewController *deviceManager = [[DeviceManagerViewController alloc] initWithNibName:@"DeviceManagerViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:deviceManager];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:identifier_device];
            [_toolBar insertItemWithItemIdentifier:identifier_device atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:identifier_device];
    };
    first.userManagerBtnSelectedBlock = ^(void){
        if(![_identifiers containsObject:identifier_user]){
            MasterViewController *master = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:master];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:identifier_user];
            [_toolBar insertItemWithItemIdentifier:identifier_user atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:identifier_user];
    };
    first.treeTableBtnSelectedBlock = ^(void){
        if(![_identifiers containsObject:identifier_tree]){
            TreeTableViewController *tree = [[TreeTableViewController alloc] initWithNibName:@"TreeTableViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:tree];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:identifier_tree];
            [_toolBar insertItemWithItemIdentifier:identifier_tree atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:identifier_tree];
    };
    first.videoPlayBtnSelectedBlock = ^(void){
//        if(![_identifiers containsObject:identifier_tree]){
            VideoPlayController *videoplay = [[VideoPlayController alloc] initWithNibName:@"VideoPlayController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:videoplay];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
        [_identifiers addObject:[NSString stringWithFormat:@"%@%lu",identifier_videoplay,(unsigned long)self.tabViewItems.count]];
            [_toolBar insertItemWithItemIdentifier:[NSString stringWithFormat:@"%@%lu",identifier_videoplay,(unsigned long)self.tabViewItems.count] atIndex:_toolBar.items.count];
//        }
        [weakself selecteTabBtn:[NSString stringWithFormat:@"%@%lu",identifier_videoplay,(unsigned long)self.tabViewItems.count]];
    };
    first.controlsBtnSelectedBlock = ^(void){
        if(![_identifiers containsObject:identifier_controls]){
            ControlsController *controls = [[ControlsController alloc] initWithNibName:@"ControlsController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:controls];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:identifier_controls];
            [_toolBar insertItemWithItemIdentifier:identifier_controls atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:identifier_controls];
    };
}
-(void)viewDidAppear{
    [super viewDidAppear];
    self.view.window.toolbar = _toolBar;
}
- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{
    [super toolbarDefaultItemIdentifiers:toolbar];
    return _identifiers;
}
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{
    [super toolbarAllowedItemIdentifiers:toolbar];
    return _identifiers;
}
- (nullable NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag{
    if(_lastSelectedTabBtn){
        _lastSelectedTabBtn.layer.backgroundColor = [NSColor clearColor].CGColor;
    }
    [super toolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];
    NSToolbarItem * item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    item.toolTip = itemIdentifier;
    if([itemIdentifier isEqualToString:identifier_home]){
        TabButton * homeBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 120, 48) image:[NSImage imageNamed:@"shockedface2_full"] title:identifier_home tag:itemIdentifier];
        homeBtn.delegate = self;
        [homeBtn setCloseBtnHide:YES];
        item.view = homeBtn;
        _lastSelectedTabBtn = homeBtn;
    }else if([itemIdentifier isEqualToString:identifier_main]){
        TabButton * mainBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 150, 48) image:[NSImage imageNamed:@"ladybugThumb"] title:itemIdentifier tag:itemIdentifier];
        mainBtn.delegate = self;
        item.view = mainBtn;
        _lastSelectedTabBtn = mainBtn;
    }else if([itemIdentifier isEqualToString:identifier_device]){
        TabButton * deviceBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"wolfSpiderThumb"] title:itemIdentifier tag:itemIdentifier];
        deviceBtn.delegate = self;
        item.view = deviceBtn;
        _lastSelectedTabBtn = deviceBtn;
    }else if([itemIdentifier isEqualToString:identifier_user]){
        TabButton * deviceBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"potatoBugThumb"] title:itemIdentifier tag:itemIdentifier];
        deviceBtn.delegate = self;
        item.view = deviceBtn;
        _lastSelectedTabBtn = deviceBtn;
    }else if([itemIdentifier isEqualToString:identifier_tree]){
        TabButton * treeBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"centipedeThumb"] title:itemIdentifier tag:itemIdentifier];
        treeBtn.delegate = self;
        item.view = treeBtn;
        _lastSelectedTabBtn = treeBtn;
    }else if([itemIdentifier containsString:identifier_videoplay]){
        TabButton * videoPlayBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"centipedeThumb"] title:itemIdentifier tag:itemIdentifier];
        videoPlayBtn.delegate = self;
        item.view = videoPlayBtn;
        _lastSelectedTabBtn = videoPlayBtn;
    }else if([itemIdentifier containsString:identifier_controls]){
        TabButton * controlsBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"centipedeThumb"] title:itemIdentifier tag:itemIdentifier];
        controlsBtn.delegate = self;
        item.view = controlsBtn;
        _lastSelectedTabBtn = controlsBtn;
    }
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.title = itemIdentifier;
    menuItem.target = self;
    menuItem.identifier = itemIdentifier;
    menuItem.action = @selector(showViewController:);
    item.menuFormRepresentation = menuItem;
    return item;
}
-(void)showViewController:(NSMenuItem *)item{
    NSInteger index = [_identifiers indexOfObject:item.identifier];
    [self setSelectedTabViewItemIndex:index];
}
#pragma mark TabBtnDelegate
-(void)selecteTabBtn:(NSString *)identifier{
    _lastSelectedTabBtn.layer.backgroundColor = [NSColor clearColor].CGColor;
    NSInteger index = [_identifiers indexOfObject:identifier];
    if(index >= 0){
        NSToolbarItem *item = _toolBar.items[index];
        TabButton * tabbtn = (TabButton *)item.view;
        tabbtn.layer.backgroundColor = [NSColor redColor].CGColor;
        _lastSelectedTabBtn = tabbtn;
            [self setSelectedTabViewItemIndex:index];
    }
}
-(void)onClickTabCloseBtn:(NSString *)identifier{
    NSInteger index = [_identifiers indexOfObject:identifier];
    if(index >= 1){
        NSToolbarItem *item = _toolBar.items[index];
        TabButton * tabbtn = (TabButton *)item.view;
        if([tabbtn isEqual:_lastSelectedTabBtn]){
            NSToolbarItem *newitem = _toolBar.items[index-1];
            TabButton * newtabbtn = (TabButton *)newitem.view;
            newtabbtn.layer.backgroundColor = [NSColor redColor].CGColor;
            _lastSelectedTabBtn = newtabbtn;
        }
    }
    [_toolBar removeItemAtIndex:index];
    [_identifiers removeObject:identifier];
    [self removeChildViewControllerAtIndex:index];
}
@end
