//
//  TreeTableViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/3/30.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "TreeTableViewController.h"
#import "RootModel.h"
#import "LeafModel.h"
@interface TreeTableViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>{
    __weak IBOutlet NSOutlineView *_outlineView;
    __weak IBOutlet NSOutlineView *_rightOutlineView;
    NSMutableArray *_selectedArr;
    RootModel *root;
}

@end

@implementation TreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
}

-(void)setupModel{
    LeafModel *leaf1 = [[LeafModel alloc]initWithId:@"hb" name:@"湖北"level:1];
    leaf1.hasChildren = YES;
    LeafModel *leaf11 = [[LeafModel alloc]initWithId:@"wh" name:@"武汉" level:2];
    LeafModel *leaf12 = [[LeafModel alloc]initWithId:@"jz" name:@"荆州" level:2];
    LeafModel *leaf13 = [[LeafModel alloc]initWithId:@"hg" name:@"黄冈"level:2];
    leaf1.children = [[NSMutableArray alloc] initWithObjects:leaf11,leaf12,leaf13, nil];
    LeafModel *leaf2 = [[LeafModel alloc]initWithId:@"hn" name:@"湖南" level:1];
    LeafModel *leaf3 = [[LeafModel alloc]initWithId:@"henan" name:@"河南" level:1];
    LeafModel *leaf4 = [[LeafModel alloc]initWithId:@"hebei" name:@"河北" level:1];
    LeafModel *root1 = [[LeafModel alloc]initWithId:@"China" name:@"中国" level:0];
    root1.hasChildren = YES;
    root1.children = [[NSMutableArray alloc] initWithObjects:leaf1,leaf2,leaf3,leaf4, nil];
    LeafModel *leaf5 = [[LeafModel alloc]initWithId:@"NY" name:@"纽约" level:1];
    LeafModel *leaf6 = [[LeafModel alloc]initWithId:@"hsd" name:@"华盛顿" level:1];
    LeafModel *leaf7 = [[LeafModel alloc]initWithId:@"ls" name:@"洛杉矶" level:1];
    LeafModel *leaf8 = [[LeafModel alloc]initWithId:@"sb" name:@"塞班" level:1];
    LeafModel *root2 = [[LeafModel alloc]initWithId:@"American" name:@"美国" level:0];
    root2.hasChildren = YES;
    root2.children = [[NSMutableArray alloc] initWithObjects:leaf5,leaf6,leaf7,leaf8, nil];
    
    root = [[RootModel alloc] initWithName:@"根节点" level:-1];
    root.children = [[NSMutableArray alloc] initWithObjects:root1,root2, nil];
    
    _selectedArr = [[NSMutableArray alloc] init];
    [_outlineView reloadData];
    [_rightOutlineView reloadData];
}

