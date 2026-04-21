curl -X POST http://localhost:3000/verify \
-H "Content-Type: application/json" \
-d '{"escrowId":1, "input":"fake audit claim"}'
import { useState } from "react";
import { ethers } from "ethers";
import axios from "axios";

const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS";

const ABI = [
  "function createEscrow(address seller) returns (uint256)",
  "function fundEscrow(uint256 escrowId) payable",
  "function releaseFunds(uint256 escrowId)",
  "function refundBuyer(uint256 escrowId)"
];

function App() {
  const [account, setAccount] = useState("");
  const [seller, setSeller] = useState("");
  const [escrowId, setEscrowId] = useState("");
  const [status, setStatus] = useState("");

  // 🔗 Connect Wallet
  async function connectWallet() {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    setAccount(await signer.getAddress());
  }

  // 🆕 Create Escrow
  async function createEscrow() {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    const tx = await contract.createEscrow(seller);
    await tx.wait();

    setStatus("Escrow created!");
  }

  // 💰 Fund Escrow
  async function fundEscrow() {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    const tx = await contract.fundEscrow(escrowId, {
      value: ethers.parseEther("0.01")
    });

    await tx.wait();
    setStatus("Escrow funded!");
  }

  // 🧠 Trigger AI Verification
  async function verifyEscrow() {
    const res = await axios.post("http://localhost:3000/verify", {
      escrowId,
      input: "fake audit claim"
    });

    setStatus(`Verification: ${res.data.verified}`);
  }

  // ✅ Release Funds
  async function releaseFunds() {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    const tx = await contract.releaseFunds(escrowId);
    await tx.wait();

    setStatus("Funds released!");
  }

  // 🔄 Refund
  async function refund() {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    const tx = await contract.refundBuyer(escrowId);
    await tx.wait();

    setStatus("Refunded!");
  }

  return (
    <div style={{ padding: 30 }}>
      <h1>AetherVoice Escrow Demo</h1>

      <button onClick={connectWallet}>Connect Wallet</button>
      <p>{account}</p>

      <hr />

      <h3>Create Escrow</h3>
      <input
        placeholder="Seller Address"
        onChange={(e) => setSeller(e.target.value)}
      />
      <button onClick={createEscrow}>Create</button>

      <hr />

      <h3>Fund Escrow</h3>
      <input
        placeholder="Escrow ID"
        onChange={(e) => setEscrowId(e.target.value)}
      />
      <button onClick={fundEscrow}>Fund (0.01 ETH)</button>

      <hr />

      <h3>AI Verification</h3>
      <button onClick={verifyEscrow}>Run AI Verification</button>

      <hr />

      <h3>Final Action</h3>
      <button onClick={releaseFunds}>Release Funds</button>
      <button onClick={refund}>Refund</button>

      <hr />

      <h2>Status: {status}</h2>
    </div>
  );
}

export default App;
const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS";
npm run dev

