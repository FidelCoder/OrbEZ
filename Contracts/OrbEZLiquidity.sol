// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OrbEZLiquidity {
    mapping(address => uint256) public staked;
    uint256 public totalLiquidity;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function stake(uint256 amount) external {
        staked[msg.sender] += amount;
        totalLiquidity += amount;
        (bool success, ) = address(this).call{value: amount}("");
        require(success, "Stake failed");
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(staked[msg.sender] >= amount, "Insufficient stake");
        staked[msg.sender] -= amount;
        totalLiquidity -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }
}