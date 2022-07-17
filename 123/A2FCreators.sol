// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC721A.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title A contract for ....
/// @notice NFT Minting
contract A2FCreators is ERC721A, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    string private baseURI;

    uint256 private _price;
    uint256 public totalLimit;
    uint256 public batchSize;

    constructor(string memory name, 
                    string memory symbol, 
                    uint256 mbatchSize, 
                    uint256 mtotalLimit,
                    uint256 price
                ) ERC721A(name, symbol, mbatchSize, mtotalLimit) {
        _price = price;
        batchSize = mbatchSize;
        totalLimit = mtotalLimit;
    }

    event Mint (address indexed _from,
                uint256 _tokenId,
                uint256 _mintPrice,
                uint256 _mintCount);
    /**
    * override tokenURI
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
    }

     /*
     * Verify Whitelist using MerkleTree 
     */

    function refundIfOver (uint256 price) private {
        require(msg.value >= price, "Need to send more ETH.");

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }

    /**
     * public sale 
    */
    function mintPublic (uint256 _mintCount) external payable nonReentrant returns (uint256) {
        require(msg.sender != address(0));
        require(_mintCount > 0 && _mintCount <= batchSize, "Mint amount is over transaction limitation");
        require(balanceOf(msg.sender) + _mintCount <= totalLimit, "Sold out");
        require(msg.value >= (_price * _mintCount), "Balance is not enough");

        _safeMint(msg.sender, _mintCount);
        refundIfOver(_price * _mintCount);

        emit Mint(msg.sender, totalSupply(), _price, _mintCount);
        return totalSupply();
    }

    // Get balance 
    function getBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    /**
     * Get TokenList by sender
    */
    function getTokenList(address account) external view returns (uint256[] memory) {
        require(account != address(0));

        uint256 count = balanceOf(account);
        uint256[] memory tokenIdList = new uint256[](count);

        if (count == 0) {
            return tokenIdList;
        }

        uint256 cnt = 0;

        for (uint256 i = 1; i < (totalSupply() + 1); i++) {
            if (_exists(i) && (ownerOf(i) == account)) {
                tokenIdList[cnt++] = i;
            }

            if (cnt == count) {
                break;
            }
        }

        return tokenIdList;
    }

    ///Set Methods

    function setBaseURI(string memory _baseURI) external onlyOwner returns(string memory) {
        baseURI = _baseURI;
        return baseURI;
    }

    function setTotalLimit(uint256 _totalLimit) external onlyOwner returns (uint256) {
        totalLimit = _totalLimit;
        return totalLimit;
    }

    function setBatchSize(uint256 _batchSize) external onlyOwner returns (uint256) {
        batchSize = _batchSize;
        return batchSize;
    }
}