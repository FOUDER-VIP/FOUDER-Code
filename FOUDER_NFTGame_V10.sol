// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Initializable.sol';
import './SafeMath.sol';
import './Address.sol';
import './Whitelist.sol';
import './DataBase_NFT.sol';
import './IToken.sol';
import './IERC1155_MixedFungible.sol';
import './ERC1155_Holder.sol';

/**
 * @title Utillibrary
 * @dev This integrates the basic functions.
 */
abstract contract Utillibrary is Initializable, Whitelist, DataBase_NFT, ERC1155_Holder {
    //lib using list
	using SafeMath for *;
    using Address for address;

    //Loglist
    event TransferEvent(address indexed _from, address indexed _to, uint _value, uint time);
    event TransferTokenEvent(address indexed _token, address indexed _from, address indexed _to, uint _value, uint time);

    /**
     * @dev Sets the values for {constant param}, initializes
     */
    function __Utillibrary_init()
        internal
        initializer()
    {
        //Initializable
        __Ownable_init();
        __Whitelist_init();
        __DataBase_init();
    }

    /**
     * @dev modifier to scope access to a Contract (uses tx.origin and msg.sender)
     */
	modifier isHuman() {
		require(msg.sender == tx.origin, "humans only");
		_;
	}

    /**
     * @dev check Zero Addr
     */
	modifier checkZeroAddr(address addr) {
		require(addr != address(0), "zero addr");
		_;
	}

    /**
     * @dev check Addr is Contract
     */
	modifier checkIsContract(address addr) {
		require(Address.isContract(addr), "not token addr");
		_;
	}

    /**
     * @dev Transfer ETH to designated user
     * @param _addr user address
     * @param _val transfer-out amount
     */
	function sendToUser(address payable _addr, uint _val)
        internal
        checkZeroAddr(_addr)
    {
		if (_val > 0) {
            _addr.transfer(_val);
		}
	}

    /**
     * @dev Transfer Token to designated user
     * @param _taddr token address
     * @param _addr user address
     * @param _val transfer-out amount
     */
	function sendTokenToUser(address _taddr, address _addr, uint _val)
        internal
        checkZeroAddr(_addr)
        checkIsContract(_taddr)
    {
		if (_val > 0) {
            IToken(_taddr).transfer(_addr, _val);
		}
	}

    /**
     * @dev Gets the amount from the specified user
     * @param _taddr token address
     * @param _addr user address
     * @param _val transfer-get amount
     */
	function getTokenFormUser(address _taddr, address _addr, uint _val)
        internal
        checkZeroAddr(_addr)
        checkIsContract(_taddr)
    {
		if (_val > 0) {
            IToken(_taddr).transferFrom(_addr, address(this), _val);
		}
	}

    /**
     * @dev burn money
     * @param _taddr token address
     * @param _val burn amount
     */
	function burnToken(address _taddr, uint _val)
        internal
        checkIsContract(_taddr)
    {
		if (_val > 0) {
            IToken(_taddr).burn(_val, "");
		}
	}

    /**
     * @dev get NFT Token Access type
     *  type stored at upper 128 bits..
     * @param _nonce ERC1155: All NFT token Type nonce index upper 128 bits..
     */
	function getNFTMaskBaseType(uint _nonce)
        internal
        pure
        returns (uint256)
    {
        // Store the type in the upper 128 bits..
        uint256 _type = (_nonce << 128);

        uint256 TYPE_NF_BIT = 1 << 255;

        // Set a flag if this is an NFT.
        _type = _type | TYPE_NF_BIT;

        return _type;
	}

    /**
     * @dev mint NFT Token from the specified user
     * @param _taddr token address
     * @param _addr user address
     * @param _type ERC1155: type stored at upper 128 bits..
     */
	function mintNFTTokenToUser(address _taddr, address _addr, uint256 _type)
        internal
        checkZeroAddr(_addr)
        checkIsContract(_taddr)
        returns(uint256)
    {
		return IERC1155_MixedFungible(_taddr).mintNonFungible(_type, _addr);
	}

    /**
     * @dev the 1155 Token transfer
     * @param _taddr token address
     * @param _from address
     * @param _to address
     * @param _id transfer-get FT/NFT id
     * @param _val transfer-get amount
     */
	function transferToken1155(address _taddr, address _from, address _to, uint _id, uint _val)
        internal
        checkZeroAddr(_from)
        checkZeroAddr(_to)
        checkIsContract(_taddr)
    {
        if (_val > 0) {
            IERC1155_MixedFungible(_taddr).safeTransferFrom(_from, _to, _id, _val, '');
        }
	}

    /**
     * Check if the ID is NFT
     */
    function isNonFungible(uint256 id) internal pure returns(bool) {
        uint256 TYPE_NF_BIT = 1 << 255;
        return id & TYPE_NF_BIT == TYPE_NF_BIT;
    }

    /**
     * @dev Add all order list
     * and Add owner order list
     * @param _type order type/order status type
     * @param ownerAddr order owner address
     * @param orderID order id
     */
    function _addOrder(uint _type, address ownerAddr, uint orderID) internal {
        //all Order list
        {
            _allOrdersIndex[_type][orderID] = _allOrders[_type].length;
            _allOrders[_type].push(orderID);
        }
        //owner Order list
        _addOrder_owner(_type, ownerAddr, orderID);
    }

        /**
     * @dev Add all order list
     * and Add owner order list
     * @param _type order type/order status type
     * @param ownerAddr order owner address
     * @param orderID order id
     */
    function _addOrder_owner(uint _type, address ownerAddr, uint orderID) internal {
        //owner Order list
        {
            _ownedOrdersIndex[_type][orderID] = _ownedOrders[_type][ownerAddr].length;
            _ownedOrders[_type][ownerAddr].push(orderID);
        }
    }

    /**
     * @dev del all order list
     * and del owner order list
     * @param _type order type/order status type
     * @param ownerAddr order owner address
     * @param orderID order id
     */
    function _delOrder(uint _type, address ownerAddr, uint orderID) internal {
        //all Order list
        {
            //isn't Index 0 Order count
            uint lastOrderIndex = _allOrders[_type].length - 1;
            uint orderIndex = _allOrdersIndex[_type][orderID];

            // When the Order to delete is the last Order, the swap operation is unnecessary.
            uint lastOrderId = _allOrders[_type][lastOrderIndex];

            _allOrders[_type][orderIndex] = lastOrderId; // Move the last Order to the slot of the to-delete Order
            _allOrdersIndex[_type][lastOrderId] = orderIndex; // Update the moved Order's index

            // This also deletes the contents at the last position of the array
            delete _allOrdersIndex[_type][orderID];
            _allOrders[_type].pop();
        }

        //owner Order list
        _delOrder_owner(_type, ownerAddr, orderID);
    }

    /**
     * @dev del all order list
     * and del owner order list
     * @param _type order type/order status type
     * @param ownerAddr order owner address
     * @param orderID order id
     */
    function _delOrder_owner(uint _type, address ownerAddr, uint orderID) internal {
        //owner Order list
        {
            //isn't Index 0 Order count
            uint256 lastOrderIndex = _ownedOrders[_type][ownerAddr].length - 1;
            uint256 orderIndex = _ownedOrdersIndex[_type][orderID];

            // When the Order to delete is the last Order, the swap operation is unnecessary
            uint256 lastOrderId = _ownedOrders[_type][ownerAddr][lastOrderIndex];

            _ownedOrders[_type][ownerAddr][orderIndex] = lastOrderId; // Move the last Order to the slot of the to-delete Order
            _ownedOrdersIndex[_type][lastOrderId] = orderIndex; // Update the moved Order's index

            // This also deletes the contents at the last position of the array
            delete _ownedOrdersIndex[_type][orderID];
            _ownedOrders[_type][ownerAddr].pop();
        }
    }
}


