// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Initializable.sol';

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Initializable {
    address private _owner;

    event OwnerTransferred(address indexed previousOwner, address indexed newOwner);

	// /**
	//  * @dev Initializes the contract setting the deployer as the initial owner.
	//  */
    // constructor () internal {
    //     _owner = msg.sender;
    //     emit OwnerTransferred(address(0), _owner);
    // }

    /**
     * @dev Sets the values for {_owner}, initializes
     */
    function __Ownable_init()
        internal
        initializer()
    {
        _owner = msg.sender;
        emit OwnerTransferred(address(0), _owner);
    }

    /**
     * @dev modifier Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: it is not called by the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     * @return bool
     */
    function isOwner()
        internal
        view
        returns(bool)
    {
        return msg.sender == _owner;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner)
        public
        onlyOwner
    {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnerTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner()
        public
        view
        returns(address)
    {
        return _owner;
    }
}