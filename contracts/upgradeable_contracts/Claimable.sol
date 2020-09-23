pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import { Address as PoaAddress } from "../libraries/Address.sol";

contract Claimable {
    bytes4 internal constant TRANSFER = 0xa9059cbb; // transfer(address,uint256)

    modifier validAddress(address _to) {
        require(_to != address(0));
        /* solcov ignore next */
        _;
    }

    function claimValues(address _token, address payable _to) internal {
        if (_token == address(0)) {
            claimNativeCoins(_to);
        } else {
            claimErc20Tokens(_token, _to);
        }
    }

    function claimNativeCoins(address payable _to) internal {
        uint256 value = address(this).balance;
        PoaAddress.safeSendValue(_to, value);
    }

    function claimErc20Tokens(address _token, address _to) internal {
        ERC20 token = ERC20(_token);
        uint256 balance = token.balanceOf(address(this));
        safeTransfer(_token, _to, balance);
    }

    function safeTransfer(address _token, address _to, uint256 _value) internal {
        bytes memory returnData;
        bool returnDataResult;
        bytes memory callData = abi.encodeWithSelector(TRANSFER, _to, _value);
        assembly {
            let result := call(gas, _token, 0x0, add(callData, 0x20), mload(callData), 0, 32)
            returnData := mload(0)
            returnDataResult := mload(0)

            switch result
                case 0 {
                    revert(0, 0)
                }
        }

        // Return data is optional
        if (returnData.length > 0) {
            require(returnDataResult);
        }
    }
}
