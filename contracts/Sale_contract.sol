// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SaleP2P is AccessControl {
    enum AgreementState {
        Created,
        Paid,
        Delivered,
        Disputed,
        Resolved
    }

    struct Agreement {
        address buyer;
        address seller;
        address arbitrator;
        uint256 amount;
        AgreementState state;
        IERC20 token;
    }

    mapping(bytes32 => Agreement) public agreements;

    event AgreementInitiated(
        bytes32 agreementId,
        address buyer,
        address seller,
        address arbitrator,
        uint256 amount,
        IERC20 token
    );
    event PaymentReleased(bytes32 agreementId);
    event ItemDelivered(bytes32 agreementId);
    event DisputeRaised(bytes32 agreementId);
    event DisputeResolved(bytes32 agreementId);

    modifier onlyParties(bytes32 agreementId) {
        require(
            msg.sender == agreements[agreementId].buyer || msg.sender == agreements[agreementId].seller,
            "Invalid Party"
        );
        _;
    }

    modifier onlyArbitrator(bytes32 agreementId) {
        require(msg.sender == agreements[agreementId].arbitrator, "Invalid arbitrator");
        _;
    }

    constructor() {
    }

    function createAgreement(
        address _seller,
        address _arbitrator,
        uint256 _amount,
        IERC20 _token
    ) external {
        bytes32 agreementId = keccak256(abi.encodePacked(msg.sender, _seller, _arbitrator, _amount, _token));
        require(agreements[agreementId].state == AgreementState.Created, "Agreement already exists");

        agreements[agreementId] = Agreement({
            buyer: msg.sender,
            seller: _seller,
            arbitrator: _arbitrator,
            amount: _amount,
            state: AgreementState.Created,
            token: _token
        });

        emit AgreementInitiated(agreementId, msg.sender, _seller, _arbitrator, _amount, _token);
    }

    function pay(bytes32 agreementId) external payable onlyParties(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.state == AgreementState.Created, "Invalid state");

        if (address(agreement.token) == address(0)) {
            require(msg.value == agreement.amount, "Incorrect amount sent");
        } else {
            require(msg.value == 0, "ETH not accepted for token payment");
            require(agreement.token.transferFrom(msg.sender, address(this), agreement.amount), "Token transfer failed");
        }

        agreement.state = AgreementState.Paid;
    }

    function deliverItem(bytes32 agreementId) external onlyParties(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.state == AgreementState.Paid, "Invalid state");

        agreement.state = AgreementState.Delivered;

        emit ItemDelivered(agreementId);
    }

    function raiseDispute(bytes32 agreementId) external onlyParties(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.state == AgreementState.Paid || agreement.state == AgreementState.Delivered, "Invalid state");

        agreement.state = AgreementState.Disputed;

        emit DisputeRaised(agreementId);
    }

    function resolveDispute(bytes32 agreementId, bool buyerWins) external onlyArbitrator(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.state == AgreementState.Disputed, "Invalid state");

        if (buyerWins) {
            if (address(agreement.token) == address(0)) {
                payable(agreement.buyer).transfer(agreement.amount);
            } else {
                require(agreement.token.transfer(agreement.buyer, agreement.amount), "Token transfer failed");
            }
        } else {
            if (address(agreement.token) == address(0)) {
                payable(agreement.seller).transfer(agreement.amount);
            } else {
                require(agreement.token.transfer(agreement.seller, agreement.amount), "Token transfer failed");
            }
        }

        agreement.state = AgreementState.Resolved;

        emit DisputeResolved(agreementId);
    }

    function releasePayment(bytes32 agreementId) external onlyParties(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(agreement.state == AgreementState.Delivered, "Invalid state");

        if (address(agreement.token) == address(0)) {
            payable(agreement.seller).transfer(agreement.amount);
        } else {
            require(agreement.token.transfer(agreement.seller, agreement.amount), "Token transfer failed");
        }

        agreement.state = AgreementState.Resolved;

        emit PaymentReleased(agreementId);
    }
}