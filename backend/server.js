backend/server.js
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://arb-sepolia.g.alchemy.com/v2/your_key
CONTRACT_ADDRESS=your_deployed_contract_address
require("dotenv").config();

const express = require("express");
const { ethers } = require("ethers");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// 🔗 Connect to blockchain
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

// 📜 Contract ABI (only needed functions)
const contractABI = [
  "function submitVerification(uint256 escrowId, bool verified) external"
];

// 📍 Contract instance
const contract = new ethers.Contract(
  process.env.CONTRACT_ADDRESS,
  contractABI,
  wallet
);

// 🧠 Mock AI Verification Function
function runAIVerification(data) {
  console.log("Running AI verification...");

  // 🔥 Simple logic for demo
  if (data.includes("fake") || data.includes("scam")) {
    return false;
  }

  return Math.random() > 0.5;
}

// 🚀 API Endpoint
app.post("/verify", async (req, res) => {
  try {
    const { escrowId, input } = req.body;

    console.log("Verification request:", escrowId);

    // 🧠 Run AI logic
    const result = runAIVerification(input);

    console.log("AI result:", result);

    // ⛓️ Call smart contract
    const tx = await contract.submitVerification(escrowId, result);
    await tx.wait();

    res.json({
      success: true,
      verified: result,
      txHash: tx.hash
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Verification failed" });
  }
});

// 🟢 Start server
app.listen(3000, () => {
  console.log("Backend running on http://localhost:3000");
});
curl -X POST http://localhost:3000/verify \
-H "Content-Type: application/json" \
-d '{"escrowId":1, "input":"fake audit claim"}'
