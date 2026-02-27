# 🧾 RoomChain Ledger

> A lightweight room-scoped blockchain ledger for card games & mahjong score tracking, built with Go.

RoomChain Ledger 是一个基于 **区块链账本结构** 的记分系统，专用于打牌、麻将等多人游戏场景。
每个房间拥有独立账本，钱包即身份，所有分数流转均以交易形式记录，保证**不可篡改、可追溯、可审计**。

---

# ✨ 项目特点

* 🏠 房间级独立区块链
* 👛 钱包即用户身份
* 🔐 交易签名校验
* ⛓ Hash 链防篡改
* 🍵 茶水地址（公共消费账户）
* 🚫 无挖矿 / 无代币 / 无共识机制
* ⚡ 轻量级单节点运行

---

# 🎯 项目目标

本项目旨在：

1. 实战区块链账本技术
2. 实现一个真实可用的多人记分工具
3. 探索“房间级私有区块链”设计模式
4. 演示区块链核心概念（钱包 / 签名 / 区块 / Hash 链）

---

# 🧱 核心设计

## 1️⃣ 房间模型

* 每个房间拥有独立链
* 房间关闭后不可再写入
* 钱包与房间强绑定
* 房间关闭后钱包销毁

---

## 2️⃣ 钱包设计

* 钱包 = 公私钥对
* 地址 = 公钥 Hash
* 进入房间必须创建钱包
* 一个钱包不可进入多个房间

---

## 3️⃣ 交易模型

```go
type Transaction struct {
    ID        string
    From      string
    To        string
    Amount    int64
    Signature []byte
    Timestamp int64
}
```

规则：

* 所有交易必须签名
* 交易必须验证余额
* 不允许负数转账
* 茶水地址不可主动发起交易

---

## 4️⃣ 区块模型

```go
type Block struct {
    Index        int
    PrevHash     string
    Timestamp    int64
    Transactions []Transaction
    Hash         string
}
```

特点：

* 无 PoW
* 无共识
* 单节点打包
* Hash 串联防篡改

---

## 🍵 茶水地址设计

每个房间自动生成一个特殊地址：

* 只能被动接收转账
* 不拥有私钥
* 不可主动发起交易
* 用于记录抽水 / 公共消费

---

# 🔄 生命周期

## 创建房间

```
CreateRoom()
  ├── 生成 TeaAddress
  ├── 创建创世块
  └── 状态 = Active
```

## 加入房间

```
JoinRoom()
  ├── 创建钱包
  └── 绑定 RoomID
```

## 记分流程

```
CreateTransaction()
  ├── 钱包签名
  ├── 验证余额
  ├── 加入交易池
  └── 打包进新区块
```

## 关闭房间

```
CloseRoom()
  ├── 生成最终区块
  ├── 状态 = Closed
  └── 销毁钱包私钥
```

---

# 💰 余额计算

支持两种模式：

### 1️⃣ 动态计算（推荐学习用）

遍历整条链计算余额

### 2️⃣ 状态快照模式（推荐生产用）

每个区块更新账户状态

---

# 📂 推荐项目结构

```
roomchain/
├── cmd/
│   └── main.go
├── internal/
│   ├── room/
│   ├── wallet/
│   ├── chain/
│   ├── tx/
│   ├── block/
│   └── storage/
├── pkg/
│   └── crypto/
└── README.md
```

---

# 🚀 快速开始

## 1️⃣ 安装

```bash
git clone https://github.com/yourname/roomchain.git
cd roomchain
go mod tidy
```

## 2️⃣ 运行

```bash
go run cmd/main.go
```

---

# 🧠 核心规则总结

| 规则    | 描述        |
| ----- | --------- |
| 钱包即身份 | 地址 = 用户   |
| 房间隔离  | 每房独立链     |
| 茶水地址  | 只能被动接收    |
| 不可多房  | 地址绑定单房    |
| 关闭销毁  | 房间关闭后钱包失效 |
| 不可篡改  | Hash 串联校验 |

---

# 📌 未来扩展方向

* Merkle Tree
* 多签确认交易
* 局域网 P2P 同步
* Web UI
* 移动端 API
* 导出 CSV / JSON
* 多轮自动结算

---

# 🧪 技术栈

* Go
* ECDSA 签名
* SHA256 Hash
* BoltDB / Badger / SQLite（可选）

---

# ⚠️ 免责声明

本项目：

* 不涉及真实货币
* 不涉及加密货币发行
* 不用于金融用途
* 仅作为学习与娱乐工具

---

# 📖 项目理念

> 区块链的核心不是“币”，而是“不可篡改的账本”。