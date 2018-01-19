//
//  DeviceManagerViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/18.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "AddDeviceWindow.h"
#import "Common.h"
#import "Host.h"
#import "AddDeviceByIPView.h"
#import "AddDeviceByDDNSView.h"
#import "Enumeration.h"
@interface DeviceManagerViewController ()<NSTableViewDelegate,NSTableViewDataSource>{
    
    __weak IBOutlet NSButton *_modifyBtn;
    __weak IBOutlet NSButton *_deleteBtn;
    __weak IBOutlet NSButton *_configBtn;
    __weak IBOutlet NSTableView *_deviceTableView;
    NSMutableArray *_devices;
}
@property (nonatomic,strong)AddDeviceWindow *addDeviceWindow;
@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _devices = [[Common getInstance] getAllDevice];
}
-(void)viewWillAppear{
    [super viewWillAppear];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDeviceTable) name:@"Add Device" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)refreshDeviceTable{
    _devices = [[Common getInstance] getAllDevice];
    [_deviceTableView reloadData];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _devices.count;
}
- (nullable id)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    Host * host = _devices[row];
    NSTableCellView * cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if([tableColumn.identifier isEqualToString:@"DeviceNameCell"]){
        cellView.textField.stringValue = host.strCaption;
    }else if([tableColumn.identifier isEqualToString:@"IPAddressCell"]){
        cellView.textField.stringValue = host.strIPAddress;
    }else if([tableColumn.identifier isEqualToString:@"DomainAddressCell"]){
        cellView.textField.stringValue = host.strDomainAddress;
    }else if([tableColumn.identifier isEqualToString:@"DomainNameCell"]){
        cellView.textField.stringValue = host.strDomainName;
    }else if([tableColumn.identifier isEqualToString:@"UserNameCell"]){
        cellView.textField.stringValue = host.strUsername;
    }else if([tableColumn.identifier isEqualToString:@"NetStatusCell"]){
        cellView.imageView.image = host.isOnline == 0 ?[NSImage imageNamed:@"device_offline"]:[NSImage imageNamed:@"device_online"];
        cellView.textField.stringValue = host.isOnline == 0 ? @"离线":@"在线";
    }
    return cellView;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    if([self selectedHost] != nil){
        [self setBtnEnable:YES];
    }else{
        [self setBtnEnable:NO];
    }
}
-(void)setBtnEnable:(BOOL)enable{
    _modifyBtn.enabled = enable;
    _deleteBtn.enabled = enable;
    _configBtn.enabled = enable;
}
-(Host *)selectedHost{
    int selectedIndex = (int)_deviceTableView.selectedRow;
    if(selectedIndex >= 0 && _devices.count > selectedIndex){
        return  _devices[selectedIndex];
    }
    return nil;
}
- (IBAction)onClickAddDeviceBtn:(id)sender {
    self.addDeviceWindow = [[AddDeviceWindow alloc] initWithWindowNibName:@"AddDeviceWindow"];
    [self.addDeviceWindow showWindow:self];
    [self.addDeviceWindow.window center];
    [self.addDeviceWindow.window makeKeyWindow];
}
- (IBAction)onClickModifyDeviceBtn:(id)sender {
    [self showModifyAlert];
}
-(void)showModifyAlert{
    Host * host = [self selectedHost];
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"修改设备";
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    if(host.iConnType == 0){
        AddDeviceByIPView *modifyView = [[AddDeviceByIPView alloc] initWithFrame:NSMakeRect(0, 0, 467, 261)];
        modifyView.deviceName.stringValue = host.strCaption;
        modifyView.address.stringValue = host.strIPAddress;
        modifyView.port.integerValue = host.iPort;
        modifyView.userName.stringValue = host.strUsername;
        modifyView.password.stringValue = host.strPassword;
        alert.accessoryView = modifyView;
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                int success = [[Common getInstance] updateDeviceWithDeviceId:host.strId deviceName:modifyView.deviceName.stringValue ip:modifyView.address.stringValue domain:@"" port:modifyView.port.intValue domainName:@"" username:modifyView.userName.stringValue password:modifyView.password.stringValue];
                if(success == 0){
                    [self refreshDeviceTable];
                    [_deviceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_deviceTableView.selectedRow] byExtendingSelection:YES];
                }else if(success == ERR_CAPTION_EXSIT){
                    [self showPopOverWithMessage:@"设备名称已存在" toview:modifyView.deviceName];
                }else if(success == ERR_DEVICE_ADDRESS_EXSIT){
                    [self showPopOverWithMessage:@"设备IP已存在" toview:modifyView.address];
                }
            }
        }];
    }else{
        AddDeviceByDDNSView *modifyView = [[AddDeviceByDDNSView alloc] initWithFrame:CGRectMake(0, 0, 467, 261)];
        modifyView.deviceName.stringValue = host.strCaption;
        modifyView.address.stringValue = host.strDomainAddress;
        modifyView.domainName.stringValue = host.strDomainName;
        modifyView.userName.stringValue = host.strUsername;
        modifyView.password.stringValue = host.strPassword;
        alert.accessoryView = modifyView;
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                int success = [[Common getInstance] updateDeviceWithDeviceId:host.strId deviceName:modifyView.deviceName.stringValue ip:@"" domain:modifyView.address.stringValue port:0 domainName:modifyView.domainName.stringValue username:modifyView.userName.stringValue password:modifyView.password.stringValue];
                if(success == 0){
                    [self refreshDeviceTable];
                    [_deviceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_deviceTableView.selectedRow] byExtendingSelection:YES];
                }else if(success == ERR_CAPTION_EXSIT){
                    [self showPopOverWithMessage:@"设备名称已存在" toview:modifyView.deviceName];
                }else if(success == ERR_DEVICE_DOMAIN_EXSIT){
                    [self showPopOverWithMessage:@"Domain已存在" toview:modifyView.address];
                }else if(success == ERR_DEVICE_DOMAIN_NAME_EXSIT){
                    [self showPopOverWithMessage:@"Domain名称已存在" toview:modifyView.domainName];
                }
            }
        }];
    }
}
-(void)showPopOverWithMessage:(NSString *)message toview:(NSView *)view{
    NSViewController *popController = [[NSViewController alloc] initWithNibName:nil bundle:nil];
    NSTextField * textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 25)];
    textField.editable = NO;
    textField.stringValue = message;
    popController.view = textField;
    NSPopover *pop = [[NSPopover alloc] init];
    pop.contentViewController = popController;
    /**
     applicationDefined : 默认值,不会自动关闭popover,ESC键也不能关闭,应用关闭时,popovoer会关闭
     semitransient: 点击popover以外的界面部分,不会自动关闭,但ESC按键可以关闭popover
     transient:  点击popvoer界面以外的部分,popover会自动关闭,ESC键可以关闭popover
     */
    pop.behavior = NSPopoverBehaviorSemitransient;
    [pop showRelativeToRect:view.bounds ofView:view preferredEdge:NSRectEdgeMaxX];
    
}
- (IBAction)onClickDeleteDeviceBtn:(id)sender {
    [self showDeleteAlert];
}
-(void)showDeleteAlert{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"提示";
    alert.informativeText = @"是否删除设备";
    alert.icon = [NSImage imageNamed:@"NSCaution"];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    NSModalResponse returnCode = [alert runModal];//以弹出框的形式显示
    if(returnCode == NSAlertFirstButtonReturn){
        Host * host = [self selectedHost];
        if([[Common getInstance] deleteDeviceById:host.strId]){
            [self refreshDeviceTable];
        }
        if(_devices.count > 0){
            [_deviceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];
        }else{
            [self setBtnEnable:NO];
        }
        
    }
    //alert 内嵌在App的当前view的window中
//    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//        if(returnCode == NSAlertFirstButtonReturn){
//            int selectedIndex = (int)_deviceTableView.selectedRow;
//            if(selectedIndex >= 0 && _devices.count > selectedIndex){
//                Host *host = _devices[selectedIndex];
//                if([[Common getInstance] deleteDeviceById:host.strId]){
//                    [self refreshDeviceTable];
//                }
//                if(_devices.count > 0){
//                    [_deviceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];
//                }else{
//                    [self setBtnEnable:NO];
//                }
//            }
//
//        }
//    }];
}
- (IBAction)onClickConfigBtn:(id)sender {
}
- (IBAction)search:(id)sender {
}
@end
