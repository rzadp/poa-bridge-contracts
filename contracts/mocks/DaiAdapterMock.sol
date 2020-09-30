pragma solidity ^0.5.0;

contract DaiAdapterMock {
    address public dai;

    constructor(address _dai) public {
        dai = _dai;
    }
}
