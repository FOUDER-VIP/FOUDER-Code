// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Initializable.sol';

abstract contract DataBase is Initializable {
    //base param setting
    //Update to define constants
    uint constant internal USDTWei = 10 ** 6;
    uint constant internal ETTWei = 10 ** 18;
    uint constant internal USDT_ETTWei_Ratio = 10 ** 12;

    //paramsMapping
    mapping(uint => uint) internal paramsMapping;

    //struct List
	struct User {
		uint id;
        uint loanUSDT;
        uint loanUSDTAddup;
        uint loanETTAddup;  
        uint directAchievement;
        uint directAchievementAddup;

        uint directAwardAddup;

        uint investUniv2;  
        uint investUniv2Addup;

        uint digOreAmountAddup; 
        uint NFT_digOreAmountAddup; 
        uint globalAwardAddup;  


        uint32 loanRecordIndex;//loan  Record Index
        mapping(uint32 => LoanData) loanRecord;//loan  Record data

        uint32 digOreRecordIndex;//dig ore Record Index
        mapping(uint32 => DigOreData) digOreRecord;//dig ore Record data

        uint32 directAwardIndex;//direct Award  Record Index
        mapping(uint32 => DirectAwardData) directAwardRecord;//direct Award Record data

        uint32 globalAwardIndex;//global Award  Record Index
        mapping(uint32 => GlobalAwardData) globalAwardRecord;//global Award  Record data
        
        mapping(uint32 => uint8) dayLoanCount;
        mapping(address => uint) directAwardFromUserCount;
	}

    struct LoanData {
        uint32 id;
        uint32 inRunDays;//in Run Days
        uint40 time;//time
        uint usdtAmount;//pay amount
        uint ettAmount;//exchange amount
        uint8 status;//0:normal,1:settle,2:cash,3:repaided
	}

    struct DigOreData{
        uint32 id;
        uint32 inRunDays;//in Run Days
        uint40 time;//time
        uint uinv2Amount;//pay amount
        uint ettAmount;//exchange amount
        uint ettAmountAddup;//exchange amount addup
        uint NFT_ettAmount;//NFT exchange amount
        uint NFT_ettAmountAddup;//NFT exchange amount addup
        uint8 status;//0:normal,1:cancel
    }

    struct DirectAwardData {
        uint40 time;//time
        uint amount;//award amount
        address fromUser;
	}

    struct GlobalAwardData {
        uint40 time;//time
        uint amount;//award amount
        uint8 ranking;//ranking
	}

    struct LoanDayInfo{
        uint persent;
        uint ettAmount;
        uint ettPoolBalance;
        uint loanUSDTAmount;
    }

    struct LoanInfoInDay{
        uint32 index;
        uint32 id;
        uint40 time;
        uint usdtAmount;
        uint ettAmount;
        uint8 state;
        address addr;
    }


    //Mapping list
    //address User Mapping
	mapping(address => User) internal userMapping;

    mapping(uint32 => uint32) internal LoanInfoInDayIndex;
    mapping(uint32 =>  mapping(uint32 => LoanInfoInDay)) internal LoanInfoInDayMapping;

    uint32 internal tempLastDay;
    mapping(uint32 => LoanDayInfo) internal LastLoanDayMapping;


    struct DigOreDayInfo{
        uint persent;
        uint ettAmount;
        uint ettPoolBalance;
        uint uinv2Amount;
        uint NFT_persent;
        uint NFT_ettAmount;
        uint NFT_ettPoolBalance;
    }
    uint32 internal tempDigOreLastDay;//__DataBase_init
    mapping(uint32 => DigOreDayInfo) internal LastDigOreDayMapping;


    struct GlobalRanking{
        address addr;
        uint dir;
        uint dirs;
        uint loan;
        uint loans;//tokneBalance = ITokenERC20(_taddr).balanceOf(address(this));
        uint awards;
    }
    mapping(uint32 => GlobalRanking[30]) internal GlobalRankingDayMapping;//
    mapping(uint32 => bool) internal IsSettleGlobleAwardInDay;//
    mapping(uint32 => uint) internal GlobleAwardAmountInDay;//



    //ERC Token addr
    address internal USDTToken;//USDT contract

    //ERC20 Token addr
    address internal UniswapPairToken;//uniswap pair contract
    
    //ERC777 Token addr
    address internal ERC777Token1Addr;
    address internal ERC777Token2Addr;

    //ERC1155 Token addr
    address internal NFT1155Token;//NFT1155 contract

    uint internal InvestUSDT;
    uint internal AddupInvestUSDT;
    uint internal LoanOutETTAddup;
    uint internal BurnETTAddup;

    uint internal GlobalTotalRewardPool; 
    uint internal SendGlobalRewardAddup;

    uint internal InvestUniv2Addup;
    uint internal InvestUniv2;

    uint internal LoanETTPoolBalance;
    uint internal DigOreETTPoolBalance;
    uint internal DigOreETTAddup;
    uint internal NFT_DigOreETTPoolBalance;
    uint internal NFT_DigOreETTAddup;

    //init  constant param
    //__DataBase_init 
    uint internal LoanTimeSplit;//
    uint32 internal DigOrePeriods;  
    uint internal DigOreTimeSplit;//


    /**
     * @dev Sets the values for {constant param}, initializes
     *
     * To select a different value for {val}, use {fun_set_val}.
     *
     * All of these values are immutable: they can only be set once during
     * construction.
     */
    function __DataBase_init() internal initializer {
        tempLastDay = 1;
        tempDigOreLastDay = 1;

        //init  constant param
        //__DataBase_init
        LoanTimeSplit = 1 days;
        DigOrePeriods = 15;        
        DigOreTimeSplit = 1 days;
    }
}