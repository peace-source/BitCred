;; Title: 
;; BitCred: Decentralized Academic Credential Management on Stacks
;; 
;; Summary:
;; Secure, Bitcoin-anchored protocol for issuing and verifying academic credentials with institutional reputation systems
;;
;; Description:
;; BitCred is a STACKS Layer 2 solution for academic credential management that combines Bitcoin's security with smart contract automation. 
;; Institutions stake STX tokens to register and issue tamper-proof academic records, while enterprises can verify credentials through 
;; an endorsement system with reputation weighting. Features include batch credential operations, time-limited transfers, and delegated 
;; authority models, all anchored to Bitcoin blocks for immutable audit trails. Designed for GDPR-compliant educational recordkeeping,
;; BitCred enables global credential portability while maintaining institutional accountability through cryptoeconomic incentives.
;;
;; Key Innovations:
;; - Bitcoin-secured credential issuance with STX staking requirements
;; - Reputation-weighted endorsement system for enterprise verification
;; - Institutional delegation models with granular permissions
;; - STX-based slashing conditions for fraudulent issuance
;; - Bitcoin block height-bound credential expiration
;; - Batch operations optimized for Layer 2 efficiency

;; Constants
(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-INSUFFICIENT-STAKE (err u102))
(define-constant ERR-CREDENTIAL-NOT-FOUND (err u103))
(define-constant ERR-ALREADY-VERIFIED (err u104))
(define-constant ERR-INVALID-STATUS (err u105))
(define-constant ERR-EXPIRED (err u106))
(define-constant ERR-BATCH-FAILED (err u107))
(define-constant ERR-TRANSFER-FAILED (err u108))
(define-constant ERR-INVALID-BATCH-SIZE (err u109))
(define-constant ERR-INVALID-DELEGATION (err u110))
(define-constant ERR-ALREADY-ENDORSED (err u111))
(define-constant MINIMUM-STAKE u1000000)
(define-constant MAX-BATCH-SIZE u50)

;; Data Variables
(define-data-var transfer-counter uint u0)
(define-data-var total-institutions uint u0)
(define-data-var governance-token-address principal 'SP000000000000000000002Q6VF78)

;; Data Maps
(define-map institutions 
    principal 
    {
        name: (string-ascii 64),
        stake-amount: uint,
        credentials-issued: uint,
        reputation-score: uint,
        active: bool,
        suspension-status: bool,
        registration-date: uint,
        last-update: uint
    }
)

(define-map credentials
    {id: (string-ascii 64), student: principal}
    {
        institution: principal,
        degree: (string-ascii 64),
        year: uint,
        verified: bool,
        endorsements: uint,
        metadata-url: (string-ascii 256),
        expiry-date: uint,
        revoked: bool,
        category: (string-ascii 32),
        issue-date: uint,
        last-endorsed: uint
    }
)

(define-map endorsements
    {credential-id: (string-ascii 64), endorser: principal}
    {
        timestamp: uint,
        weight: uint,
        comment: (string-ascii 256),
        endorser-type: (string-ascii 32)
    }
)

(define-map institution-delegates
    {institution: principal, delegate: principal}
    {
        active: bool,
        permissions: (list 10 (string-ascii 32)),
        added-at: uint,
        expiry: uint
    }
)

(define-map transfer-requests
    uint
    {
        credential-id: (string-ascii 64),
        old-owner: principal,
        new-owner: principal,
        status: (string-ascii 16),
        request-time: uint,
        expiry-time: uint,
        transfer-type: (string-ascii 32)
    }
)