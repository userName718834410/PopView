//
//  AppDelegate.h
//  PopViewDemo
//
//  Created by 金现代 on 2019/3/20.
//  Copyright © 2019 王广法. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

