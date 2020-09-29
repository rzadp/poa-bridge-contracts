pragma solidity ^0.5.0;

import "../../libraries/PoaAddress.sol";
import "../BaseMediatorFeeManager.sol";

/**
* @title HomeFeeManagerAMBNativeToErc20
* @dev Implements the logic to distribute fees from the native to erc20 mediator contract operations.
* The fees are distributed in the form of native tokens to the list of reward accounts.
*/
contract HomeFeeManagerAMBNativeToErc20 is BaseMediatorFeeManager {
    /**
    * @dev Stores the initial parameters of the fee manager.
    * @param _owner address of the owner of the fee manager contract.
    * @param _fee the fee percentage amount.
    * @param _rewardAccountList list of addresses that will receive the fee rewards.
    */
    constructor(address _owner, uint256 _fee, address[] memory _rewardAccountList, address _mediatorContract)
        public
        BaseMediatorFeeManager(_owner, _fee, _rewardAccountList, _mediatorContract)
    {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
    * @dev Fallback method to receive the fees.
    */
    function() external payable {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
    * @dev Transfer the fee as native tokens to the reward account.
    * @param _rewardAddress address that will receive the native tokens.
    * @param _fee amount of native tokens to be distribute.
    */
    function onFeeDistribution(address payable _rewardAddress, uint256 _fee) internal {
        PoaAddress.safeSendValue(_rewardAddress, _fee);
    }
}
