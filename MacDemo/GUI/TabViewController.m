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
//    _toolBar.allowsExtensionItems = YES;
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [_identifiers addObject:@"Control pannel"];
    NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:@"Control pannel"];
    item.viewController = first;
    [self insertTabViewItem:item atIndex:0];
    __weak typeof (self)weakself = self;
    first.mainBtnSelectedblock = ^(void){
        if(![_identifiers containsObject:@"Main"]){
            MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:main];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:@"Main"];
            [_toolBar insertItemWithItemIdentifier:@"Main" atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:@"Main"];
    };
    first.deviceManagerBtnSelectedblock = ^(void){
        if(![_identifiers containsObject:@"Device Manager"]){
            MasterViewController *master = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
            NSTabViewItem *item = [NSTabViewItem tabViewItemWithViewController:master];
            [weakself insertTabViewItem:item atIndex:self.tabViewItems.count];
            [_identifiers addObject:@"Device Manager"];
            [_toolBar insertItemWithItemIdentifier:@"Device Manager" atIndex:_toolBar.items.count];
        }
        [weakself selecteTabBtn:@"Device Manager"];
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
    if([itemIdentifier isEqualToString:@"Control pannel"]){
        TabButton * homeBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 120, 48) image:[NSImage imageNamed:@"shockedface2_full"] title:@"Home" tag:itemIdentifier];
        homeBtn.delegate = self;
        item.view = homeBtn;
        _lastSelectedTabBtn = homeBtn;
    }else if([itemIdentifier isEqualToString:@"Main"]){
        TabButton * mainBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 150, 48) image:[NSImage imageNamed:@"ladybugThumb"] title:@"Main View" tag:itemIdentifier];
        mainBtn.delegate = self;
        item.view = mainBtn;
        _lastSelectedTabBtn = mainBtn;
    }else if([itemIdentifier isEqualToString:@"Device Manager"]){
        TabButton * deviceBtn = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48) image:[NSImage imageNamed:@"wolfSpiderThumb"] title:@"Device Manager" tag:itemIdentifier];
        deviceBtn.delegate = self;
        item.view = deviceBtn;
        _lastSelectedTabBtn = deviceBtn;
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
