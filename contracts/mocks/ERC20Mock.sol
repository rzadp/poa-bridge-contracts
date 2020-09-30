pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract ERC20Mock is ERC20Detailed, ERC20Burnable, ERC20Mintable, Ownable {
    constructor(string memory _name, string memory _symbol, uint8 _decimals)
        public
        ERC20Detailed(_name, _symbol, _decimals)
    {
        // solhint-disable-previous-line no-empty-blocks
    }

    modifier hasMintPermission() {
        require(msg.sender == owner() || msg.sender == 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
        _;
    }
}
