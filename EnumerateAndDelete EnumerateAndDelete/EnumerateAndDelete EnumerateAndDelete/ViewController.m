//
//  ViewController.m
//  EnumerateAndDelete EnumerateAndDelete
//
//  Created by young on 2019/8/27.
//  Copyright © 2019 young. All rights reserved.
//

/*
 结论：对 可变且可遍历的对象，记为 map, 进行遍历
 1. 正序遍历过程中，删除元素，如果遍历长度固定，则有可能引发崩溃；例如：foriCountMethod
 2. 正序遍历过程中，删除元素，如果遍历长度不固定，且为 map.count，则不会引发崩溃；例如：foriMethod
 3. 倒序遍历过程中，删除元素，不会引发崩溃；例如：foriRevertMethod
 4. 字典使用 -(void)enumerate* 遍历过程中，删除元素，不会引发崩溃；例如：dictionaryMethod
 5. 集合使用 -(void)enumerate* 遍历过程中，删除元素，不会引发崩溃；例如：mutableSetMethod
 6. NSPointerArray 遍历过程中，删除元素，与 NSMutableArray 的结果一致；例如：pointerArrayMethod
 */

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSMutableArray *numbers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[@"foriMethod",@"foriCountMethod",@"foriRevertMethod",@"forinMethod",@"dictionaryMethod",@"mutableSetMethod",@"pointerArrayMethod",@"pointerArrayCountMethod"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selString = self.datas[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(selString)];
#pragma clang diagnostic pop
}

- (void)foriMethod {
    NSMutableArray *tempA = [self.numbers mutableCopy];
    for (NSUInteger i=0; i<tempA.count; i++) {
        [tempA removeObjectAtIndex:i];
    }
    NSLog(@"%s finish.",__func__);
}

// crash : -[__NSArrayM removeObjectsInRange:]: range {500, 1} extends beyond bounds [0 .. 499]'
- (void)foriCountMethod {
    NSMutableArray *tempA = [self.numbers mutableCopy];
    NSUInteger count = tempA.count;
    for (NSUInteger i=0; i<count; i++) {
        [tempA removeObjectAtIndex:i];
    }
    NSLog(@"%s finish.",__func__);
}

- (void)foriRevertMethod {
    NSMutableArray *tempA = [self.numbers mutableCopy];
    NSUInteger count = tempA.count;
    for (NSUInteger i=count; i>0; i--) {
        [tempA removeObjectAtIndex:(i - 1)];
    }
    NSLog(@"%s finish.",__func__);
}

// crash : Collection <__NSArrayM: 0x600000e493e0> was mutated while being enumerated.
- (void)forinMethod {
    NSMutableArray *tempA = [self.numbers mutableCopy];
    for (NSNumber *number in tempA) {
        [tempA removeObject:number];
    }
    NSLog(@"%s finish.",__func__);
}

- (void)dictionaryMethod {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSUInteger i=0; i<1000; i++) {
        [dict setObject:@(i) forKey:@(i).stringValue];
    }
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict removeObjectForKey:key];
    }];
    NSLog(@"%s finish.",__func__);
}

- (void)mutableSetMethod {
    NSMutableSet *set = [NSMutableSet setWithArray:self.numbers];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [set removeObject:obj];
    }];
    NSLog(@"%s finish.",__func__);
}

- (void)pointerArrayMethod {
    NSPointerArray *pointerA = [NSPointerArray weakObjectsPointerArray];
    [self.numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pointerA addPointer:(void *)obj];
    }];
    for (NSUInteger i = 0; i < pointerA.count; i++) {
        [pointerA removePointerAtIndex:i];
    }
    NSLog(@"%s finish.",__func__);
}

// crash : -[NSConcretePointerArray removePointerAtIndex:]: attempt to remove pointer at index 500 beyond bounds 500
- (void)pointerArrayCountMethod {
    NSPointerArray *pointerA = [NSPointerArray weakObjectsPointerArray];
    [self.numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pointerA addPointer:(void *)obj];
    }];
    NSUInteger count = pointerA.count;
    for (NSUInteger i = 0; i < count; i++) {
        [pointerA removePointerAtIndex:i];
    }
    NSLog(@"%s finish.",__func__);
}

- (NSMutableArray *)numbers {
    if (!_numbers) {
        _numbers = [NSMutableArray array];
        for (NSUInteger i=0; i<1000; i++) {
            [_numbers addObject:@(i)];
        }
    }
    return _numbers;
}


@end
