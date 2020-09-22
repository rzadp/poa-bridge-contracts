pragma solidity ^0.5.0;

interface IMediatorFeeManager {
    function calculateFee(uint256) external view returns (uint256);
}