// 通过这个方法，NSOutlineView获得每个层级需要显示的节点数，当数据为顶级节点（根节点）时，item的值为nil
// 当NSOutlineView 需要展示数据时，第一步会调用此方法
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if([item isKindOfClass:[LeafModel class]]){
        LeafModel *leaf = (LeafModel *)item;
        if(leaf.hasChildren){
            return leaf.children.count;
        }
        return 0;
    }else if([item isEqual:root]){
        return root.children.count;
    }
    return 1;
}
// 通过这个方法，NSOutlineView可以判断本层级节点是否可以展开（是否有子节点）
// 当NSOutlineView 需要展示数据时，第三步会调用此方法
-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    if([item isKindOfClass:[LeafModel class]]){
        LeafModel *leaf = (LeafModel *)item;
        return leaf.hasChildren;
    }
    return YES;
}
// 通过这个方法，NSOutlineView知道每个层级节点的显示数据
// 当NSOutlineView 需要展示数据时，第二步会调用此方法
-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if([item isKindOfClass:[LeafModel class]]){
        LeafModel *leaf = (LeafModel *)item;
        return leaf.children[index];
    }else if([item isEqual:root]){
        return root.children[index];
    }
    return root;
}
- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item{
    NSView *view = [outlineView makeViewWithIdentifier:@"Cell" owner:self];
    if(view != nil){
        for(NSView *subview in view.subviews){
            [subview removeFromSuperview];
        }
    }
    if([tableColumn.identifier isEqualToString:@"Cell"]){
        NSButton *checkbox = [[NSButton alloc] init];
        [checkbox setButtonType:NSButtonTypeSwitch];
        if([item isKindOfClass:[LeafModel class]]){
            LeafModel *leaf = (LeafModel *)item;
            [checkbox setTitle:leaf.name];
            CGSize size = [leaf.name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:17.0],NSFontAttributeName, nil]];
            checkbox.frame = CGRectMake(0, 0, size.width+12, 30);
            checkbox.tag = [outlineView rowForItem:leaf];
            checkbox.state = leaf.selected;
        }else{
            [checkbox setTitle:root.name];
            CGSize size = [root.name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:17.0],NSFontAttributeName, nil]];
            checkbox.frame = CGRectMake(0, 0, size.width+12, 30);
            checkbox.tag = [outlineView rowForItem:root];
            checkbox.state = root.selected;
        }
        checkbox.target = self;
        checkbox.action = @selector(onclickCheckBox:);
        [view addSubview:checkbox];
    }
    return view;
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if(_outlineView.selectedRow == 0){
        return;
    }
    id item = [_outlineView itemAtRow:_outlineView.selectedRow];
    LeafModel *leaf = (LeafModel *)item;
    NSLog(@"选中了第%ld行，%@",(long)_outlineView.selectedRow,leaf.name);
}
-(void)onclickCheckBox:(NSButton *)checkbox{
    if(checkbox.tag == 0){
        for(int i=0;i<root.children.count;i++){
            [self checkItem:root.children[i] state:checkbox.state];
        }
        root.selected = checkbox.state;
        [_outlineView reloadData];
        return;
    }
    LeafModel *leaf = [_outlineView itemAtRow:checkbox.tag];
    leaf.selected = checkbox.state;
    if(leaf.hasChildren){
        [self checkItem:leaf state:checkbox.state];
        [_outlineView reloadData];
    }else{
        if(checkbox.state){
            [_selectedArr addObject:leaf];
        }else{
            [_selectedArr removeObject:leaf];
        }
    }
    LeafModel *parent = [_outlineView parentForItem:leaf];
    if(checkbox.state){
        NSLog(@"勾选了%@",leaf.name);
        for(LeafModel *child in parent.children){
            if(child.selected){
                continue;
            }else{
                return;
            }
        }
        parent.selected = YES;
        [_outlineView reloadData];
    }else{
        NSLog(@"取消勾选了%@",leaf.name);
        parent.selected = NO;
        [self checkState:NO parentOfLeaf:parent];
        [_outlineView reloadData];
    }
}
-(void)checkItem:(LeafModel *)leaf state:(BOOL)state{
    leaf.selected = state;
    if(leaf.hasChildren){
        for(LeafModel *child in leaf.children){
            child.selected = state;
            if(child.hasChildren){
                [self checkItem:child state:state];
            }
        }
    }
    if(state){
        [_selectedArr addObject:leaf];
    }else{
        [_selectedArr removeObject:leaf];
    }
}
-(void)checkState:(BOOL)state parentOfLeaf:(LeafModel *)leaf{
    id item = [_outlineView parentForItem:leaf];
    if([item isEqual:root]){
        root.selected = state;
        return;
    }
    LeafModel *parent = [_outlineView parentForItem:leaf];
    if(parent.level != -1){
        parent.selected = state;
        [self checkState:state parentOfLeaf:parent];
    }
}
- (IBAction)moveUp:(id)sender {
    if(_outlineView.selectedRow <= 1){
        return;
    }
    id item = [_outlineView itemAtRow:_outlineView.selectedRow];
    if(item == nil){
        return;
    }
    int selectedIndex = (int)_outlineView.selectedRow;
    if(selectedIndex >= 2){
        id upItem = [_outlineView itemAtRow:selectedIndex-1];
        LeafModel *upLeaf = (LeafModel *)upItem;
        LeafModel *leaf = (LeafModel *)item;
        if(upLeaf.level < leaf.level){
            return;
        }
        LeafModel *fatherNode = (LeafModel *) [_outlineView parentForItem:item];//[self findFatherNodeof:selectedIndex];
        NSMutableArray *children = fatherNode.children;
        int index = (int)[children indexOfObject:leaf];
        [children removeObject:leaf];
        [children insertObject:leaf atIndex:index-1];
        [_outlineView reloadData];
        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_outlineView rowForItem:leaf]] byExtendingSelection:NO];
        [_outlineView scrollRowToVisible:[_outlineView rowForItem:leaf]];
    }
}
- (IBAction)moveDown:(id)sender {
    if(_outlineView.selectedRow == 0){
        return;
    }
    id item = [_outlineView itemAtRow:_outlineView.selectedRow];
    if(item == nil){
        return;
    }
    int selectedIndex = (int)_outlineView.selectedRow;
    if(selectedIndex >= 1 && selectedIndex <= _outlineView.numberOfRows-2){
        id downItem = [_outlineView itemAtRow:selectedIndex+1];
        LeafModel *downLeaf = (LeafModel *)downItem;
        LeafModel *leaf = (LeafModel *)item;
        if(downLeaf.level < leaf.level){
            return;
        }
        LeafModel *fatherNode = (LeafModel *)[_outlineView parentForItem:item];//[self findFatherNodeof:selectedIndex];
        NSMutableArray *children = fatherNode.children;
        int index = (int)[children indexOfObject:leaf];
        [children removeObject:leaf];
        [children insertObject:leaf atIndex:index+1];
        [_outlineView reloadData];
        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_outlineView rowForItem:leaf]] byExtendingSelection:NO];
        [_outlineView scrollRowToVisible:[_outlineView rowForItem:leaf]];
    }
}
- (IBAction)add:(id)sender {
    id item = [_outlineView itemAtRow:_outlineView.selectedRow];
    if(item == nil){
        return;
    }
    if([item isKindOfClass:[RootModel class]]){
        RootModel *root = (RootModel *)item;
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"添加分组";
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        NSTextField *groupText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        groupText.placeholderString = @"请输入组名称";
        alert.accessoryView = groupText;
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                LeafModel *newLeaf = [[LeafModel alloc] initWithId:groupText.stringValue name:groupText.stringValue level:root.level+1];
                newLeaf.hasChildren = YES;
                newLeaf.children = [[NSMutableArray alloc] init];
                [root.children addObject:newLeaf];
                [_outlineView reloadData];
                [_outlineView expandItem:root expandChildren:YES];
                [_outlineView setAllowsColumnResizing:YES];
            }
        }];
    }else{
        LeafModel *leaf = (LeafModel *)item;
        if(leaf.hasChildren){
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"添加分组";
            [alert addButtonWithTitle:@"确定"];
            [alert addButtonWithTitle:@"取消"];
            NSTextField *groupText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            groupText.placeholderString = @"请输入组名称";
            alert.accessoryView = groupText;
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                if(returnCode == NSAlertFirstButtonReturn){
                    LeafModel *newLeaf = [[LeafModel alloc] initWithId:groupText.stringValue name:groupText.stringValue level:leaf.level+1];
                    newLeaf.hasChildren = YES;
                    newLeaf.children = [[NSMutableArray alloc] init];
                    [leaf.children addObject:newLeaf];
                    [_outlineView reloadData];
                    [_outlineView expandItem:leaf expandChildren:YES];
                }
            }];
        }else{
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"提示";
            alert.informativeText = @"请选择组后再尝试本操作";
            alert.icon = [NSImage imageNamed:@"NSCaution"];
            [alert addButtonWithTitle:@"确定"];
            [alert runModal];//以弹出框的形式显示
        }
    }
}
- (IBAction)delete:(id)sender {
    if(_outlineView.selectedRow == 0){
        return;
    }
    id item = [_outlineView itemAtRow:_outlineView.selectedRow];
    if(item == nil){
        return;
    }
    LeafModel *leaf = (LeafModel *)item;
    if(leaf.hasChildren){
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"删除分组";
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        alert.icon = [NSImage imageNamed:@"NSCaution"];
        NSModalResponse returnCode = [alert runModal];//以弹出框的形式显示
        if(returnCode == NSAlertFirstButtonReturn){
            LeafModel *father = [_outlineView parentForItem:leaf];//[self findFatherNodeof:index];
            [father.children removeObject:leaf];
            [_outlineView reloadData];
            [_outlineView expandItem:father expandChildren:YES];
        }
    }else{
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"提示";
        alert.informativeText = @"请选择组后再尝试本操作";
        alert.icon = [NSImage imageNamed:@"NSCaution"];
        [alert addButtonWithTitle:@"确定"];
        [alert runModal];//以弹出框的形式显示
    }
}
- (IBAction)moveIn:(id)sender {
}
- (IBAction)moveOut:(id)sender {
    for(LeafModel *leaf in _selectedArr){
        LeafModel *parent = [_outlineView parentForItem:leaf];
        if(leaf.hasChildren){
            [leaf.children removeAllObjects];
            leaf.selected = NO;
        }else{
            [parent.children removeObject:leaf];
        }
        parent.selected = NO;
    }
    [_outlineView reloadData];
}
@end
