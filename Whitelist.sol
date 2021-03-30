// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Initializable.sol';
import './Ownable.sol';

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an address access to this role
     */
    function add(Role storage _role, address _addr)
        internal
    {
        require(!has(_role, _addr), "Roles: addr already has role");
        _role.bearer[_addr] = true;
    }

    /**
     * @dev remove an address' access to this role
     */
    function remove(Role storage _role, address _addr)
        internal
    {
        require(has(_role, _addr), "Roles: addr do not have role");
        _role.bearer[_addr] = false;
    }

    /**
     * @dev check if an address has this role
     * @return bool
     */
    function has(Role storage _role, address _addr)
        internal
        view
        returns (bool)
    {
        require(_addr != address(0), "Roles: not the zero address");
        return _role.bearer[_addr];
    }
}

/**
 * @title Whitelist
 * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
 * This simplifies the implementation of "user permissions".
 */
abstract contract Whitelist is Initializable, Ownable {
    using Roles for Roles.Role;

    Roles.Role private roles;

    event RoleAdded(address indexed operator);
    event RoleRemoved(address indexed operator);

	// /**
	//  * @dev Initializes the contract setting as the initial roles.
	//  */
    // constructor () internal {
    //     roles = Roles.Role();
    // }

    /**
     * @dev Sets the values for {constant param}, initializes
     *
     * All of these values are immutable: they can only be set once during
     * construction.
     */
    function __Whitelist_init() internal initializer {
        roles = Roles.Role();
    }

    /**
     * @dev Throws if operator is not whitelisted.
     */
    modifier onlyIfWhitelisted() {
        require(checkWhitelist(), "Whitelist: The operator is not whitelisted");
        _;
    }

    /**
     * @dev check current operator is in whitelist
     * @return bool
     */
    function checkWhitelist()
        internal
        view
        returns (bool)
    {
        return isWhitelist(msg.sender);
    }

    /**
     * @dev add an address to the whitelist
     * @param _operator address
     */
    function addAddressToWhitelist(address _operator)
        public
        onlyOwner
    {
        roles.add(_operator);
        emit RoleAdded(_operator);
    }

    /**
     * @dev remove an address from the whitelist
     * @param _operator address
     */
    function removeAddressFromWhitelist(address _operator)
        public
        onlyOwner
    {
        roles.remove(_operator);
        emit RoleRemoved(_operator);
    }

    /**
     * @dev determine if address is in whitelist
     * @param _operator address
     * @return bool
     */
    function isWhitelist(address _operator)
        public
        view
        returns (bool)
    {
        return roles.has(_operator) || isOwner();
    }
}
