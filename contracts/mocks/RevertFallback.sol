pragma solidity ^0.5.0;

import {Address as PoaAddress} from "../libraries/Address.sol";

contract RevertFallback {
    function() external payable {
        revert();
    }

    function receiveEth() public payable {
        // solhint-disable-previous-line no-empty-blocks
    }

    function sendEth(address payable _receiver, uint256 _value) public {
        // solhint-disable-next-line check-send-result
        require(_receiver.send(_value));
    }

    function safeSendEth(address payable _receiver, uint256 _value) public {
        PoaAddress.safeSendValue(_receiver, _value);
    }
}
