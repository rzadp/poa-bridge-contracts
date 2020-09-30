pragma solidity ^0.5.0;

contract TokenSwapper {
    // emitted when two tokens is swapped (e. g. Sai to Dai, Chai to Dai)
    event TokensSwapped(address indexed from, address indexed to, uint256 value);
}
