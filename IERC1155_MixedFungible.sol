// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155_MixedFungible {
    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;


/////////////////////////////////////////// MixedFungible interface //////////////////////////////////////////////


        /**
     * Check if the ID is NFT
     */
    function isNonFungible(uint256 id) external pure returns(bool);
    /**
     * Check if the ID is non NFT
     */
    function isFungible(uint256 id) external pure returns(bool);
    /**
     * Check if the ID is NFT
     * And there's no index
     */
    function isNonFungibleBaseType(uint256 id) external pure returns(bool);
    /**
     * Check if the ID is NFT
     * And it has an index
     */
    function isNonFungibleItem(uint256 id) external pure returns(bool);
    /**
     * Gets the type stored at upper 128 bits..
     */
    function getMaskBaseType(uint256 id) external pure returns(uint256);
    /**
     * Gets the NFT/FT index stored at low 128 bits..
     */
    function getMaskIndex(uint256 id) external pure returns(uint256);

    /**
     * Check if the ID is NFT
     * And it has an index
     */
    function ownerOf(uint256 id) external view returns (address);

    /**
     * NFT mint
     */
    function mintNonFungible(uint256 _type, address to) external returns(uint256);
}
