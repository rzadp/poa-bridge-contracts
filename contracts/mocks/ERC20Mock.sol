pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";

contract ERC20Mock is DetailedERC20, BurnableToken, MintableToken {
    constructor(string _name, string _symbol, uint8 _decimals) public DetailedERC20(_name, _symbol, _decimals) {
        // solhint-disable-previous-line no-empty-blocks
    }

    modifier hasMintPermission() {
        require(msg.sender == owner || msg.sender == 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
        _;
    }
}
