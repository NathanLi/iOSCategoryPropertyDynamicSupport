# iOSCategoryPropertyDynamicSupport
iOS Class Category property dynamic support

动态给分类的以 nl_ 开头命名的属性添加相应的 getter、setter 方法
在分类中添加一些自定义的属性的场景还是蛮多的。一般的方法是自定义其 getter、setter 方法，在这些方法
里面再用关联对象等手段来实现。虽然不难，却也麻烦且重复。
本类的目的在于解放这些重复的劳动。

   使用：
      1、导入本类及相关类（NSObject+nl_dynamicPropertySupport目录下）
      2、在分类中定义属性时，要以 `nl_` 开头
      3、在分类的实现体中，给属性加上 @dynamic

   优点：
      1、所有的对象、基本数据类型
      2、支持系统已有的 [NSValue valueWith...] 方法的结构体（详见 NSValue ）。如：CGRect
      3、支持 KVC
      4、支持 KVO
      5、支持 strong、copy、weak

   不足：
      1、不支持自定义的结构体。
         但可以通过 `+ nl_missMethodWithPropertyDescriptor:selector:` 来实现。实现方法可见：（nl_dynamicPropertyCustomeStruct分类）
      2、注意：KVO 支持不完美。
         当观察动态生成的 weak 属性时，不会接收到 weak 自动设置为 nil 的通知（在 weak 指向的对象被销毁时，weak 属性会自动设置为 nil）。

