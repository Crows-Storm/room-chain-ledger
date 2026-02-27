# 🧾 RoomChain Ledger

> A lightweight room-scoped blockchain ledger for card games & mahjong score tracking, built with Go.

RoomChain Ledger is a scoring system based on **blockchain ledger architecture**, designed specifically for multiplayer games like card games and mahjong.
Each room has an independent ledger, wallets serve as identities, and all score transfers are recorded as transactions, ensuring **immutability, traceability, and auditability**.

---

# ✨ Features

* 🏠 Room-level independent blockchain
* 👛 Wallet-based user identity
* 🔐 Transaction signature verification
* ⛓ Hash chain tamper-proof mechanism
* 🍵 Tea address (public consumption account)
* 🚫 No mining / No tokens / No consensus mechanism
* ⚡ Lightweight single-node operation

---

# 🎯 Project Goals

This project aims to:

1. Practice blockchain ledger technology
2. Implement a real-world multiplayer scoring tool
3. Explore "room-level private blockchain" design patterns
4. Demonstrate core blockchain concepts (wallet / signature / block / hash chain)

---

# 🧱 Core Design

## 1️⃣ Room Model

* Each room has an independent chain
* Rooms cannot be written to after closure
* Wallets are strongly bound to rooms
* Wallets are destroyed after room closure

---

## 2️⃣ Wallet Design

* Wallet = Public-private key pair
* Address = Public key hash
* Must create a wallet to enter a room
* One wallet cannot enter multiple rooms

---

## 3️⃣ Transaction Model

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

Rules:

* All transactions must be signed
* Transactions must verify balance
* Negative transfers not allowed
* Tea address cannot initiate transactions

---

## 4️⃣ Block Model

```go
type Block struct {
    Index        int
    PrevHash     string
    Timestamp    int64
    Transactions []Transaction
    Hash         string
}
```

Characteristics:

* No PoW
* No consensus
* Single-node packaging
* Hash chain prevents tampering

---

## 🍵 Tea Address Design

Each room automatically generates a special address:

* Can only passively receive transfers
* Does not own a private key
* Cannot initiate transactions
* Used to record rake / public consumption

---

# 🔄 Lifecycle

## Create Room

```
CreateRoom()
  ├── Generate TeaAddress
  ├── Create genesis block
  └── Status = Active
```

## Join Room

```
JoinRoom()
  ├── Create wallet
  └── Bind RoomID
```

## Scoring Process

```
CreateTransaction()
  ├── Wallet signature
  ├── Verify balance
  ├── Add to transaction pool
  └── Package into new block
```

## Close Room

```
CloseRoom()
  ├── Generate final block
  ├── Status = Closed
  └── Destroy wallet private keys
```

---

# 💰 Balance Calculation

Supports two modes:

### 1️⃣ Dynamic Calculation (Recommended for learning)

Traverse the entire chain to calculate balance

### 2️⃣ State Snapshot Mode (Recommended for production)

Update account state with each block

---

# 📂 Recommended Project Structure

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

# 🚀 Quick Start

## 1️⃣ Installation

```bash
git clone https://github.com/yourname/roomchain.git
cd roomchain
go mod tidy
```

## 2️⃣ Run

```bash
go run cmd/main.go
```

---

# 🧠 Core Rules Summary

| Rule | Description |
| ----- | --------- |
| Wallet as Identity | Address = User |
| Room Isolation | Each room has independent chain |
| Tea Address | Can only passively receive |
| Single Room Only | Address bound to single room |
| Close & Destroy | Wallet invalidated after room closure |
| Immutable | Hash chain verification |

---

# 📌 Future Extensions

* Merkle Tree
* Multi-signature transaction confirmation
* LAN P2P synchronization
* Web UI
* Mobile API
* Export CSV / JSON
* Multi-round automatic settlement

---

# 🧪 Tech Stack

* Go
* ECDSA signature
* SHA256 hash
* BoltDB / Badger / SQLite (optional)

---

# ⚠️ Disclaimer

This project:

* Does not involve real currency
* Does not involve cryptocurrency issuance
* Not for financial purposes
* Only for learning and entertainment

---

# 📖 Project Philosophy

> The core of blockchain is not "coins", but "immutable ledgers".
