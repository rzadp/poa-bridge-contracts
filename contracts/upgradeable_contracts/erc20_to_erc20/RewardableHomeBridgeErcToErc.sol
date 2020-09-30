pragma solidity ^0.5.0;

import "../RewardableBridge.sol";

contract RewardableHomeBridgeErcToErc is RewardableBridge {
    function setHomeFee(uint256 _fee) external onlyOwner {
        _setFee(feeManagerContract(), _fee, HOME_FEE);
    }

    function setForeignFee(uint256 _fee) external onlyOwner {
        _setFee(feeManagerContract(), _fee, FOREIGN_FEE);
    }

    function getHomeFee() public returns (uint256) {
        return _getFee(HOME_FEE);
    }

    function getForeignFee() public returns (uint256) {
        return _getFee(FOREIGN_FEE);
    }
}
