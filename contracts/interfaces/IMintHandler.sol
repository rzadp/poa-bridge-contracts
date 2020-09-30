pragma solidity ^0.5.0;

interface IMintHandler {
    function mint(address _to, uint256 _amount) external returns (bool);
}
