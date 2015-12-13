# HTTPDNS

DNSPod 的 “移动解析服务D+”[（https://www.dnspod.cn/httpdns）](https://www.dnspod.cn/httpdns) 的 Swift 实现。

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

- [ ] 实现企业版功能（认证接入）
- [ ] 自动转换 `URLRequest`
- [ X ] 提供同步获取方法
- [ ] 允许在初始化时关闭缓存
- [ ] 提供清除缓存方法
