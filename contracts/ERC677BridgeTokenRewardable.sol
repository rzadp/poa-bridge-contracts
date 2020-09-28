pragma solidity ^0.5.0;

import "./ERC677MultiBridgeToken.sol";

contract ERC677BridgeTokenRewardable is ERC677MultiBridgeToken {
    address public blockRewardContract;
    address public stakingContract;
    mapping (address => uint256) private _balances;

    function setBalanceOf(address owner, uint value) internal returns (uint256) {
        _balances[owner] = value;
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _chainId)
        public
        ERC677MultiBridgeToken(_name, _symbol, _decimals, _chainId)
    {
        // solhint-disable-previous-line no-empty-blocks
    }

    function setBlockRewardContract(address _blockRewardContract) external onlyOwner {
        require(Address.isContract(_blockRewardContract));
        blockRewardContract = _blockRewardContract;
    }

    function setStakingContract(address _stakingContract) external onlyOwner {
        require(Address.isContract(_stakingContract));
        require(balanceOf(_stakingContract) == 0);
        stakingContract = _stakingContract;
    }

    modifier onlyBlockRewardContract() {
        require(msg.sender == blockRewardContract);
        /* solcov ignore next */
        _;
    }

    modifier onlyStakingContract() {
        require(msg.sender == stakingContract);
        /* solcov ignore next */
        _;
    }

    function mintReward(uint256 _amount) external onlyBlockRewardContract {
        if (_amount == 0) return;
        // Mint `_amount` for the BlockReward contract
        address to = blockRewardContract;
        _mint(to, _amount);
        emit Mint(to, _amount);
    }

    function stake(address _staker, uint256 _amount) external onlyStakingContract {
        // Transfer `_amount` from `_staker` to `stakingContract`
        setBalanceOf(_staker, balanceOf(_staker).sub(_amount));
        setBalanceOf(stakingContract, balanceOf(stakingContract).add(_amount));
        emit Transfer(_staker, stakingContract, _amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != blockRewardContract);
        require(_to != stakingContract);
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != blockRewardContract);
        require(_to != stakingContract);
        return super.transferFrom(_from, _to, _value);
    }

    event Mint(address indexed to, uint256 amount);
}
