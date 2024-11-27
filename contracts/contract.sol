// SPDX-License-Identifier: MIT
// Requirements
// - 1% tax on each buy/sell but not on the transfer - the tax goes to a specific wallet 
// - be able to offer staking functionality (15% of tokens will be dedicated to staking incentives) 
// - transfer initial tokens to few different wallet once contract is deployed (marketing wallet, reserve wallet, LP wallet…) 
pragma solidity ^0.8.28;

contract TokenWithTaxAndStaking {

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    address public taxWallet; 
    uint256 public taxRate = 1;
    uint256 public stakingPool;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TaxCollected(address indexed from, uint256 amount);
    event TokensStaked(address indexed staker, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        address _taxWallet,
        address[] memory initialWallets,
        uint256[] memory initialAmounts
    ) {
        require(initialWallets.length == initialAmounts.length, "Mismatched wallets and amounts");

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** _decimals;

        taxWallet = _taxWallet;

        uint256 distributed = 0;
        for (uint256 i = 0; i < initialWallets.length; i++) {
            balances[initialWallets[i]] = initialAmounts[i] * 10 ** _decimals;
            distributed += initialAmounts[i] * 10 ** _decimals;
            emit Transfer(address(0), initialWallets[i], initialAmounts[i] * 10 ** _decimals);
        }

        // Dedicate 15% of totalSupply to the staking pool
        stakingPool = (totalSupply * 15) / 100;

        uint256 remaining = totalSupply - distributed - stakingPool;
        balances[msg.sender] = remaining;
        emit Transfer(address(0), msg.sender, remaining);
    }

    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value, false);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(allowances[from][msg.sender] >= value, "Allowance too low");
        allowances[from][msg.sender] -= value;
        _transfer(from, to, value, false);
        return true;
    }

    function buyOrSell(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value, true);
        return true;
    }

    function _transfer(address from, address to, uint256 value, bool applyTax) internal {
        require(balances[from] >= value, "Balance too low");
        uint256 tax = 0;

        if (applyTax) {
            tax = (value * taxRate) / 100;
            balances[taxWallet] += tax;
            emit TaxCollected(from, tax);
        }

        uint256 amountToTransfer = value - tax;
        balances[from] -= value;
        balances[to] += amountToTransfer;
        emit Transfer(from, to, amountToTransfer);
    }

    function stakeTokens(uint256 amount) external {
        require(amount > 0, "Invalid staking amount");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(stakingPool >= amount, "Staking pool depleted");

        balances[msg.sender] -= amount;
        stakingPool -= amount;

        emit TokensStaked(msg.sender, amount);
    }
}
