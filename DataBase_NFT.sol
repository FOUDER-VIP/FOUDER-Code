// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Initializable.sol';

abstract contract DataBase_NFT is Initializable {
    //base param setting
    //Update to define constants
    uint constant internal USDTWei = 10 ** 6;
    uint constant internal ETTWei = 10 ** 18;
    uint constant internal USDT_ETTWei_Ratio = 10 ** 12;

    //paramsMapping
    mapping(uint => uint) internal paramsMapping;

    //struct List
	struct User {
        uint8 castingNFTStep;
	}

    //Mapping list
    //address User Mapping
	mapping(address => User) internal userMapping;

    //ERC Token addr
    address internal USDTToken;//USDT contract

    //ERC777 Token addr
    address internal ERC777TokenAddr;

    //ERC1155 Token addr
    address internal NFT1155Token;//NFT1155 contract

    //ERC1155 Fund Address
    address internal FundAddress;

    // Array with all Order ids, used for enumeration
    mapping(uint => uint[]) internal _allOrders;//type=>arrIDS
    // Mapping from Order id to position in the allOrders array
    mapping(uint => mapping(uint => uint)) internal _allOrdersIndex;//type=>oid=>arrIDS_index
    // Mapping from owner to list of owned Order IDs
    mapping(uint => mapping(address => uint[])) internal _ownedOrders;//type=>owner=>arrIDS
    // Mapping from Order ID to index of the owner Orders list
    mapping(uint => mapping(uint => uint)) internal _ownedOrdersIndex;//type=>oid=>arrIDS_index

    struct TradeOrder{
        uint id;
        uint8 orderType;
        uint8 state;
        uint tokenID;
        uint number;
        uint price;
        uint money;
        uint40 time_0;
        uint40 time_1;
        uint40 time_2;
        address addr_From;
        address addr_To;
    }
    uint tradeOrderRecordIndex;//TradeOrder  Record Index
    mapping(uint => TradeOrder) tradeOrderRecord;//TradeOrder  Record data
    //push TradeOrder Limit
    //Limit type => owned => is Limit
    mapping(uint8 => mapping(address => uint8)) pushTradeOrderLimit;

    //castingNFT info
    uint mintNFTTokenCount;
    uint castingNFTAddupAmount_NFT;
    uint castingNFTAddupAmount_ETT;
    uint castingNFTAddupAmount_USDT;


	struct NFTInfo {
        uint40 time;
	}
    //id info Mapping
	mapping(uint256 => NFTInfo) internal mintNFTInfo;

    /**
     * @dev Sets the values for {constant param}, initializes
     *
     * To select a different value for {val}, use {fun_set_val}.
     *
     * All of these values are immutable: they can only be set once during
     * construction.
     */
    function __DataBase_init() internal initializer {
        //init  constant param
        tradeOrderRecordIndex = 1;
    }
}