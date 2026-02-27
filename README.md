# Room Chain Ledger

Room Chain Ledger 是一个基于 Go 构建的微服务化记分链系统。
项目结合“房间记账”与“区块链账本”模型，用于多人打牌、麻将等场景下的分数流转记录，同时作为公链原型的工程实践。

系统采用独立账本服务（blockchain_node）与业务域服务（room_service）解耦设计，支持未来升级为多节点公链网络。

---

# 一、核心目标

* 使用区块链账本模型记录每一笔分数转移
* 钱包地址即为身份
* 引入房间隔离概念
* 支持茶水地址（公共抽水账户）
* 微服务架构
* LevelDB 本地账本存储
* Redis 分布式缓存
* gRPC 服务间通信

---

# 二、系统架构

## 服务拓扑

```
Client
   ↓
tx-gateway
   ↓
room_service
   ↓
blockchain_node
```

wallet_service 提供钱包生成与签名能力。

---

## 服务职责划分

### 1. blockchain_node

账本核心引擎。

职责：

* 交易验证
* 签名校验
* 交易池管理
* 区块生成
* 区块持久化（LevelDB）
* 查询余额
* 查询区块
* 查询交易

数据存储：

* LevelDB（嵌入式）

---

### 2. room_service

房间业务域服务。

职责：

* 创建房间
* 加入房间
* 关闭房间
* 茶水地址管理
* 构造交易
* 调用 blockchain_node 提交交易
* 房间成员校验

数据存储：

* Redis（房间状态缓存）

---

### 3. wallet_service

钱包与签名服务。

职责：

* 创建钱包
* 地址生成
* 交易签名
* 地址与房间绑定限制

数据存储：

* Redis（会话信息）
* 本地密钥文件（可选）

---

### 4. tx-gateway（可选）

统一入口层。

职责：

* 鉴权
* 限流
* 请求路由
* 接入层隔离

---

# 三、技术栈

| 组件    | 技术           |
| ----- | ------------ |
| 开发语言  | Go 1.25.x    |
| 服务通信  | gRPC         |
| 账本存储  | LevelDB      |
| 缓存    | Redis        |
| 配置管理  | Viper + 环境变量 |
| 容器化   | Docker       |
| 编排    | Kubernetes   |
| 工作区管理 | go.work      |

---

# 四、项目结构

```
room-chain-ledger
 ├── services
 │     ├── blockchain_node
 │     ├── room_service
 │     ├── wallet_service
 │     └── tx-gateway
 │
 ├── pkg
 │     ├── crypto
 │     ├── logger
 │     ├── config
 │
 ├── api
 │     ├── proto
 │     └── gen
 │
 ├── deploy
 │     ├── docker
 │     └── k8s
 │
 ├── go.work
```

说明：

* 每个 service 独立 go.mod
* pkg 为共享模块
* api/proto 定义跨服务协议
* go.work 用于本地多模块联调

---

# 五、核心业务模型

## 钱包（Wallet）

* 地址即身份
* 地址不可进入多个房间
* 房间关闭后地址失效

---

## 房间（Room）

* 创建者生成茶水地址
* 成员进入后绑定地址
* 所有转账必须携带 room_id
* 房间关闭后不允许再发交易

---

## 茶水地址

* 每个房间唯一
* 仅记录公共消费
* 不主动发起交易
* 无自动抽水逻辑
* 必须由成员主动发起转账

---

## 交易模型

当前使用账户模型：

* from_address
* to_address
* amount
* nonce
* room_id
* signature

---

# 六、配置结构（示例）

## blockchain_node

* server.port
* leveldb.path
* block.interval
* chain.id
* node.private_key

---

## room_service

* server.port
* redis.addr
* redis.password
* blockchain.rpc_endpoint

---

## wallet_service

* server.port
* redis.addr
* key.storage.path

---

# 七、运行依赖

启动前需要：

* Redis 实例
* 每个服务独立端口
* LevelDB 本地存储目录

---

# 八、部署方式

## 本地开发

* 使用 go.work 联调
* 各服务独立启动
* 本地 Redis

---

## 容器化部署

每个服务独立 Docker 镜像。

---

## Kubernetes 部署

* ConfigMap 管理普通配置
* Secret 管理私钥与密码
* 每个服务独立 Deployment
* blockchain_node 使用 PersistentVolume

---

# 九、系统边界原则

* blockchain_node 不感知房间业务
* room_service 不直接访问 LevelDB
* 所有账本写入必须通过 gRPC
* crypto 为共享模块，不是微服务
* Redis 不作为最终账本

---

# 十、未来扩展方向

* 多节点 P2P 网络
* 共识机制（PoA / PBFT）
* 区块同步
* 区块广播
* 监控服务
* Web 控制台
* 可视化区块浏览器

---

# 十一、设计哲学

* 账本域与业务域解耦
* 单节点可运行
* 可演进为公链
* 强约束房间边界
* 明确微服务职责

---

# 十二、当前阶段定位

本项目当前为：

* 单节点账本
* 微服务架构练习
* 公链工程实践原型
* 房间分数流转链

不是完整公链网络。

---