// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AetherVoiceEscrow {

    // 🔐 Trusted verifier (AI backend / oracle)
    address public verifier;

    constructor(address _verifier) {
        verifier = _verifier;
    }

    // 📊 Escrow Status
    enum Status {
        Created,
        Funded,
        Verified,
        Released,
        Refunded
    }

    // 📦 Escrow Structure
    struct Escrow {
        address buyer;
        address seller;
        uint256 amount;
        Status status;
        bool verified;
    }

    // 📂 Storage
    uint256 public escrowCount;
    mapping(uint256 => Escrow) public escrows;

    // 📢 Events
    event EscrowCreated(uint256 escrowId, address buyer, address seller);
    event EscrowFunded(uint256 escrowId, uint256 amount);
    event VerificationSubmitted(uint256 escrowId, bool verified);
    event FundsReleased(uint256 escrowId);
    event Refunded(uint256 escrowId);
    event VerifierUpdated(address newVerifier);

    // 🆕 1. Create Escrow
    function createEscrow(address _seller) external returns (uint256) {
        escrowCount++;

        escrows[escrowCount] = Escrow({
            buyer: msg.sender,
            seller: _seller,
            amount: 0,
            status: Status.Created,
            verified: false
        });

        emit EscrowCreated(escrowCount, msg.sender, _seller);
        return escrowCount;
    }

    // 💰 2. Fund Escrow
    function fundEscrow(uint256 _escrowId) external payable {
        Escrow storage e = escrows[_escrowId];

        require(msg.sender == e.buyer, "Only buyer can fund");
        require(e.status == Status.Created, "Invalid state");
        require(msg.value > 0, "No funds sent");

        e.amount = msg.value;
        e.status = Status.Funded;

        emit EscrowFunded(_escrowId, msg.value);
    }

    // 🧠 3. Submit AI Verification (Only Verifier)
    function submitVerification(uint256 _escrowId, bool _verified) external {
        require(msg.sender == verifier, "Not authorized verifier");

        Escrow storage e = escrows[_escrowId];
        require(e.status == Status.Funded, "Escrow not funded");

        e.verified = _verified;
        e.status = Status.Verified;

        emit VerificationSubmitted(_escrowId, _verified);
    }

    // ✅ 4. Release Funds (If Verified)
    function releaseFunds(uint256 _escrowId) external {
        Escrow storage e = escrows[_escrowId];

        require(e.status == Status.Verified, "Not verified");
        require(e.verified == true, "Verification failed");

        e.status = Status.Released;

        payable(e.seller).transfer(e.amount);

        emit FundsReleased(_escrowId);
    }

    // 🔄 5. Refund Buyer (If Not Verified)
    function refundBuyer(uint256 _escrowId) external {
        Escrow storage e = escrows[_escrowId];

        require(e.status == Status.Verified, "Not verified");
        require(e.verified == false, "Already verified");

        e.status = Status.Refunded;

        payable(e.buyer).transfer(e.amount);

        emit Refunded(_escrowId);
    }

    // 🔍 View Escrow Details
    function getEscrow(uint256 _escrowId) external view returns (Escrow memory) {
        return escrows[_escrowId];
    }

    // 🔄 Update Verifier (Optional)
    function updateVerifier(address _newVerifier) external {
        require(msg.sender == verifier, "Only current verifier");
        verifier = _newVerifier;

        emit VerifierUpdated(_newVerifier);
    }
}
