//
//  AbstractMobileCloudImageStore.h
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractMobileImageStore.h"

/**
 *  Abstract superclass for a class that handles image storage, backed with a cloud data storage.
 *  Each image item must be associated with a unique key.
 */
@interface AbstractMobileCloudImageStore : AbstractMobileImageStore

/** Synchronize any new changes with an online database, if the ImageStore is backed by one.
 *  This should get any new images that have been created on other devices, as well as
 *  upload any images that have been created on this device.
 *
 *  When online, the CloudImageStore will automatically synchronize whenever images are added,
 *  but this should also be called periodically in case images were created offline.
 *
 *  Returns NO
 *      -if items need to be synced, but the database cannot be reached
 *
 *  Returns YES
 *      -if no items needed to be synced
 *      -if items were successfully synced
 */
-(BOOL)synchronizeWithCloud;


/** Check whether the image associated with a given key is "dirty" - i.e. is not synced with the online image store.
 *
 *  Returns NO
 *      -if the image associated with that key has already been synced.
 *      -if there is not an image associated with that key.
 *
 *  Returns YES
 *      -if the image was collected while the device was offline, and synchronizeWithCloud has not been called since then.
 */
-(BOOL)keyIsDirty:(NSString *)key;

@end
