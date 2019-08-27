# EnumerateAndDelete
iOS 中各种可遍历的对象，在遍历中删除元素是否会崩溃？

## 结论
 **对 可变且可遍历的对象，记为 map, 进行遍历**
 1. 正序遍历过程中，删除元素，如果遍历长度固定，则有可能引发崩溃；例如：foriCountMethod
 2. 正序遍历过程中，删除元素，如果遍历长度不固定，且为 map.count，则不会引发崩溃；例如：foriMethod
 3. 倒序遍历过程中，删除元素，不会引发崩溃；例如：foriRevertMethod
 4. 字典使用 -(void)enumerate* 遍历过程中，删除元素，不会引发崩溃；例如：dictionaryMethod
 5. 集合使用 -(void)enumerate* 遍历过程中，删除元素，不会引发崩溃；例如：mutableSetMethod
 6. NSPointerArray 遍历过程中，删除元素，与 NSMutableArray 的结果一致；例如：pointerArrayMethod


