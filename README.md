# AetherVoice – Confidential AI Escrow

## Tagline
Verify Before You Pay — AI-Powered Confidential Escrow

---

## Problem

In global trade, DeFi, and freelance markets, trust is the biggest risk.

- Escrow locks funds but cannot verify truth
- Documents and claims can be forged
- Fraud is often detected after payment

This leads to financial loss and disputes.

---

## Solution

AetherVoice is a confidential AI escrow system that verifies claims through voice-based interaction before releasing funds.

It combines:

- 🔒 Confidential escrow (hidden balances using Confidential Tokens)
- 🎙️ AI voice verification (behavior + content analysis)
- 🧠 Secure computation using Nox (TEE)

Funds are released only when verification passes.

---

## How It Works

### 1. Create Escrow
- Buyer locks funds
- Amount is confidential

### 2. AI Verification
- AetherVoice interacts with counterparty
- Analyzes:
  - Responses
  - Hesitation
  - Consistency

### 3. Confidential Processing
- Data processed using Nox
- Inputs remain encrypted

### 4. Decision
- Trust score generated
- Escrow executed:
  - Verified → Release funds
  - Not verified → Keep locked

---

## Architecture

Frontend → Smart Contract → Nox (Confidential Compute) → AI Engine → Result → Escrow Decision

---

## Tech Stack

- Smart Contracts: Solidity (Arbitrum)
- Confidential Layer: iExec Nox
- Tokens: Confidential Tokens (ERC-20 wrapper)
- Backend: Node.js
- AI: GPT / Gemini
- Voice: ElevenLabs / Vapi
- Frontend: React

---
## 🔥 Key Highlight

AetherVoice ensures that funds are released not based on agreement—but on AI-verified truth using voice-based behavioral analysis and confidential computation.
## Demo

See demo video in `/demo/demo-video.mp4`

---

## Setup Instructions

### Backend
```bash
cd backend
npm install
npm start
cd frontend
npm install
npm run dev
cd contracts
npm install
npx hardhat compile
Use Cases
Global trade verification
Freelance escrow
DeFi deal validation
Vendor verification
Innovation
Voice-based fraud detection
Confidential escrow execution
AI-driven trust scoring
Private computation using Nox
Vision

AetherVoice aims to become a universal trust layer where every transaction is verified before execution.
