// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SimpleERC20Token
 * @dev A simple ERC20 token implementation
 */
contract SimpleERC20Token is ERC20, ERC20Burnable, Ownable {
    uint8 private _decimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals_,
        uint256 initialSupply,
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        _decimals = decimals_;
        _mint(owner, initialSupply * 10 ** decimals_);
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
}

/**
 * @title ERC20TokenFactory
 * @dev Factory contract to deploy ERC20 tokens
 */
contract ERC20TokenFactory {
    event TokenCreated(
        address indexed tokenAddress,
        address indexed creator,
        string name,
        string symbol,
        uint256 initialSupply
    );

    address[] public deployedTokens;
    mapping(address => address[]) public userTokens;

    /**
     * @dev Deploy a new ERC20 token
     * @param name Token name
     * @param symbol Token symbol
     * @param decimals Token decimals (usually 18)
     * @param initialSupply Initial supply of tokens
     * @return The address of the deployed token
     */
    function createToken(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initialSupply
    ) public returns (address) {
        SimpleERC20Token token = new SimpleERC20Token(
            name,
            symbol,
            decimals,
            initialSupply,
            msg.sender
        );

        address tokenAddress = address(token);
        deployedTokens.push(tokenAddress);
        userTokens[msg.sender].push(tokenAddress);

        emit TokenCreated(
            tokenAddress,
            msg.sender,
            name,
            symbol,
            initialSupply
        );

        return tokenAddress;
    }

    /**
     * @dev Get all deployed tokens
     * @return Array of token addresses
     */
    function getAllTokens() public view returns (address[] memory) {
        return deployedTokens;
    }

    /**
     * @dev Get tokens created by a user
     * @param user The user address
     * @return Array of token addresses created by the user
     */
    function getUserTokens(address user) public view returns (address[] memory) {
        return userTokens[user];
    }

    /**
     * @dev Get total number of deployed tokens
     * @return The count of deployed tokens
     */
    function getTokenCount() public view returns (uint256) {
        return deployedTokens.length;
    }
}

