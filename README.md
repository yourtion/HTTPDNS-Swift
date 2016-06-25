# HTTPDNS

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/HTTPDNS-Swift.svg?style=flat)](http://cocoapods.org/pods/HTTPDNS-Swift)
[![License](https://img.shields.io/cocoapods/l/HTTPDNS-Swift.svg?style=flat)](http://cocoapods.org/pods/HTTPDNS-Swift)
[![Platform](https://img.shields.io/cocoapods/p/HTTPDNS-Swift.svg?style=flat)](http://cocoapods.org/pods/HTTPDNS-Swift)
[![Build Status](https://travis-ci.org/yourtion/HTTPDNS-Swift.svg?branch=master)](https://travis-ci.org/yourtion/HTTPDNS-Swift)

HTTPDNS 库 Swift 实现（支持 DNSPod 与 AliyunDNS ）

- DNSPod 的 [移动解析服务D+](https://www.dnspod.cn/httpdns) 

- AliYun HTTPDNS [HTTPDNS API](https://help.aliyun.com/document_detail/dpa/sdk/RESTful/httpdns.html?spm=5176.docdpa/sdk/OneSDK/quick-start-ios.6.104.wmIJqo)

## 安装

### CocoaPod

在 `Podfile` 中添加：

```
platform :ios, '8.0'

pod 'HTTPDNS-Swift'
```

### Carthage

```
github "yourtion/HTTPDNS-Swift"
```


## 使用

### 异步解析

```swift
HTTPDNS.sharedInstance.getRecord("qq.com", callback: { (result) -> Void in
	print("Async QQ.com", result)
})
```

### 同步解析

```swift
print("Sync baidu.com", HTTPDNS.sharedInstance.getRecordSync("baidu.com"))
```

### 清除缓存

```swift
HTTPDNS.sharedInstance.cleanCache()
```

### 切换解析服务

默认为 DNSPod 服务。

切换到 AliYun HTTPDNS，`Key` 为阿里云的 `account id`

```swift
HTTPDNS.sharedInstance.switchProvider(.AliYun, key: "100000")
```

切换到 DNSPod HTTPDNS，`Key` 为 `nil`

```swift
HTTPDNS.sharedInstance.switchProvider(.DNSPod, key: nil)
```

## TODO

- [X] 实现 DNSPod 免费版功能
- [ ] 实现 DNSPod 企业版功能（认证接入）
- [X] 实现AliYun HTTPDNS
- [X] 提供同步获取方法
- [X] 提供清除缓存方法
