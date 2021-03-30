// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Initializable.sol';
import './Whitelist.sol';
import './IDB.sol';

/**
 * @title DBUtilli
 * @dev This Provide database support services (db)
 */
abstract contract DBUtilli is Initializable, Whitelist {

    //include other contract
    IDB private db;

    // /**
    //  * @dev DBUtilli is Beginning
    //  * @param _dbAddr db contract addr
    //  */
    // constructor(address _dbAddr)
    //     public
    // {
    //     db = IDB(_dbAddr);
    // }

    /**
     * @dev Sets the values for {_dbAddr}, initializes
     */
    function __DBUtilli_init(address _dbAddr)
        internal
        initializer()
    {
        db = IDB(_dbAddr);
    }

    /**
     * @dev modifier check Permission
     */
	modifier _checkPermission() {
		require(checkWhitelist(), "DBUtilli: Permission denied");
		_;
	}

    /**
     * @dev modifier check User Permission
     * @param addr user addr
     */
	modifier _checkUserPermission(address addr) {
		checkUserPermission(addr);
		_;
	}

    /**
     * @dev check User Permission
     * @param addr user addr
     */
    function checkUserPermission(address addr)
        private
        view
    {
        require(checkWhitelist() || msg.sender == addr, "DBUtilli: Permission denied for view user's privacy");
	}

    /**
     * @dev Create store user information (db)
     * @param addr user address
     * @param code user invite Code
     * @param rCode recommend code
     */
    function _registerUser(address addr, address code, address rCode)
        internal
    {
        db.registerUser(addr, code, rCode);
	}

    /**
     * @dev determine if user invite code is use (db)
     * @param code user invite Code
     * @return  bool
     */
    function _isUsedCode(address code)
        internal
        view
        returns (bool)
    {
        bool isUser = db.isUsedCode(code);
		return isUser;
	}


    /**
     * @dev get the user address of the corresponding user id (db)
     * Authorization Required
     * @param uid user id
     * @return  address
     */
    function _getIndexMapping(uint uid)
        internal
        view
        returns (address)
    {
        address addr = db.getIndexMapping(uid);
		return addr;
	}

    /**
     * @dev get the user address of the corresponding User info (db)
     * Authorization Required or addr is owner
     * @param addr user address
     * @return  info[id,status,level,levelStatus]
     * @return  code
     * @return  rCode
     */
    function _getUserInfo(address addr)
        internal
        view
        returns (uint[1] memory, address, address)
    {
        (uint[1] memory info,address code,address rCode) = db.getUserInfo(addr);
		return (info, code, rCode);
	}

    /**
     * @dev get the current latest ID (db)
     * Authorization Required
     * @return  current uid
     */
    function _getCurrentUserID()
        internal
        view
        returns (uint)
    {
        uint uid = db.getCurrentUserID();
		return uid;
	}

    /**
     * @dev get the rCodeMapping array length of the corresponding recommend Code (db)
     * Authorization Required
     * @param rCode recommend Code
     * @return  rCodeMapping array length
     */
    function _getRCodeMappingLength(address rCode)
        internal
        view
        returns (uint)
    {
        uint length = db.getRCodeMappingLength(rCode);
		return length;
	}

    /**
     * @dev get the user invite code of the recommend Code [rCodeMapping] based on the index (db)
     * Authorization Required
     * @param rCode recommend Code
     * @param index the index of [rCodeMapping]
     * @return  user invite code
     */
    function _getRCodeMapping(address rCode, uint index)
        internal
        view
        returns (address)
    {
        address code = db.getRCodeMapping(rCode, index);
		return code;
	}

    /**
     * @dev get the user offspring
     * Authorization Required
     * @param rCode recommend Code
     */
    function _getRCodeOffspring(address rCode)
        internal
        view
        returns (address[] memory)
    {
        address[] memory offspring_CodeArr = db.getRCodeOffspring(rCode);
		return offspring_CodeArr;
	}

    /**
     * @dev determine if user invite code is use (db)
     * @param code user invite Code
     * @return  bool
     */
    function isUsedCode(address code)
        public
        view
        returns (bool)
    {
        bool isUser = _isUsedCode(code);
		return isUser;
	}

    /**
     * @dev get the user address of the corresponding user id (db)
     * Authorization Required
     * @param uid user id
     * @return  address
     */
    function getIndexMapping(uint uid)
        public
        view
        _checkPermission()
        returns (address)
    {
		address addr = _getIndexMapping(uid);
        return addr;
	}

    /**
     * @dev get the user address of the corresponding User info (db)
     * Authorization Required or addr is owner
     * @param addr user address
     * @return  info[id,status,level,levelStatus]
     * @return  code
     * @return  rCode
     */
    function getUserInfo(address addr)
        public
        view
        _checkUserPermission(addr)
        returns (uint[1] memory, address, address)
    {
        (uint[1] memory info, address code, address rCode) = _getUserInfo(addr);
		return (info, code, rCode);
	}

    /**
     * @dev get the rCodeMapping array length of the corresponding recommend Code (db)
     * Authorization Required
     * @param rCode recommend Code
     * @return rCodeMapping array length
     */
    function getRCodeMappingLength(address rCode)
        public
        view
        _checkPermission()
        returns (uint)
    {
		return _getRCodeMappingLength(rCode);
	}
}