contract FOUDER_NFTGame_V10 is Initializable, Utillibrary {
	using SafeMath for *;

    /**
     * @dev Sets the values for {_USDTAddr}, initializes
     */
    function __Constructor_init(address _USDTAddr)
        public
        initializer()
    {
        //Initializable
        __Utillibrary_init();

        //Constructor Initializable
        USDTToken = _USDTAddr;


        paramsMapping[1001] = 50 * ETTWei;
        paramsMapping[1002] = 10 * ETTWei;
        paramsMapping[1003] = 0 * USDTWei;

        paramsMapping[1101] = 100 * ETTWei;
        paramsMapping[1102] = 10 * ETTWei;
        paramsMapping[1103] = 0 * USDTWei;

        paramsMapping[1201] = 150 * ETTWei;
        paramsMapping[1202] = 30 * ETTWei;
        paramsMapping[1203] = 500 * USDTWei;


        paramsMapping[2001] = 3 * USDTWei;
        paramsMapping[2002] = 500;
        paramsMapping[2003] = 0;
    }

    /**
     * @dev Set token address
     * @param token1 address
     */
	function setETTAddress(address token1)
        external
        onlyIfWhitelisted
    {
        require(token1!=address(0), "invalid address");
		ERC777TokenAddr = token1;
	}

    /**
     * @dev Set token 1155 address
     * @param _NFT1155Addr address
     */
	function setNFTAddress(address _NFT1155Addr)
        external
        onlyIfWhitelisted
    {
        NFT1155Token = _NFT1155Addr;
	}

    /**
     * @dev Set Fund Address
     * @param _FundAddress address
     */
	function setFundAddress(address _FundAddress)
        external
        onlyIfWhitelisted
    {
        FundAddress = _FundAddress;
	}

    /**
     * @dev This contract supports receive
     */
    receive() external payable{ }

    // /**
    //  * @dev This contract does not support receive
    //  */
    // fallback() external { }

    /**
     * @dev Casting NFT
     */
	function castingNFT(uint _step)
        public
        isHuman()
    {
        User storage user = userMapping[msg.sender];

        uint8 step = user.castingNFTStep;

        require(step == _step, "Invalid step");

        uint getamount_NFT = 0;
        uint getamount_ETT = 0;
        uint getamount_USDT = 0;

        if(step == 0 || step == 1 || step == 2){
            //step 1/2/3
            getamount_NFT = paramsMapping[1001 + (100 * step)];
            getamount_ETT = paramsMapping[1002 + (100 * step)];
            getamount_USDT = paramsMapping[1003 + (100 * step)];
        }

        if(getamount_NFT > 0){
            transferToken1155(NFT1155Token, msg.sender, address(this), 1, getamount_NFT);
            castingNFTAddupAmount_NFT += getamount_NFT;
        }
        if(getamount_ETT > 0){
            getTokenFormUser(ERC777TokenAddr, msg.sender, getamount_ETT);
            burnToken(ERC777TokenAddr, getamount_ETT);
            castingNFTAddupAmount_ETT += getamount_ETT;
        }
        if(getamount_USDT > 0){
            getTokenFormUser(USDTToken, msg.sender, getamount_USDT);
            sendTokenToUser(USDTToken, FundAddress, getamount_USDT);
            castingNFTAddupAmount_USDT += getamount_USDT;
        }

        if(step == 2){
            uint256 nft_ID = mintNFTTokenToUser(NFT1155Token, msg.sender, getNFTMaskBaseType(1));
            mintNFTTokenCount++;

            NFTInfo storage nft_Info = mintNFTInfo[nft_ID];
            nft_Info.time = uint40(now);
        }

        if(step >= 2){
            //Next time go to the first step
            user.castingNFTStep = 0;
        } else {
            //Next time go to the next step
            user.castingNFTStep = step + 1;
        }
	}

    /**
     * @dev push Trade Order
     */
	function pushTradeOrder(uint tokenID, uint number, uint price)
        public
        isHuman()
    {
        require(price > 0, "Invalid price");

        uint money = 0;
        //Check if the ID is NFT
        if(isNonFungible(tokenID)){
            //NFT
            require(pushTradeOrderLimit[1][msg.sender] == 0, "NFT push Trade Order Limit");
            pushTradeOrderLimit[1][msg.sender] = 1;
            money = price;
            number = 1;
        } else {
            //FT
            require(pushTradeOrderLimit[0][msg.sender] == 0, "FT push Trade Order Limit");
            pushTradeOrderLimit[0][msg.sender] = 1;
            money = number.mul(price).div(ETTWei);
        }
        require(number > 0, "Invalid number");

        //get Token
        transferToken1155(NFT1155Token, msg.sender, address(this), tokenID, number);

        TradeOrder storage tradeOrder = tradeOrderRecord[tradeOrderRecordIndex];
        tradeOrder.id = tradeOrderRecordIndex;
        tradeOrder.orderType = isNonFungible(tokenID) ? 1 : 0;
        tradeOrder.state = 0;
        tradeOrder.tokenID = tokenID;
        tradeOrder.number = number;
        tradeOrder.price = price;
        tradeOrder.money = money;
        tradeOrder.time_0 = uint40(now);
        tradeOrder.addr_From = msg.sender;
        tradeOrderRecordIndex ++;
        //add Order Index mapped record
        _addOrder(tradeOrder.state, tradeOrder.addr_From, tradeOrder.id);
        _addOrder(1000, tradeOrder.addr_From, tradeOrder.id);
	}

    /**
     * @dev matching Trade Order
     */
	function matchingTradeOrder(uint orderID)
        public
        isHuman()
    {
        TradeOrder storage tradeOrder = tradeOrderRecord[orderID];
        require(tradeOrder.state == 0, "Order status cannot be operated");
        require(tradeOrder.addr_From != msg.sender, "Can't make a deal with yourself");
        //remove Order Index mapped record
        _delOrder(tradeOrder.state, tradeOrder.addr_From, tradeOrder.id);
        //Updete tradeOrder
        tradeOrder.state = 1;
        tradeOrder.time_1 = uint40(now);
        tradeOrder.addr_To = msg.sender;
        //add Order Index mapped record
        _addOrder(tradeOrder.state, tradeOrder.addr_From, tradeOrder.id);
        _addOrder_owner(tradeOrder.state, tradeOrder.addr_To, tradeOrder.id);

        //get free
        uint free_money_sell = tradeOrder.money.mul(paramsMapping[2002]).div(10000);
        uint free_money_buy =tradeOrder.money.mul(paramsMapping[2003]).div(10000);
        getTokenFormUser(USDTToken, tradeOrder.addr_To, tradeOrder.money + free_money_buy);
        sendTokenToUser(USDTToken, tradeOrder.addr_From, tradeOrder.money.sub(free_money_sell));
        // sendTokenToUser(USDTToken, FundAddress, free_money_sell + free_money_buy);

        //transfer Token to matching addr
        transferToken1155(NFT1155Token, address(this), tradeOrder.addr_To, tradeOrder.tokenID, tradeOrder.number);

        //Check if the ID is NFT
        if(isNonFungible(tradeOrder.tokenID)){
            //NFT
            pushTradeOrderLimit[1][tradeOrder.addr_From] = 0;
        } else {
            //FT
            pushTradeOrderLimit[0][tradeOrder.addr_From] = 0;
        }
	}

    /**
     * @dev rollback Trade Order
     */
	function rollbackTradeOrder(uint orderID)
        public
        isHuman()
    {
        TradeOrder storage tradeOrder = tradeOrderRecord[orderID];
        require(tradeOrder.state == 0, "Order status cannot be operated");
        require(tradeOrder.addr_From == msg.sender, "caller is not the order owner");
        //remove Order Index mapped record
        _delOrder(tradeOrder.state, tradeOrder.addr_From, tradeOrder.id);
        //Updete tradeOrder
        tradeOrder.state = 2;
        tradeOrder.time_2 = uint40(now);
        tradeOrder.addr_To = msg.sender;
        //add Order Index mapped record
        _addOrder(tradeOrder.state, tradeOrder.addr_From, tradeOrder.id);

        //get free
        uint free_money = paramsMapping[2001];
        getTokenFormUser(USDTToken, tradeOrder.addr_From, free_money);
        // sendTokenToUser(USDTToken, FundAddress, free_money);
        //rollback Token
        transferToken1155(NFT1155Token, address(this), tradeOrder.addr_From, tradeOrder.tokenID, tradeOrder.number);

        //Check if the ID is NFT
        if(isNonFungible(tradeOrder.tokenID)){
            //NFT
            pushTradeOrderLimit[1][tradeOrder.addr_From] = 0;
        } else {
            //FT
            pushTradeOrderLimit[0][tradeOrder.addr_From] = 0;
        }
	}

    /**
     * @dev Show contract state view
     * @return  contract  state view
     */
    function stateView()
        public
        view
        returns (uint[20] memory)
    {
        uint[20] memory info;

        info[0] = tradeOrderRecordIndex;
        info[1] = _allOrders[0].length;
        info[2] = _allOrders[1].length;
        info[3] = _allOrders[2].length;

        info[4] = paramsMapping[1001];
        info[5] = paramsMapping[1002];
        info[6] = paramsMapping[1003];
        info[7] = paramsMapping[1101];
        info[8] = paramsMapping[1102];
        info[9] = paramsMapping[1103];
        info[10] = paramsMapping[1201];
        info[11] = paramsMapping[1202];
        info[12] = paramsMapping[1203];

        info[13] = paramsMapping[2001];
        info[14] = paramsMapping[2002];
        info[15] = paramsMapping[2003];

        info[16] = mintNFTTokenCount;
        info[17] = castingNFTAddupAmount_NFT;
        info[18] = castingNFTAddupAmount_ETT;
        info[19] = castingNFTAddupAmount_USDT;

        return (info);
	}

    /**
     * @dev get the user info based
     * @param addr user addressrd
     * @return  user info
     */
	function userView(address addr)
        public
        view
        returns (uint[10] memory)
    {
        uint[10] memory info;

		info[0] = _ownedOrders[0][addr].length;
        info[1] = _ownedOrders[1][addr].length;
        info[2] = _ownedOrders[2][addr].length;
        info[3] = _ownedOrders[1000][addr].length;
        info[4] = pushTradeOrderLimit[0][addr];
        info[5] = pushTradeOrderLimit[1][addr];

        User memory user = userMapping[msg.sender];
        info[6] = user.castingNFTStep;
        
		return (info);
	}

    /**
     * @dev get the order info based ID
     * @param orderID order ID
     * @return  order info
     */
	function getTradeOrderByID(uint orderID)
        public
        view
        returns (uint[10] memory, address, address)
    {
        uint[10] memory info;
        address addr_From;
        address addr_To;

        TradeOrder memory tradeOrder = tradeOrderRecord[orderID];

		info[0] = tradeOrder.id;
        info[1] = tradeOrder.orderType;
        info[2] = tradeOrder.state;
        info[3] = tradeOrder.tokenID;
        info[4] = tradeOrder.number;
        info[5] = tradeOrder.price;
        info[6] = tradeOrder.money;
        info[7] = tradeOrder.time_0;
        info[8] = tradeOrder.time_1;
        info[9] = tradeOrder.time_2;

        addr_From = tradeOrder.addr_From;
        addr_To = tradeOrder.addr_To;

		return (info, addr_From, addr_To);
	}

    /**
     * @dev get the order info based ID
     * @param _type type status
     * @param index type index
     * @return  order info
     */
	function getTradeOrderByTypeIndex(uint _type, uint index)
        public
        view
        returns (uint[10] memory, address, address)
    {
        require(index < _allOrders[_type].length, "global index out of bounds");
        uint orderID = _allOrders[_type][index];
		return getTradeOrderByID(orderID);
	}

    /**
     * @dev get the order info based ID
     * @param ownerAddr owner addr
     * @param _type type status
     * @param index type index
     * @return  order info
     */
	function getTradeOrderByTypeIndex_owner(address ownerAddr, uint _type, uint index)
        public
        view
        returns (uint[10] memory, address, address)
    {
        require(ownerAddr != address(0), "owner is zero address");
        require(index < _ownedOrders[_type][ownerAddr].length, "owner index out of bounds");
        uint orderID = _ownedOrders[_type][ownerAddr][index];
		return getTradeOrderByID(orderID);
	}
}