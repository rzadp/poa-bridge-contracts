pragma solidity ^0.5.0;

import "../../interfaces/IBlockReward.sol";
import "../../libraries/Address.sol" as PoaAddress;
import "../ValidatorsFeeManager.sol";
import "../BlockRewardBridge.sol";

contract FeeManagerErcToNative is ValidatorsFeeManager, BlockRewardBridge {
    function getFeeManagerMode() external pure returns (bytes4) {
        return 0xd7de965f; // bytes4(keccak256(abi.encodePacked("manages-both-directions")))
    }

    function onAffirmationFeeDistribution(address _rewardAddress, uint256 _fee) internal {
        IBlockReward blockReward = _blockRewardContract();
        blockReward.addExtraReceiver(_fee, _rewardAddress);
    }

    function onSignatureFeeDistribution(address _rewardAddress, uint256 _fee) internal {
        PoaAddress.safeSendValue(_rewardAddress, _fee);
    }

    function getAmountToBurn(uint256 _value) public view returns (uint256) {
        uint256 fee = calculateFee(_value, false, HOME_FEE);
        return _value.sub(fee);
    }
}
