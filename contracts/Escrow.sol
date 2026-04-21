enum Status {
    Created,
    Funded,
    Verified,
    Released,
    Refunded
}
struct Escrow {
    address buyer;
    address seller;
    uint256 amount;
    Status status;
    bool verified;
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AetherVoiceEscrow {

    enum Status {
        Created,
        Funded,
        Verified,
        Released,
        Refunded
    }

    struct Escrow {
        address buyer;
        address seller;
        uint256 amount;
        Status status;
        bool verified;
    }

    uint256 public escrowCount;
    mapping(uint256 => Escrow) public escrows;

    event EscrowCreated(uint256 escrowId, address buyer, address seller);
    event EscrowFunded(uint256 escrowId, uint256 amount);
    event VerificationSubmitted(uint256 escrowId, bool verified);
    event FundsReleased(uint256 escrowId);
    event Refunded(uint256 escrowId);

    // 1️⃣ Create Escrow
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

    // 2️⃣ Fund Escrow
    function fundEscrow(uint256 _escrowId) external payable {
        Escrow storage e = escrows[_escrowId];

        require(msg.sender == e.buyer, "Only buyer");
        require(e.status == Status.Created, "Invalid state");
        require(msg.value > 0, "No funds");

        e.amount = msg.value;
        e.status = Status.Funded;

        emit EscrowFunded(_escrowId, msg.value);
    }

    // 3️⃣ Submit AI Verification Result
    function submitVerification(uint256 _escrowId, bool _verified) external {
        Escrow storage e = escrows[_escrowId];

        require(e.status == Status.Funded, "Not funded yet");

        // ⚠️ For hackathon: allow anyone (or restrict later)
        e.verified = _verified;
        e.status = Status.Verified;

        emit VerificationSubmitted(_escrowId, _verified);
    }

    // 4️⃣ Release Funds (if verified)
    function releaseFunds(uint256 _escrowId) external {
        Escrow storage e = escrows[_escrowId];

        require(e.status == Status.Verified, "Not verified");
        require(e.verified == true, "Verification failed");

        e.status = Status.Released;

        payable(e.seller).transfer(e.amount);

        emit FundsReleased(_escrowId);
    }

    // 5️⃣ Refund Buyer (if not verified)
    function refundBuyer(uint256 _escrowId) external {
        Escrow storage e = escrows[_escrowId];

        require(e.status == Status.Verified, "Not verified");
        require(e.verified == false, "Already verified");

        e.status = Status.Refunded;

        payable(e.buyer).transfer(e.amount);

        emit Refunded(_escrowId);
    }

    // View Escrow
    function getEscrow(uint256 _escrowId) external view returns (Escrow memory) {
        return escrows[_escrowId];
    }
}
address public verifier;
require(msg.sender == verifier);
