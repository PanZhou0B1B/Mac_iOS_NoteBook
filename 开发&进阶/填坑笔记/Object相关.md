# Object相关

## 目录

* [leak宏](#leak宏)
* [对象释放](#关于对象释放的操作顺序)

## <span id = "leak宏"> leak宏 </span>

```
#define MJPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
```

## <span id = "关于对象释放的操作顺序"> 关于对象释放的操作顺序 </span>

// We take advantage of the documented Deallocation Timeline (WWDC 2011, Session 322, 36:22).

1. -release to zero
     * Object is now deallocating and will die.
     * New __weak references are not allowed, and will get nil.
     * [self dealloc] is called
 2. Subclass -dealloc
     * bottom-most subclass -dealloc is called
     * Non-ARC code manually releases iVars
     * Walk the super-class chain calling -dealloc
 3. NSObject -dealloc
     * Simply calls the ObjC runtime object_dispose()
 4. object_dispose()
     * Call destructors for C++ iVars
     * Call -release for ARC iVars
     * Erase associated references
     * Erase __weak references
     * Call free()