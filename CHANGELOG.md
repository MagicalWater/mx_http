## 1.0.3
- 抽離自動生成request內容相關的程式碼到[mx_request_generator](https://pub.dev/packages/mx_request_generator)套件
- 修正當沒有指定contentType時, 會導致body沒有生效的問題

## 1.0.2
- 調整dio extension加入mxDownload, 表明使用下載的方式進行請求
- 調整dio extension原本的connect方法名稱, 變更為mxRequest
- 新增RequestContent擴展, 分別加入request與download, 對應dio的mxRequest與mxDownload

## 1.0.1
- 調整meta套件的版本最小為1.15.0, 與flutter SDK同步

## 1.0.0
- 前身為mx_http, 拋棄HttpUtil, 更改為圍繞的Dio套件的擴展
- 優化自動生成請求的內容
