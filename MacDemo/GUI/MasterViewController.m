//
//  MasterViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "MasterViewController.h"
#import "BugDoc.h"
#import "BugData.h"
#import "EDStarRating.h"
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"
#import <AppKit/AppKit.h>
#import "SBPopoViewController.h"
@interface MasterViewController ()<NSTableViewDelegate,NSTableViewDataSource,EDStarRatingProtocol>{
    
    __weak IBOutlet NSTableView *_bugTableView;
    __weak IBOutlet NSTextField *_bugNameLab;
    __weak IBOutlet EDStarRating *_bugRatingView;
    __weak IBOutlet NSImageView *_bugImage;
}
@property(nonatomic,strong)NSStatusItem *demoItem;//状态栏item
@property(nonatomic,strong)NSPopover *popover;//弹窗
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BugDoc *bug1 = [[BugDoc alloc] initWithTitle:@"Potato Bug" rating:4 thumbImg:[NSImage imageNamed:@"potatoBugThumb"] fullImg:[NSImage imageNamed:@"potatoBug"]];
    BugDoc *bug2 = [[BugDoc alloc] initWithTitle:@"House Centipede" rating:3 thumbImg:[NSImage imageNamed:@"centipedeThumb"] fullImg:[NSImage imageNamed:@"centipede"]];
    BugDoc *bug3 = [[BugDoc alloc] initWithTitle:@"Wolf Spider" rating:5 thumbImg:[NSImage imageNamed:@"wolfSpiderThumb"] fullImg:[NSImage imageNamed:@"wolfSpider"]];
    BugDoc *bug4 = [[BugDoc alloc] initWithTitle:@"Lady Bug" rating:1 thumbImg:[NSImage imageNamed:@"ladybugThumb"] fullImg:[NSImage imageNamed:@"ladybug"]];
    NSMutableArray *bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
    self.bugs = bugs;

    
    _bugRatingView.maxRating = 5.0;
    _bugRatingView.starImage = [NSImage imageNamed:@"shockedface2_empty"];
    _bugRatingView.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full"];
    _bugRatingView.editable = YES;
    _bugRatingView.delegate = self;
    _bugRatingView.rating = 0.0;
    _bugRatingView.displayMode = EDStarRatingDisplayFull;
    
    self.demoItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"ladybugThumb"];
    self.demoItem.image = image;
    
    self.popover = [[NSPopover alloc] init];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.contentViewController = [[SBPopoViewController alloc] initWithNibName:@"SBPopoViewController" bundle:nil];
    self.demoItem.target = self;
    self.demoItem.button.action = @selector(showMyPopover);
    __weak typeof (self)weakself = self;
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent * event) {
        if(weakself.popover.isShown){
            [weakself.popover close];
        }
    }];
}
-(void)showMyPopover{
    [_popover showRelativeToRect:self.demoItem.button.bounds ofView:self.demoItem.button preferredEdge:NSRectEdgeMaxY];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.bugs.count;
}

- (nullable id)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView * cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if([tableColumn.identifier isEqualToString:@"BugCell"]){
        BugDoc * bug = self.bugs[row];
        cellView.imageView.image = bug.thumbImg;
        cellView.textField.stringValue = bug.data.title;
    }
    return cellView;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    BugDoc * bug = [self selectedBugDoc];
    [self setDetail:bug];
}
-(BugDoc *)selectedBugDoc{
    int selectedIndex = (int)_bugTableView.selectedRow;
    if(selectedIndex >= 0 && self.bugs.count > selectedIndex){
        return self.bugs[selectedIndex];
    }
    return nil;
}
-(void)setDetail:(BugDoc *)bug{
    if(bug == nil){
        _bugNameLab.stringValue = @"";
        _bugImage.image = nil;
        _bugRatingView.rating = 0.0;
        return;
    }
    _bugNameLab.stringValue = bug.data.title;
    _bugImage.image = bug.fullImg;
    _bugRatingView.rating = bug.data.rating;
}
- (IBAction)bugTitleDidEndEdit:(id)sender {
    BugDoc *bug = [self selectedBugDoc];
    if(bug == nil){
        return;
    }
    bug.data.title = _bugNameLab.stringValue;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:bug]];
    NSIndexSet * columSet = [NSIndexSet indexSetWithIndex:0];
    [_bugTableView reloadDataForRowIndexes:indexSet columnIndexes:columSet];
}
- (IBAction)addBug:(id)sender {
    BugDoc *bug = [[BugDoc alloc] initWithTitle:@"NewBug" rating:0.0 thumbImg:nil fullImg:nil];
    [self.bugs addObject:bug];
    NSInteger newRowIndex = self.bugs.count-1;
    [_bugTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    [_bugTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [_bugTableView scrollRowToVisible:newRowIndex];
    
}
- (IBAction)removeBug:(id)sender {
    BugDoc *bug = [self selectedBugDoc];
    if(bug == nil){
        return;
    }
    [self.bugs removeObject:bug];
    [_bugTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_bugTableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
    [self setDetail:nil];
}
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating{
    BugDoc *bug = [self selectedBugDoc];
    if(bug){
        bug.data.rating = rating;
    }
}
- (IBAction)changePicture:(id)sender {
    BugDoc *bug = [self selectedBugDoc];
    if(bug){
        [[IKPictureTaker pictureTaker] beginPictureTakerWithDelegate:self didEndSelector:@selector(pictureTakeDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}
-(void)pictureTakeDidEnd:(IKPictureTaker *)picker returnCode:(NSInteger)code contextInfo:(void *)contextInfo{
    NSImage *image = [picker outputImage];
    if(image != nil && code == NSModalResponseOK){
        _bugImage.image = image;
        BugDoc *bug = [self selectedBugDoc];
        if(bug){
            bug.fullImg = image;
            bug.thumbImg = [image imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:bug]];
            NSIndexSet * columSet = [NSIndexSet indexSetWithIndex:0];
            [_bugTableView reloadDataForRowIndexes:indexSet columnIndexes:columSet];
        }
    }
}
@end
