// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SimpleNFT
 * @dev A simple ERC721 NFT implementation
 */
contract SimpleNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    string private _baseTokenURI;

    constructor(
        string memory name,
        string memory symbol,
        address owner
    ) ERC721(name, symbol) Ownable(owner) {
        _baseTokenURI = "";
        _nextTokenId = 1; // Start from token ID 1
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function safeMint(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId;
        unchecked {
            _nextTokenId++;
        }
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    function mint(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId;
        unchecked {
            _nextTokenId++;
        }
        _mint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

/**
 * @title NFTFactory
 * @dev Factory contract to deploy NFT collections
 */
contract NFTFactory {
    event NFTCollectionCreated(
        address indexed collectionAddress,
        address indexed creator,
        string name,
        string symbol
    );

    address[] public deployedCollections;
    mapping(address => address[]) public userCollections;

    /**
     * @dev Deploy a new NFT collection
     * @param name Collection name
     * @param symbol Collection symbol
     * @return The address of the deployed NFT collection
     */
    function createNFTCollection(
        string memory name,
        string memory symbol
    ) public returns (address) {
        SimpleNFT nft = new SimpleNFT(name, symbol, msg.sender);

        address collectionAddress = address(nft);
        deployedCollections.push(collectionAddress);
        userCollections[msg.sender].push(collectionAddress);

        emit NFTCollectionCreated(
            collectionAddress,
            msg.sender,
            name,
            symbol
        );

        return collectionAddress;
    }

    /**
     * @dev Get all deployed NFT collections
     * @return Array of collection addresses
     */
    function getAllCollections() public view returns (address[] memory) {
        return deployedCollections;
    }

    /**
     * @dev Get collections created by a user
     * @param user The user address
     * @return Array of collection addresses created by the user
     */
    function getUserCollections(address user) public view returns (address[] memory) {
        return userCollections[user];
    }

    /**
     * @dev Get total number of deployed collections
     * @return The count of deployed collections
     */
    function getCollectionCount() public view returns (uint256) {
        return deployedCollections.length;
    }
}

