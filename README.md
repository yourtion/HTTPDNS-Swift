# HTTPDNS

DNSPod 的 “移动解析服务D+”[（https://www.dnspod.cn/httpdns）](https://www.dnspod.cn/httpdns) 

AliYun HTTPDNS [HTTPDNS API](https://help.aliyun.com/document_detail/dpa/sdk/RESTful/httpdns.html?spm=5176.docdpa/sdk/OneSDK/quick-start-ios.6.104.wmIJqo)

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

## TODO

- [X] 实现 DNSPod 免费版功能
- [ ] 实现 DNSPod 企业版功能（认证接入）
- [ ] 实现AliYun HTTPDNS
- [ ] 自动转换 `URLRequest`
- [X] 提供同步获取方法
- [ ] 允许在初始化时关闭缓存
- [X] 提供清除缓存方法
