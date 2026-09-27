// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}
contract DutchAuction {
    uint256 public constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint256 public immutable tokenId;

    address payable public immutable seller;
    uint256 public immutable startingPrice;
    uint256 public immutable startAt;
    uint256 public immutable expireAt;
    uint256 public immutable discountRate;

    constructor(
        address _nft,
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _discountRate
    ) {
        require(_startingPrice >= _discountRate * DURATION, "Starting price < discount");

        nft = IERC721(_nft);
        tokenId = _tokenId;
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expireAt = block.timestamp + DURATION;
    }

    function getPrice() public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

}
