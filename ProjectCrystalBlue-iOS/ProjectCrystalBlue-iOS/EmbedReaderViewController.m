//
//  EmbedReaderViewController.m
//  EmbedReader
//
//  Created by spadix on 5/2/11.
//

#import "EmbedReaderViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "LibraryObject.h"
#import "Source.h"
#import "Split.h"
#import "SourceEditViewController.h"
#import "SplitEditViewController.h"

@interface EmbedReaderViewController ()
{
    AbstractCloudLibraryObjectStore *libraryObjectStore;
}
@end

@implementation EmbedReaderViewController

@synthesize readerView, resultText;

- (id)init
{
    self = [super init];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                     WithDatabaseName:@"test_database.db"];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // the delegate receives decode results
    readerView.readerDelegate = self;
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc] initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void) viewDidUnload
{
    [self cleanup];
    [super viewDidUnload];
}

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [readerView stop];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    // auto-rotation is supported
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) orient
                                 duration:(NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation:orient
                                        duration:duration];
}

- (void) readerView:(ZBarReaderView*)view
     didReadSymbols:(ZBarSymbolSet*)syms
          fromImage:(UIImage*)img
{
    NSString *libraryObjectKey;
    
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        libraryObjectKey = sym.data;
        break;
    }
    
    // Object is source
    if ([libraryObjectStore libraryObjectExistsForKey:libraryObjectKey FromTable:[SourceConstants tableName]]) {
        
        Source *source = (Source*)[libraryObjectStore getLibraryObjectForKey:libraryObjectKey
                                                                   FromTable:[SourceConstants tableName]];
        
        SourceEditViewController *sourceEditController =
            [[SourceEditViewController alloc] initWithSource:source
                                                 WithLibrary:libraryObjectStore
                                       AndNavigateBackToRoot:YES];
        [self.navigationController pushViewController:sourceEditController animated:YES];
    }
    // Object is split
    else if ([libraryObjectStore libraryObjectExistsForKey:libraryObjectKey FromTable:[SplitConstants tableName]]) {
        
        Split *split = (Split *)[libraryObjectStore getLibraryObjectForKey:libraryObjectKey
                                                                    FromTable:[SplitConstants tableName]];
        
        SplitEditViewController *splitEditController =
            [[SplitEditViewController alloc] initWithSplit:split
                                               WithLibrary:libraryObjectStore
                                     AndNavigateBackToRoot:YES];
        
        [self.navigationController pushViewController:splitEditController animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unrecognized QR Code"
                                                        message:@"Make sure your source or split is synced with your device."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) cleanup
{
    cameraSim = nil;
    readerView = nil;
    resultText = nil;
}

- (void) dealloc
{
    [self cleanup];
}

@end
