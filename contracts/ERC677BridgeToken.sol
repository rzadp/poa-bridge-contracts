pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/Address.sol";
import "./interfaces/IBurnableMintableERC677Token.sol";
import "./upgradeable_contracts/Claimable.sol";

/**
* @title ERC677BridgeToken
* @dev The basic implementation of a bridgeable ERC677-compatible token
*/
contract ERC677BridgeToken is IBurnableMintableERC677Token, ERC20Detailed, ERC20Burnable, ERC20Mintable, Claimable, Ownable {
    bytes4 internal constant ON_TOKEN_TRANSFER = 0xa4c0ed36; // onTokenTransfer(address,uint256,bytes)

    address internal bridgeContractAddr;

    event ContractFallbackCallFailed(address from, address to, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals) public ERC20Detailed(_name, _symbol, _decimals) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function bridgeContract() external view returns (address) {
        return bridgeContractAddr;
    }

    function setBridgeContract(address _bridgeContract) external onlyOwner {
        require(Address.isContract(_bridgeContract));
        bridgeContractAddr = _bridgeContract;
    }

    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this));
        /* solcov ignore next */
        _;
    }

    function transferAndCall(address _to, uint256 _value, bytes calldata _data) external validRecipient(_to) returns (bool) {
        require(superTransfer(_to, _value));
        emit Transfer(msg.sender, _to, _value, _data);

        if (Address.isContract(_to)) {
            require(contractFallback(msg.sender, _to, _value, _data));
        }
        return true;
    }

    function getTokenInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {
        return (2, 2, 0);
    }

    function superTransfer(address _to, uint256 _value) internal returns (bool) {
        return super.transfer(_to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(superTransfer(_to, _value));
        callAfterTransfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(super.transferFrom(_from, _to, _value));
        callAfterTransfer(_from, _to, _value);
        return true;
    }

    function callAfterTransfer(address _from, address _to, uint256 _value) internal {
        if (Address.isContract(_to) && !contractFallback(_from, _to, _value, new bytes(0))) {
            require(!isBridge(_to));
            emit ContractFallbackCallFailed(_from, _to, _value);
        }
    }

    function isBridge(address _address) public view returns (bool) {
        return _address == bridgeContractAddr;
    }

    /**
     * @dev call onTokenTransfer fallback on the token recipient contract
     * @param _from tokens sender
     * @param _to tokens recipient
     * @param _value amount of tokens that was sent
     * @param _data set of extra bytes that can be passed to the recipient
     */
    function contractFallback(address _from, address _to, uint256 _value, bytes memory _data) private returns (bool) {
        (bool result, ) = _to.call(abi.encodeWithSelector(ON_TOKEN_TRANSFER, _from, _value, _data));
        return result;
    }

    function finishMinting() public returns (bool) {
        revert();
    }

    function renounceOwnership() public onlyOwner {
        revert();
    }

    function claimTokens(address _token, address payable _to) public onlyOwner validAddress(_to) {
        claimValues(_token, _to);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}
