pragma solidity ^0.5.0;

import "../interfaces/ERC677Receiver.sol";

contract ERC677ReceiverTest is ERC677Receiver {
    address public from;
    uint256 public value;
    bytes public data;
    uint256 public someVar = 0;

    function onTokenTransfer(address _from, uint256 _value, bytes calldata _data) external returns (bool) {
        from = _from;
        value = _value;
        data = _data;
        address(this).call(_data);
        return true;
    }

    function doSomething(uint256 _value) public {
        someVar = _value;
    }
}
