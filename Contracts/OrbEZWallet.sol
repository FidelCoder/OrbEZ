// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/account-abstraction/ERC4337.sol";

contract OrbEZWallet is ERC4337 {
    address public owner;
    mapping(address => uint256) public balances; // Token balances (e.g., $ORBEZ, USDC)
    mapping(string => address) public currencyToToken; // Local currency -> stablecoin mapping

    event PaymentSent(address indexed to, uint256 amount, string currency);
    event FundsConverted(uint256 amount, address token, string currency);

    constructor(address _owner) {
        owner = _owner;
    }

    // ERC-4337 entry point for user ops
    function execute(address dest, uint256 value, bytes calldata func) external {
        require(msg.sender == owner, "Only owner");
        (bool success, ) = dest.call{value: value}(func);
        require(success, "Exec failed");
    }

    // Auto-convert incoming local currency to token
    function receiveFunds(uint256 amount, string memory localCurrency) external {
        address token = currencyToToken[localCurrency];
        require(token != address(0), "Unsupported currency");
        uint256 convertedAmount = convertToToken(amount, localCurrency);
        balances[token] += convertedAmount;
        emit FundsConverted(convertedAmount, token, localCurrency);
    }

    // Send funds, auto-convert to recipient's currency if off-network
    function sendFunds(address to, uint256 amount, string memory targetCurrency) external {
        require(msg.sender == owner, "Only owner");
        address token = currencyToToken[targetCurrency];
        if (token == address(0)) {
            // Off-network: bridge to fiat (mock for now)
            bridgeToFiat(to, amount, targetCurrency);
        } else {
            balances[token] -= amount;
            (bool success, ) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
            require(success, "Transfer failed");
        }
        emit PaymentSent(to, amount, targetCurrency);
    }

    // Placeholder conversion logic (oracle integration later)
    function convertToToken(uint256 amount, string memory currency) internal pure returns (uint256) {
        return amount; // Stub, replaced with oracle later
    }

    function bridgeToFiat(address to, uint256 amount, string memory currency) internal {
        // Bridge logic stub (Orbit bridge later)
    }
}