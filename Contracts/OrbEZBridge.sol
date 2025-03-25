// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OrbEZBridge {
    mapping(address => mapping(address => uint256)) public crossChainBalances;

    event Bridged(address indexed fromChain, address indexed toChain, uint256 amount);

    function bridge(address toChain, uint256 amount) external {
        // Lock funds on Orbit L3, signal to target chain (mock for now)
        crossChainBalances[msg.sender][toChain] += amount;
        emit Bridged(address(this), toChain, amount);
    }
}