// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @title DB interface
 * @dev This Provide database support services interface
 */
interface IDB {
    /**
     * @dev Create store user information
     * @param addr user addr
     * @param code user invite Code
     * @param rCode recommend code
     */
    function registerUser(address addr, address code, address rCode) external;

    /**
     * @dev determine if user invite code is use (db)
     * @param code user invite Code
     * @return bool
     */
    function isUsedCode(address code) external view returns (bool);

    /**
     * @dev get the user address of the corresponding user id (db)
     * Authorization Required
     * @param uid user id
     * @return address
     */
    function getIndexMapping(uint uid) external view returns (address);

    /**
     * @dev get the user address of the corresponding User info (db)
     * Authorization Required or addr is owner
     * @param addr user address
     * @return info info[id,status,level,levelStatus]
     * @return code code
     * @return rCode rCode
     */
    function getUserInfo(address addr) external view returns (uint[1] memory info, address code, address rCode);

    /**
     * @dev get the current latest ID (db)
     * Authorization Required
     * @return current uid
     */
    function getCurrentUserID() external view returns (uint);

    /**
     * @dev get the rCodeMapping array length of the corresponding recommend Code (db)
     * Authorization Required
     * @param rCode recommend Code
     * @return rCodeMapping array length
     */
    function getRCodeMappingLength(address rCode) external view returns (uint);
    /**
     * @dev get the user invite code of the recommend Code [rCodeMapping] based on the index (db)
     * Authorization Required
     * @param rCode recommend Code
     * @param index the index of [rCodeMapping]
     * @return user invite code
     */
    function getRCodeMapping(address rCode, uint index) external view returns (address);
    /**
     * @dev get the user offspring
     * Authorization Required
     * @param rCode recommend Code
     */
    function getRCodeOffspring(address rCode) external view returns (address[] memory);

}