# 埋点查看组件（XYEventLogExplore）使用文档

## 作用

可以在桌面端用浏览器查看当前的所有埋点输出，可以进行渠道和关键字过滤，可以查看当前版本下的埋点信息。也可以查看相关log输出。

![image-20200331100105117](https://tva1.sinaimg.cn/large/00831rSTly1gdcw1y1vzbj31eu0u0dxc.jpg)

## 接入

1. CocoaPods 引入

   ```objective-c
   pod 'XYEventLogExplore', '0.1.0'
   ```

2. 抄送埋点

   在发送埋点的时候，抄送一份到`XYEventLogExplore`，如果你使用XYUserLoggerKit，那么这个过程是自动完成的

3. 启动埋点监控

   这个步骤是为了监控当前版本埋点的录入状态

   ```objective-c
   [[XYEventCheckManager sharedInstance] start];
   ```

   如果你使用XYUserLoggerKit，那么这个过程是自动完成的

## 使用

1. 开启服务器

   开启服务器之后才会记录埋点，所以应该在适当的时机调用以下方法

   ```objective-c
   [[XYWebCheckLogger shared] startServer]
   ```

2. 关闭服务器

   ```objective-c
   [[XYWebCheckLogger shared] stopServer]
   ```

3. 获取服务器地址

   获取服务器地址后，在浏览器中输入，即可查看埋点信息

   ```objective-c
   [[XYWebCheckLogger shared] checkURL]
   ```



## 使用依赖

内部依赖 XYMediAppInfo来提供productID信息，所以必须初始化XYMediAppInfo
