# BitCred - Decentralized Academic Credential Management

## Overview

BitCred is a Bitcoin-anchored protocol for secure academic credential management built on Stacks (Layer 2). It enables educational institutions to issue tamper-proof records while allowing enterprises to verify credentials through a reputation-weighted system. The protocol combines cryptoeconomic incentives with Bitcoin's security model for GDPR-compliant educational recordkeeping.

## Key Features

- **Bitcoin-Secured Anchoring**  
  All credential operations are permanently recorded on Bitcoin via Stacks blockchain
- **Institutional Staking**  
  STX token staking requirement (minimum 1M microSTX) for credential issuance rights
- **Reputation-Weighted Verification**  
  Dynamic reputation scores based on endorsement quality and institutional history
- **Delegated Authority Models**  
  Granular permission systems for institutional operations
- **Batch Operations**  
  Efficient bulk credential processing (up to 50 per transaction)
- **Time-Bound Credentials**  
  Bitcoin block height-based expiration system
- **Transfer Framework**  
  Controlled credential ownership transfers with multiple verification states
- **Anti-Fraud Mechanisms**  
  STX slashing conditions for malicious actors

## Technical Architecture

### Data Structures

**Core Storage Maps**

```clarity
1. institutions: Principal → {
  name: string,
  stake-amount: uint,
  reputation-score: uint,
  active: bool,
  ...
}

2. credentials: {id: string, student: principal} → {
  institution: principal,
  verified: bool,
  endorsements: uint,
  expiry-date: uint,
  ...
}

3. endorsements: {credential-id, endorser} → {
  weight: uint,
  comment: string,
  ...
}
```

### System Constants

| Constant          | Value      | Description                         |
| ----------------- | ---------- | ----------------------------------- |
| `MINIMUM_STAKE`   | 1,000,000  | Minimum STX (microSTX) for registry |
| `MAX_BATCH_SIZE`  | 50         | Maximum credentials per batch issue |
| `TRANSFER_EXPIRY` | 144 blocks | Default transfer window (≈24hrs)    |

## Smart Contract Functions

### Institution Management

1. **Register Institution**  
   `(register-institution (name string-ascii-64))`

   - Requires MINIMUM_STAKE STX transfer
   - Initializes reputation score at 100

2. **Delegate Management**  
   `(add-delegate (delegate principal) (permissions list) (expiry uint))`
   - Supports 10 granular permissions
   - Time-bound delegate authority

### Credential Operations

1. **Single Issuance**  
   `(issue-credential (credential-id string) (student principal) ...)`

   - Immutable record creation
   - Automatic reputation adjustment

2. **Batch Issuance**  
   `(batch-issue-credentials (credential-ids list) ...)`
   - Optimized L2 gas efficiency
   - Atomic batch processing

### Verification System

1. **Endorse Credential**  
   `(endorse-credential-extended ... (weight uint) (comment string))`
   - Reputation-weighted validation
   - Multi-type endorser classifications

### Transfer Framework

1. **Initiate Transfer**  
   `(request-credential-transfer ... (transfer-type string))`
   - Supports multiple transfer types
   - Time-bound approval windows

## Error Codes

| Code                     | Value | Description                       |
| ------------------------ | ----- | --------------------------------- |
| ERR-NOT-AUTHORIZED       | 100   | Caller lacks required permissions |
| ERR-INSUFFICIENT-STAKE   | 102   | Below minimum STX requirement     |
| ERR-CREDENTIAL-NOT-FOUND | 103   | Invalid credential ID             |
| ERR-BATCH-FAILED         | 107   | Batch operation partial failure   |

## Usage Examples

### Institution Registration

```clarity
(register-institution "University of Blockchain"
  { stx-transfer: 1000000 })
```

### Credential Issuance

```clarity
(issue-credential
  "BC-2024-MSC-005"
  SP3ABC456789
  "MSc Blockchain"
  2024
  "ipfs://QmCredentialHash"
  2500000
  "postgraduate")
```

### Enterprise Verification

```clarity
(endorse-credential-extended
  "BC-2024-MSC-005"
  SP3ABC456789
  50
  "Verified employment eligibility"
  "corporate")
```

## Security Model

1. **STX Collateralization**  
   Institutions maintain locked STX that can be slashed for fraudulent issuances

2. **Temporal Constraints**  
   All operations reference Bitcoin block height for expiration logic

3. **Delegation Safeguards**

   - Explicit permission whitelisting
   - Automatic expiry of delegate access
   - Activity monitoring through institutional reputation

4. **Revocation Framework**
   - Institution-initiated credential invalidation
   - Permanent blockchain record of revocation actions

## Compliance Features

- GDPR-compliant metadata handling through IPFS hashes
- Right-to-be-forgotten implementation via credential revocation
- Data minimization through on-chain/off-chain separation