// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Initializable.sol';
import './SafeMath.sol';
import './Address.sol';
import './Whitelist.sol';
import './DBUtilli.sol';
import './DataBase.sol';
import './IToken.sol';
import './IERC1155_MixedFungible.sol';
import './ERC1155_Holder.sol';

/**
 * @title Utillibrary
 * @dev This integrates the basic functions.
 */
abstract contract Utillibrary is Initializable, DBUtilli, DataBase, ERC1155_Holder {
    //lib using list
	using SafeMath for *;
    using Address for address;

    //Loglist
    event TransferEvent(address indexed _from, address indexed _to, uint _value, uint time);
    event TransferTokenEvent(address indexed _token, address indexed _from, address indexed _to, uint _value, uint time);

    /**
     * @dev Sets the values for {_dbAddr}, initializes
     */
    function __Utillibrary_init(address _dbAddr)
        internal
        initializer()
    {
        //Initializable
        __Ownable_init();
        __Whitelist_init();
        __DBUtilli_init(_dbAddr);
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
     * @dev check User ID
     * @param uid user ID
     */
    function checkUserID(uint uid)
        internal
        pure
    {
        require(uid != 0, "user not exist");
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
     * @dev Gets the current day index
     * @return day index
     */
	function getDayIndex()
        internal
        view
        returns (uint)
    {
		return now / 1 days;
	}
}


contract FOUDER_Game_V10 is Initializable, Utillibrary {
	using SafeMath for *;

    event LoanEvent(address indexed operator, address indexed code,address indexed rCode, uint amount, uint time);

    event SettleLoanEvent(address indexed operator, uint index, uint count, uint time);

    event SettleGlobleAwardEvent(address indexed operator,  uint time);

    event DigOreEvent(address indexed operator, uint amount, uint time);

    /**
     * @dev Sets the values for {_dbAddr} and {_USDTAddr}, initializes
     */
    function __Constructor_init(address _dbAddr, address _USDTAddr)
        public
        initializer()
    {
        //Initializable
        __Utillibrary_init(_dbAddr);

        //Constructor Initializable
        USDTToken = _USDTAddr;
         //start Time setting
        paramsMapping[0] = 0;
        paramsMapping[1] = 0;


        paramsMapping[10] = 200;
        paramsMapping[11] = 800;
        paramsMapping[12] = 9000; 

        paramsMapping[20] = 117000*ETTWei;// 130000*0.90=117000
        paramsMapping[21] = 50;
        paramsMapping[22] = 2;
        paramsMapping[23] = 30;
        paramsMapping[24] = 1;
        paramsMapping[25] = 10;


        paramsMapping[30] = 4760*ETTWei;//68000*0.07=4760
        paramsMapping[31] = 30;        
        paramsMapping[32] = 1;        
        paramsMapping[33] = 1;        

        paramsMapping[40] = 230000*ETTWei;// 230000
        paramsMapping[41] = 300;
        paramsMapping[42] = 2;
        paramsMapping[43] = 150;
        paramsMapping[44] = 1;
        paramsMapping[45] = 10;
        paramsMapping[49] = 1;

        paramsMapping[102] = 9000;
        paramsMapping[103] = 1;
        paramsMapping[104] = 500;
        paramsMapping[105] = 300;
        paramsMapping[106] = 200;


        paramsMapping[1000] = 1;
        paramsMapping[1001] = 1*USDTWei;
        paramsMapping[1002] = 200*USDTWei;


        paramsMapping[5001] = 2000;
        paramsMapping[5002] = 7000;
        paramsMapping[5003] = 3000;

        paramsMapping[5100] = 4000;
        paramsMapping[5101] = 2200;
        paramsMapping[5102] = 1300;
        paramsMapping[5103] = 800;
        paramsMapping[5104] = 600;
        paramsMapping[5105] = 400;
        paramsMapping[5106] = 300;
        paramsMapping[5107] = 200;
        paramsMapping[5108] = 100;
        paramsMapping[5109] = 100;

        paramsMapping[5110] = 5000;
        paramsMapping[5111] = 3000;
        paramsMapping[5112] = 1000;
        paramsMapping[5113] = 600;
        paramsMapping[5114] = 400;

        LoanETTPoolBalance = paramsMapping[20];
        DigOreETTPoolBalance = paramsMapping[30];
        NFT_DigOreETTPoolBalance = paramsMapping[40];
    }

    /**
     * @dev Set token address
     * @param token1 address
     * @param token2 address
     */
	function setETTAddress(address token1,address token2)
        external
        onlyIfWhitelisted
    {
        require(token1!=address(0)&&token2!=address(0), "invalid address");
		ERC777Token1Addr = token1;
        ERC777Token2Addr = token2;
	}

    /**
     * @dev Set token address
     * @param token3 address
     */
	function setSwapAddress(address token3)
        external
        onlyIfWhitelisted
    {
        require(token3!=address(0), "invalid address");
        UniswapPairToken = token3;
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
     * @dev This contract supports receive
     */
    receive() external payable{ }

    // /**
    //  * @dev This contract does not support receive
    //  */
    // fallback() external { }

    /**
     * @dev modifier check loan is Open
     */
	modifier _isLoanOpen() {
		require(isLoanOpen(), "no open");
		_;
	}

    /**
     * @dev modifier check dig ore is Open
     */
	modifier _isMineOpen() {
		require(isMineOpen(), "no open");
		_;
	}

    /**
     * @dev Set loan start time
     * @param time start time
     * @param index is index
     */
	function setStartTime(uint time,uint index)
        external
        onlyIfWhitelisted
    {
        require(index==0||index==1, "invalid index");
		require(paramsMapping[index] == 0 || paramsMapping[index]>now, "had set and opened");
		require(time > now, "invalid time");
		paramsMapping[index] = time;
	}

    /**
     * @dev determine if contract open
     * @return bool
     */
	function isLoanOpen()
        public
        view
        returns (bool)
    {
		return paramsMapping[0] != 0 && now > paramsMapping[0];
	}

    /**
     * @dev determine if contract open
     * @return bool
     */
	function isMineOpen()
        public
        view
        returns (bool)
    {
		return paramsMapping[1] != 0 && now > paramsMapping[1];
	}

    /**
     * @dev Gets the current day index
     * @return _day index
     */
	function getLoanRunDays()
        public
        view
        returns (uint32)
    {
        uint32 _day;
        if(now > paramsMapping[0] && paramsMapping[0] > 0){
            _day = uint32(((now-paramsMapping[0]) / LoanTimeSplit) + 1);
        }
		return _day;
	}

    /**
     * @dev update Global Ranking
     * @param _ranking rank ing
     */
	function updateGlobalRanking(GlobalRanking memory _ranking)
        private
    {

        GlobalRanking[30] memory lastdayRanking = GlobalRankingDayMapping[0];

        for(uint i=0; i<30; i++){
            if(lastdayRanking[i].addr==_ranking.addr){

                for(uint j=i;j<30;j++){
                    if(j==29){
                        lastdayRanking[j].addr = address(0);
                        lastdayRanking[j].dir =0;
                        lastdayRanking[j].dirs = 0;
                        lastdayRanking[j].loan = 0;
                        lastdayRanking[j].loans =0;
                    }
                    else{
                        lastdayRanking[j].addr=lastdayRanking[j+1].addr;
                        lastdayRanking[j].dir=lastdayRanking[j+1].dir;
                        lastdayRanking[j].dirs=lastdayRanking[j+1].dirs;
                        lastdayRanking[j].loan=lastdayRanking[j+1].loan;
                        lastdayRanking[j].loans=lastdayRanking[j+1].loans;
                    }
                }
                break;
            }
        }

        for(uint i=0; i<30; i++){
            bool isRanking1 = _ranking.dir > lastdayRanking[i].dir;
            bool isRanking2 = _ranking.dir == lastdayRanking[i].dir;
            bool isRanking3 = _ranking.dirs > lastdayRanking[i].dirs;
            bool isRanking4 = _ranking.dirs == lastdayRanking[i].dirs;
            bool isRanking5 = _ranking.loan > lastdayRanking[i].loan;
            bool isRanking6 = _ranking.loan == lastdayRanking[i].loan;
            bool isRanking7 = _ranking.loans > lastdayRanking[i].loans;

            bool isRanking=isRanking1||(isRanking2 && isRanking3)
            ||(isRanking2 && isRanking4 && isRanking5)
            ||(isRanking2 && isRanking4 && isRanking6 && isRanking7);
            if(isRanking){
                for(uint j=29;j>i;j--){
                    lastdayRanking[j] = lastdayRanking[j-1];
                }
                lastdayRanking[i] = _ranking;
                break;
            }
        }

        GlobalRanking[30] storage saveRanking = GlobalRankingDayMapping[0];
        for(uint j=0; j<30; j++){
            saveRanking[j].addr=lastdayRanking[j].addr;
            saveRanking[j].dir=lastdayRanking[j].dir;
            saveRanking[j].dirs=lastdayRanking[j].dirs;
            saveRanking[j].loan=lastdayRanking[j].loan;
            saveRanking[j].loans=lastdayRanking[j].loans;
        }
	}

    /**
     * @dev the loan of contract is Beginning
     * @param money USDT amount for loan
     * @param rCode recommend code
     */
	function toLoan(uint money, address rCode)
        public
        isHuman()
        _isLoanOpen()
    {
        address code = msg.sender;

        require(money>=paramsMapping[1001]&&money<=paramsMapping[1002], "invalid loan range");
        uint32 _dayIndx = getLoanRunDays();

        //init userInfo
        uint[1] memory user_data;
        address tempRCode;
        (user_data, ,tempRCode) = _getUserInfo(msg.sender);
        uint user_id = user_data[0];
		if (user_id == 0) {
			_registerUser(msg.sender, code, rCode);
            (user_data, , ) = _getUserInfo(msg.sender);
            user_id = user_data[0];
		} else {
            rCode = tempRCode;
        }

		User storage user = userMapping[msg.sender];
		if (user.id == 0) {
            user.id = user_id;
		}

        require(user.dayLoanCount[_dayIndx] < paramsMapping[1000], "over loan count");

        getTokenFormUser(USDTToken, msg.sender, money);

        if(rCode != address(0)){
            User storage puser = userMapping[rCode];
            puser.directAchievement += money;
            puser.directAchievementAddup += money;

            GlobalRanking memory tmpRanking;
            tmpRanking.dir = puser.directAchievement;
            tmpRanking.dirs = puser.directAchievementAddup;
            tmpRanking.loan = puser.loanUSDT;
            tmpRanking.loans = puser.loanUSDTAddup;
            tmpRanking.addr = rCode;

            updateGlobalRanking(tmpRanking);    
        }
        InvestUSDT += money;
        AddupInvestUSDT += money; 
        user.loanUSDT += money;
        user.loanUSDTAddup += money;

        LoanData storage loanRecord = user.loanRecord[user.loanRecordIndex];
        loanRecord.id = user.loanRecordIndex;
        loanRecord.time = uint40(now);
        loanRecord.usdtAmount = money;
        loanRecord.ettAmount = 0;
        loanRecord.status = 0;
        loanRecord.inRunDays=_dayIndx;
        user.loanRecordIndex ++;
        user.dayLoanCount[_dayIndx]++;
        LoanInfoInDay storage loaninfo=LoanInfoInDayMapping[_dayIndx][LoanInfoInDayIndex[_dayIndx]];
        loaninfo.index = LoanInfoInDayIndex[_dayIndx];
        loaninfo.id = loanRecord.id;
        loaninfo.time = loanRecord.time;
        loaninfo.usdtAmount = loanRecord.usdtAmount;
        loaninfo.addr = code;
        LoanInfoInDayIndex[_dayIndx]++;

        _setLoanETTAmountInDay(_dayIndx,money);

        emit LoanEvent(msg.sender, code, rCode, money, now);
	}

    /**
     * @dev set record in day
     * @param _dayIndx is run day index
     * @param money is Loan usdt money
     */
	function _setLoanETTAmountInDay(uint32 _dayIndx,uint money)
        internal
    {
        uint tempSurplus = paramsMapping[20];
        uint tempPersent = paramsMapping[21];
        if(_dayIndx > tempLastDay){
            LoanDayInfo memory templastloan = LastLoanDayMapping[tempLastDay];
            if(templastloan.ettPoolBalance > 0 && templastloan.persent > 0){
                tempSurplus = templastloan.ettPoolBalance;
                tempPersent = templastloan.persent;
            } 
            tempLastDay = _dayIndx;       
        }

        LoanDayInfo storage _loanDayInfo = LastLoanDayMapping[_dayIndx];
        if(_loanDayInfo.loanUSDTAmount == 0){
            if(_dayIndx > 1){

                tempSurplus = tempSurplus - tempSurplus.mul(tempPersent).div(10000);

                if(tempPersent <= paramsMapping[25]){
                    tempPersent = paramsMapping[25]; 
                }
                else if(tempPersent <= paramsMapping[23]){
                    tempPersent = tempPersent-paramsMapping[24];
                }
                else{
                    tempPersent = tempPersent-paramsMapping[22];
                }
            }

            _loanDayInfo.persent = tempPersent;
            _loanDayInfo.ettAmount = tempSurplus.mul(tempPersent).div(10000);
            _loanDayInfo.ettPoolBalance = tempSurplus;
        }
        _loanDayInfo.loanUSDTAmount += money;
	}

    /**
     * @dev get Loan token for user
     * @param index is Loan day record index
     * @param count is Loan record number
     */
	function settleLoanETTs(uint32 index,uint32 count)
        external
        onlyIfWhitelisted
    {
        uint32 _dayIndx = getLoanRunDays()-1;
        require(_dayIndx > 0,"Invalid day");
        uint32 _length = LoanInfoInDayIndex[_dayIndx];
        require((index + count) <= _length && _length > 0 ,"over count"); 
        LoanDayInfo memory _loanDayInfo = LastLoanDayMapping[_dayIndx];
        if(_loanDayInfo.loanUSDTAmount > 0 && _loanDayInfo.ettAmount > 0){
            for(uint32 i=index;i<(index+count);i++){
                LoanInfoInDay storage loaninfo = LoanInfoInDayMapping[_dayIndx][i];           
                if(loaninfo.state==0){
                    User storage user = userMapping[loaninfo.addr];
                    LoanData storage loanRecord = user.loanRecord[loaninfo.id];
                    if(loanRecord.status == 0){
                        uint loanETTAmountInDay = _loanDayInfo.ettAmount;
                        uint ettAmountTotal = loanETTAmountInDay.mul(loanRecord.usdtAmount).div(_loanDayInfo.loanUSDTAmount);
                        LoanETTPoolBalance -= ettAmountTotal;
                        loanRecord.ettAmount = ettAmountTotal.mul(paramsMapping[12]).div(10000);
                        loanRecord.status = 1;
                        GlobalTotalRewardPool += ettAmountTotal.mul(paramsMapping[11]).div(10000); 
                        LoanOutETTAddup += loanRecord.ettAmount; 
                        loaninfo.state = 1;
                        loaninfo.ettAmount = loanRecord.ettAmount;
                    }                   
                }
            }
            GlobleAwardAmountInDay[_dayIndx] = GlobalTotalRewardPool;
        }
        emit SettleLoanEvent(msg.sender, index, count, now);
	}

    /**
     * @dev get Loan token for user
     * @param index is Loan record index
     * @param _dayIndx is Loan record day index
     */
	function getYestodayLoans(uint32 index , uint32 _dayIndx)
        external
        view
        onlyIfWhitelisted
        returns (uint[6] memory, address)
    {
        uint[6] memory infos;
        address addr;

        uint32 _day = getLoanRunDays();
        if(_dayIndx==0){
            _dayIndx = _day -1;
        }       
        if(_dayIndx > 0 && _dayIndx <= _day){
            uint32 _length = LoanInfoInDayIndex[_dayIndx];
            if(_length > 0 && index < _length){
                LoanDayInfo memory _loanDayInfo = LastLoanDayMapping[_dayIndx];
                if(_loanDayInfo.loanUSDTAmount > 0 && _loanDayInfo.ettAmount > 0){
                    LoanInfoInDay memory loaninfo = LoanInfoInDayMapping[_dayIndx][index];         
                    uint ettAmountTotal = _loanDayInfo.ettAmount.mul(loaninfo.usdtAmount).div(_loanDayInfo.loanUSDTAmount);
                    addr = loaninfo.addr;
                    infos[0]= loaninfo.index;
                    infos[1]= loaninfo.time;
                    infos[2]= loaninfo.usdtAmount;
                    infos[3]= loaninfo.ettAmount>0 ? loaninfo.ettAmount: ettAmountTotal.mul(paramsMapping[12]).div(10000);
                    infos[4]= loaninfo.state;
                }
            }           
        }
        return (infos,addr);
	}

    /**
     * @dev get Loan token for user
     */
	function settleGlobleAward()
        external
        onlyIfWhitelisted
    {
        uint32 _day = getLoanRunDays()-1;
        bool isSettle = IsSettleGlobleAwardInDay[_day];
        if(!isSettle && _day > 0){
            GlobalRanking[30] storage _ranking = GlobalRankingDayMapping[0];
            uint awardAmount = GlobalTotalRewardPool.mul(paramsMapping[5001]).div(10000);
            uint awardAmount1_10 = awardAmount.mul(paramsMapping[5002]).div(10000);
            uint awardAmount11_15 = awardAmount.mul(paramsMapping[5003]).div(10000);
            for(uint i=0;i<15;i++){
                if(_ranking[i].addr !=address(0)&&_ranking[i].dir>0){
                    uint awardMoney;
                    if(i<10){ 
                        awardMoney  = awardAmount1_10.mul(paramsMapping[5100+i]).div(10000);
                    }
                    else{
                        awardMoney = awardAmount11_15.mul(paramsMapping[5100+i]).div(10000);
                    }
                    User storage user = userMapping[_ranking[i].addr]; 
                    GlobalAwardData storage globalAwardRecord = user.globalAwardRecord[user.globalAwardIndex]; 
                    globalAwardRecord.time = uint40(now);
                    globalAwardRecord.amount = awardMoney;
                    globalAwardRecord.ranking=uint8(i+1); 
                    if(awardMoney > 0){
                        sendTokenToUser(ERC777Token1Addr,_ranking[i].addr,awardMoney);  
                        _ranking[i].awards = awardMoney;
                        user.globalAwardAddup += awardMoney;
                        user.globalAwardIndex++;
                        GlobalTotalRewardPool-= awardMoney;
                        SendGlobalRewardAddup += awardMoney;
                    }
                }  
            }
            IsSettleGlobleAwardInDay[_day] = true;
        }
        emit SettleGlobleAwardEvent(msg.sender, now);
	}

    /**
     * @dev get Loan token for user
     * @param _index is Loan record index
     */
	function cashLoanETT(uint32 _index)
        public
        isHuman()
    {
		User storage user = userMapping[msg.sender];
        require(_index < user.loanRecordIndex, "over index");
        LoanData storage loanRecord = user.loanRecord[_index];
        
        require(loanRecord.status == 1 && loanRecord.ettAmount > 0,"Invalid state");       
        loanRecord.status = 2;
        sendTokenToUser(ERC777Token1Addr,msg.sender,loanRecord.ettAmount);  
        user.loanETTAddup += loanRecord.ettAmount; 
        
        address rCode = msg.sender;
        address tempRCode;
        for(uint i=0;i<3;i++){
            tempRCode = rCode;
            (, , rCode) = _getUserInfo(tempRCode);

            if(rCode == address(0)){
                break;
            }
            User storage puser = userMapping[rCode];

            if(puser.loanUSDT == 0){
                continue;
            }


            uint awardMoney;

            if(loanRecord.usdtAmount > puser.loanUSDT){
                awardMoney= puser.loanUSDT.mul(paramsMapping[104 + i]).div(10000);
            }
            else{
                awardMoney= loanRecord.usdtAmount.mul(paramsMapping[104 + i]).div(10000);
            }

            if(awardMoney == 0){
                continue;
            }
            sendTokenToUser(USDTToken, rCode, awardMoney);
            puser.directAwardFromUserCount[msg.sender]++;
            puser.directAwardAddup += awardMoney;

            DirectAwardData storage awardRecord = puser.directAwardRecord[puser.directAwardIndex]; 
            awardRecord.time=uint40(now);
            awardRecord.amount=awardMoney;
            awardRecord.fromUser = msg.sender;
            puser.directAwardIndex++;
        }
	}

    /**
     * @dev return token to contract
     * @param _index is Loan record index
     */
	function returnLoanETT(uint32 _index)
        public
        isHuman()
    {
		User storage user = userMapping[msg.sender];
        require(_index < user.loanRecordIndex, "over index");
        LoanData storage loanRecord = user.loanRecord[_index];
        require(loanRecord.status==2 && loanRecord.usdtAmount > 0 ,"loan Invalid state");

        loanRecord.status = 3;

        getTokenFormUser(ERC777Token1Addr, msg.sender, loanRecord.ettAmount);
        burnToken(ERC777Token1Addr,loanRecord.ettAmount);
        BurnETTAddup += loanRecord.ettAmount;
        InvestUSDT -= loanRecord.usdtAmount;

        uint backAmount = loanRecord.usdtAmount.mul(paramsMapping[102]).div(10000);
        if(backAmount > 0){
            sendTokenToUser(USDTToken, msg.sender,backAmount);
        }
        

        address rCode;
        (, , rCode) = _getUserInfo(msg.sender);

        if(rCode!=address(0)){
            User storage puser = userMapping[rCode];
            puser.directAchievement-=loanRecord.usdtAmount;
        }


        user.loanUSDT-=loanRecord.usdtAmount;
	}

    /**
     * @dev Gets the current day index
     * @return  index
     */
	function getMineRunDays()
        public
        view
        returns (uint32)
    {
        uint32 _day;
		if(now > paramsMapping[1] && paramsMapping[1] > 0){
            _day = uint32(((now-paramsMapping[1]) / DigOreTimeSplit) + 1);
        }
		return _day;
	}


    /**
     * @dev the loan of contract is Beginning
     * @param money USDT amount for loan
     */
	function toDigOre(uint money)
        public
        isHuman()
        _isMineOpen()
    {


        uint univ2Balance= IToken(UniswapPairToken).balanceOf(msg.sender);
        require(univ2Balance>0 && univ2Balance==money && UniswapPairToken!=address(0), "balance no enough or token error");
        uint32 _dayIndx = getMineRunDays();
		User storage user = userMapping[msg.sender];


        getTokenFormUser(UniswapPairToken, msg.sender, money);       
        InvestUniv2Addup += money;
        InvestUniv2 += money;
        user.investUniv2 += money;
        user.investUniv2Addup += money;

        DigOreData storage digOreRecord = user.digOreRecord[user.digOreRecordIndex];
        digOreRecord.id = user.digOreRecordIndex;
        digOreRecord.time = uint40(now);
        digOreRecord.uinv2Amount = money;
        digOreRecord.ettAmount = 0;
        digOreRecord.status = 0;
        digOreRecord.inRunDays=_dayIndx;
        user.digOreRecordIndex ++;

        _setDigOreETTAmountInDay(_dayIndx,money,true); 
                
        emit DigOreEvent(msg.sender, money, now);
	}

    /**
     * @dev set record in day
     * @param _dayIndx is run day index
     * @param money is Loan usdt money
     */
	function _setDigOreETTAmountInDay(uint32 _dayIndx,uint money,bool isAdd)
        internal
    {
        uint tempSurplus = paramsMapping[30];
        uint tempUinv2Amount = 0; 
        uint tempPersent = paramsMapping[31] ;
        //NFT Token
        uint NFT_tempSurplus = paramsMapping[40];
        uint NFT_tempPersent = paramsMapping[41] ; 

        uint startDay = tempDigOreLastDay; 

        if(_dayIndx > tempDigOreLastDay){
            DigOreDayInfo memory tempDigOre = LastDigOreDayMapping[tempDigOreLastDay];
            if(tempDigOre.ettPoolBalance > 0 && tempDigOre.persent > 0){
                tempSurplus = tempDigOre.ettPoolBalance;
                tempPersent = tempDigOre.persent;
                tempUinv2Amount = tempDigOre.uinv2Amount;
            } 
            //NFT Token
            if(tempDigOre.NFT_ettPoolBalance > 0 && tempDigOre.NFT_persent > 0){
                NFT_tempSurplus = tempDigOre.NFT_ettPoolBalance;
                NFT_tempPersent = tempDigOre.NFT_persent;
            } 
            tempDigOreLastDay = _dayIndx;       
        }

        DigOreDayInfo storage _digOreDayInfo = LastDigOreDayMapping[_dayIndx];
        if(_digOreDayInfo.ettAmount == 0){

            for(uint i=startDay;i< _dayIndx;i++){

                if(i > 1){

                    tempSurplus = tempSurplus - (tempSurplus.mul(tempPersent).div(10000)); 
                    if(tempPersent > paramsMapping[32] && tempPersent <= paramsMapping[31]){
                        tempPersent = tempPersent - paramsMapping[32];
                    } else {
                        tempPersent = paramsMapping[33]; 
                    }
                    //NFT Token

                    NFT_tempSurplus = NFT_tempSurplus - (NFT_tempSurplus.mul(NFT_tempPersent).div(10000)); 

                    if(NFT_tempPersent <= paramsMapping[45]){
                        NFT_tempPersent = paramsMapping[45]; 
                    }
                    else if(NFT_tempPersent <= paramsMapping[43]){
                        NFT_tempPersent = NFT_tempPersent-paramsMapping[44];
                    }
                    else{
                        NFT_tempPersent = NFT_tempPersent-paramsMapping[42];
                    }
                }
            }
            _digOreDayInfo.uinv2Amount = tempUinv2Amount;
            _digOreDayInfo.persent = tempPersent;
            _digOreDayInfo.ettAmount = tempSurplus.mul(tempPersent).div(10000);
            _digOreDayInfo.ettPoolBalance = tempSurplus; 
            //NFT Token
            _digOreDayInfo.NFT_persent = NFT_tempPersent;
            _digOreDayInfo.NFT_ettAmount = NFT_tempSurplus.mul(NFT_tempPersent).div(10000);
            _digOreDayInfo.NFT_ettPoolBalance = NFT_tempSurplus; 
        }
        if(isAdd){
            _digOreDayInfo.uinv2Amount += money;
        }
        else{
            _digOreDayInfo.uinv2Amount -= money;
        }

	}

    /**
     * @dev set record in day
     * @param _Index is run day index
     */
	function _getDigOreAmounts(address addr,uint32 _dayIndx, uint32 _Index)
        private
        view
        returns (uint,uint)
    {
        uint amount;
        //NFT Token
        uint NFT_amount;

        User storage user = userMapping[addr];
        require(_Index < user.digOreRecordIndex ,"invalid index");
		DigOreData memory _digOre = user.digOreRecord[_Index];		
        if(_digOre.status == 0 && _dayIndx > _digOre.inRunDays &&_digOre.uinv2Amount>0){
            if(_dayIndx > _digOre.inRunDays + DigOrePeriods){
                _dayIndx = _digOre.inRunDays + DigOrePeriods;
            }
            uint tempUniv2Amount;
            uint tempPercent;
            uint tempBalance;
            //NFT Token
            uint NFT_tempPercent;
            uint NFT_tempBalance;

            for(uint32 i=_digOre.inRunDays;i < _dayIndx; i++){
                DigOreDayInfo memory tempDigOre = LastDigOreDayMapping[i];
                if(tempDigOre.uinv2Amount > 0){

                    if(tempDigOre.ettAmount>0){
                        tempUniv2Amount=tempDigOre.uinv2Amount;
                        tempPercent = tempDigOre.persent;
                        tempBalance = tempDigOre.ettPoolBalance;

                    }
                    //NFT Token
                    if(tempDigOre.NFT_ettAmount>0){
                        NFT_tempPercent = tempDigOre.NFT_persent;
                        NFT_tempBalance = tempDigOre.NFT_ettPoolBalance;

                    }
                }
                else
                {

                    if(i==_digOre.inRunDays){

                        tempDigOre = LastDigOreDayMapping[tempDigOreLastDay];
                        tempUniv2Amount = tempDigOre.uinv2Amount;

                        tempBalance = tempDigOre.ettPoolBalance;
                        //NFT Token
                        NFT_tempBalance = tempDigOre.NFT_ettPoolBalance;

                        for(uint j=1;j <= (i-tempDigOreLastDay); j++){

                            tempBalance = tempBalance - (tempBalance.mul(tempPercent).div(10000)); 

                            if(tempPercent <= paramsMapping[33]){
                                tempPercent = paramsMapping[33]; 
                            }
                            else{
                                tempPercent = tempPercent-paramsMapping[32];
                            }

                            //NFT Token
                            NFT_tempBalance = NFT_tempBalance - (NFT_tempBalance.mul(NFT_tempPercent).div(10000)); 
                            if(NFT_tempPercent <= paramsMapping[45]){
                                NFT_tempPercent = paramsMapping[45]; 
                            }
                            else if(NFT_tempPercent <= paramsMapping[43]){
                                NFT_tempPercent = NFT_tempPercent-paramsMapping[44];
                            }
                            else{
                                NFT_tempPercent = NFT_tempPercent-paramsMapping[42];
                            }
                        }
                    }
                }

                if(i > 1){

                    tempBalance = tempBalance - (tempBalance.mul(tempPercent).div(10000)); 

                    if(tempPercent > paramsMapping[32] && tempPercent <= paramsMapping[31]){
                        tempPercent = tempPercent - paramsMapping[32];
                    } else {
                        tempPercent = paramsMapping[33]; 
                    }
                    //NFT Token
                    NFT_tempBalance = NFT_tempBalance - (NFT_tempBalance.mul(NFT_tempPercent).div(10000)); 

                    if(NFT_tempPercent <= paramsMapping[45]){
                        NFT_tempPercent = paramsMapping[45]; 
                    }
                    else if(NFT_tempPercent <= paramsMapping[43]){
                        NFT_tempPercent = NFT_tempPercent-paramsMapping[44];
                    }
                    else{
                        NFT_tempPercent = NFT_tempPercent-paramsMapping[42];
                    }
                }

                uint ett = tempBalance.mul(tempPercent).div(10000);
                if(tempUniv2Amount > 0 && ett > 0){
                    amount += ett.mul(_digOre.uinv2Amount).div(tempUniv2Amount);
                }

                //NFT Token
                uint NFT_ett = NFT_tempBalance.mul(NFT_tempPercent).div(10000);
                if(tempUniv2Amount > 0 && NFT_ett > 0){
                    NFT_amount += NFT_ett.mul(_digOre.uinv2Amount).div(tempUniv2Amount);
                }
            }
        }
        return (amount, NFT_amount);       
	}

    /**
     * @dev get Loan token for user
     * @param _index is Loan record index
     */
	function cashDigOreETT(uint32 _index)
        public
        isHuman()
    {
        uint32 _dayIndx = getMineRunDays();
		User storage user = userMapping[msg.sender];
        require(_index < user.digOreRecordIndex, "over index");
        DigOreData storage digOreRecord = user.digOreRecord[_index];        
        require(digOreRecord.status == 0 && _dayIndx >= (digOreRecord.inRunDays + DigOrePeriods) ,"Invalid state");
        (uint digOreMoney, uint NFT_digOreMoney) = _getDigOreAmounts(msg.sender, (digOreRecord.inRunDays + DigOrePeriods), _index);
        digOreRecord.inRunDays = _dayIndx; 
        user.digOreAmountAddup += digOreMoney; 
        digOreRecord.ettAmountAddup += digOreMoney;  
        digOreRecord.ettAmount += digOreMoney;  
        sendTokenToUser(ERC777Token2Addr, msg.sender, digOreMoney);  
        DigOreETTPoolBalance -= digOreMoney;  
        DigOreETTAddup += digOreMoney;

        //NFT Token
        user.NFT_digOreAmountAddup += NFT_digOreMoney; 
        digOreRecord.NFT_ettAmountAddup += NFT_digOreMoney;  
        digOreRecord.NFT_ettAmount += NFT_digOreMoney;  

        transferToken1155(NFT1155Token, address(this), msg.sender, paramsMapping[49], NFT_digOreMoney);  
        NFT_DigOreETTPoolBalance -= NFT_digOreMoney;  
        NFT_DigOreETTAddup += NFT_digOreMoney;
	}

    /**
     * @dev return token to contract
     * @param _index is Loan record index
     */
	function returnUinv2ETT(uint32 _index)
        public
        isHuman()
    {
		User storage user = userMapping[msg.sender];
        require(_index < user.digOreRecordIndex, "over index");

        DigOreData storage digOreRecord = user.digOreRecord[_index];
        
        require(digOreRecord.status == 0 ,"Invalid state");

        uint32 _dayIndx = getMineRunDays();
        if(_dayIndx >= (digOreRecord.inRunDays + DigOrePeriods)){
            cashDigOreETT(_index);
        }

        digOreRecord.status = 1;

        sendTokenToUser(UniswapPairToken, msg.sender, digOreRecord.uinv2Amount);

        InvestUniv2 -= digOreRecord.uinv2Amount;
        user.investUniv2 -= digOreRecord.uinv2Amount;

        _setDigOreETTAmountInDay(getMineRunDays(),digOreRecord.uinv2Amount,false);

	}


    /**
     * @dev Show contract state view
     * @return  contract  state view
     */
    function stateView()
        public
        view
        returns (uint[22] memory)
    {
        uint[22] memory info;

        info[0] = _getCurrentUserID();
        info[1] = InvestUSDT;
        info[2] = AddupInvestUSDT;
        info[3] = SendGlobalRewardAddup; 
        info[4] = LoanOutETTAddup;
        info[5] = BurnETTAddup;
        info[6] = InvestUniv2Addup;
        info[7] = InvestUniv2;
        info[8] = LoanETTPoolBalance;
        info[9] = DigOreETTPoolBalance;
        info[10] = paramsMapping[1001];
        info[11] = paramsMapping[1002];
        info[12] = GlobalTotalRewardPool; 
        info[13] = DigOreETTAddup; 
        
        info[14] = paramsMapping[0]; 
        info[15] = paramsMapping[1]; 
        info[16] = getLoanRunDays(); 
        info[17] = getMineRunDays(); 
        info[18] = (paramsMapping[0] + LoanTimeSplit*getLoanRunDays())-now; 
        info[19] = LoanInfoInDayIndex[getLoanRunDays()-1];
        info[20] = NFT_DigOreETTPoolBalance;
        info[21] = NFT_DigOreETTAddup; 

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
        returns (uint[25] memory, address, address)
    {
        uint[25] memory info;
        address code;
        address rCode;

        uint[1] memory user_data;
        (user_data, code, rCode) = _getUserInfo(addr);
		User storage user = userMapping[addr];
		info[0] = user_data[0];
        info[1] = user.loanUSDT;
        info[2] = user.loanUSDTAddup;
        info[3] = user.loanETTAddup;
        info[4] = user.directAchievement;
        info[5] = user.directAchievementAddup;
        info[6] = user.directAwardAddup;
        
        info[8] = user.investUniv2;
        info[9] = user.investUniv2Addup;
        info[10] = user.digOreAmountAddup;
        info[11] = user.loanRecordIndex;
        info[12] = user.digOreRecordIndex;
        info[13] = user.directAwardIndex;
        
        info[15] = user.globalAwardIndex;
        (info[16],info[17])=getDirectCountAndTeamCount(addr);
        info[18] = user.globalAwardAddup;
        info[19] = paramsMapping[1000];
        info[20] = user.dayLoanCount[getLoanRunDays()];
        info[21] = user.NFT_digOreAmountAddup;

		return (info, code, rCode);
	}


    /**
     * @dev get direct count and 20 era team count
     * @param addr user addr
     * @return directCount Count
     */
	function getDirectCountAndTeamCount(address addr)
        private
        view
        returns (uint ,uint )
    {
        uint directCount;
        uint teamCount;
        
        directCount = _getRCodeMappingLength(addr);
        teamCount+= directCount; 
        address[] memory offspring_CodeArr;
        address[] memory offspring_CodeArr_Temp;
        offspring_CodeArr = _getRCodeOffspring(addr);
        for (uint i = 1; i < 20; i++) {
            offspring_CodeArr_Temp = offspring_CodeArr;           
            
            uint offspring_CodeLength = 0;
            for (uint j = 0; j < offspring_CodeArr_Temp.length; j++) {
                offspring_CodeLength += _getRCodeMappingLength(offspring_CodeArr_Temp[j]);
            }
            teamCount += offspring_CodeLength;
            
            offspring_CodeArr = new address[](offspring_CodeLength);
            uint offspring_CodeArrIndex = 0;
            for (uint j = 0; j < offspring_CodeArr_Temp.length; j++) {
                uint l = _getRCodeMappingLength(offspring_CodeArr_Temp[j]);
                for (uint k = 0; k < l; k++) {
                    offspring_CodeArr[offspring_CodeArrIndex] = _getRCodeMapping(offspring_CodeArr_Temp[j], k);
                    offspring_CodeArrIndex ++;
                }
            }
        }
		return (directCount,teamCount);
	}


    /**
     * @dev set record in day
     * @param addr is user address
    * @param _Index is record index
     */
	function getDigOreAmounts(address addr, uint32 _Index)
        public
        view
        returns (uint, uint)
    {
        (uint amount,uint NFT_amount) = _getDigOreAmounts(addr,getMineRunDays(),_Index);
        return (amount, NFT_amount);       
	}

    /**
    * @dev set record in day
    * @param _day is record index
    * @return  Buy Record data
    */
	function getDigOreAmounts(uint32 _day)
        public
        view
        returns (uint)
    {
        uint amount = GlobleAwardAmountInDay[_day];
        return amount;       
	}


    /**
     * @dev get the loan Record Data
     * @param addr user address
     * @param index Buy Record index
     * @return  Buy Record data
     */
	function getLoanRecord(address addr, uint32 index)
        public
        view
        _checkUserPermission(addr)
        returns (uint[6] memory)
    {
        uint[6] memory info;

        User storage user = userMapping[addr];
        LoanData memory tempDatas = user.loanRecord[index];
        info[0] = tempDatas.id;//id is index
        info[1] = tempDatas.inRunDays;//in Run Days
        info[2] = tempDatas.time;//time
        info[3] = tempDatas.usdtAmount;//usdt Amount
        info[4] = tempDatas.ettAmount;//ett Amount
        info[5] = tempDatas.status;//0:normal,1:settle,2:repaided
		return (info);
	}

    /**
     * @dev get the loan info Data in day 
     * @param index dig ore Record index
     * @return  dig ore Record data
     */
	function getLoanDayInfo(uint32 index)
        public
        view
        onlyIfWhitelisted
        returns (uint[4] memory)
    {
        uint[4] memory tempData;

        uint32 _dayIndex = getLoanRunDays();
        if(index<=_dayIndex){
            tempData[0] = LastLoanDayMapping[index].persent;
            tempData[1] = LastLoanDayMapping[index].ettAmount;
            tempData[2] = LastLoanDayMapping[index].ettPoolBalance;
            tempData[3] = LastLoanDayMapping[index].loanUSDTAmount;
        }
		return (tempData);
	}


    /**
     * @dev get the dig ore Record Data
     * @param index dig ore Record index
     * @return  dig ore Record data
     */
	function getDigOreDayInfo(uint32 index)
        public
        view
        onlyIfWhitelisted
        returns (uint[7] memory)
    {
        uint[7] memory tempData;

        uint32 _dayIndex = getMineRunDays();
        if(index <= _dayIndex && index > 0){
            DigOreDayInfo memory tempDigOre = LastDigOreDayMapping[index];

            tempData[0] = tempDigOre.persent;
            tempData[1] = tempDigOre.ettAmount;
            tempData[2] = tempDigOre.ettPoolBalance;
            tempData[3] = tempDigOre.uinv2Amount;
            tempData[4] = tempDigOre.NFT_persent;
            tempData[5] = tempDigOre.NFT_ettAmount;
            tempData[6] = tempDigOre.NFT_ettPoolBalance;

            if(tempData[3]==0){
                tempData = getDigOreDayInfo(index - 1);
            }
        }
		return (tempData);
	}

    /**
     * @dev get the dig ore Record Data
     * @param addr user address
     * @param index dig ore Record index
     * @param ore dig ore Record index
     * @return  dig ore Record data
     */
	function getDigOreRecord(address addr, uint32 index,uint8 ore)
        public
        view
        _checkUserPermission(addr)
        returns (uint[9] memory)
    {
        uint[9] memory info;

        uint32 _dayIndex = getMineRunDays();
        User storage user = userMapping[addr];
        DigOreData memory tempDatas = user.digOreRecord[index];
        uint digOreMoney;
        uint NFT_digOreMoney;
        if(ore==1 && tempDatas.status==0 && tempDatas.inRunDays < _dayIndex){
            (digOreMoney, NFT_digOreMoney) = _getDigOreAmounts(addr, _dayIndex, index);
        }        
        info[0] = tempDatas.id;//id is index
        info[1] = tempDatas.inRunDays;//in Run Days
        info[2] = tempDatas.time;//time
        info[3] = tempDatas.uinv2Amount;//usdt Amount
        info[4] = digOreMoney;//ett Amount
        info[5] = tempDatas.ettAmountAddup;//ett Amount addup
        info[6] = tempDatas.status;//0:normal,1:cancel
        info[7] = _dayIndex >= (tempDatas.inRunDays+DigOrePeriods) ? 1:0;
        info[8] = NFT_digOreMoney;//NFT ett Amount
		return (info);
	}

    /**
     * @dev get the Direct Award Record Data
     * @param addr user address
     * @param index Buy Record index
     * @return  Buy Record data
     */
	function getDirectAwardRecord(address addr, uint32 index)
        public
        view
        _checkUserPermission(addr)
        returns (uint[2] memory, address)
    {
        uint[2] memory info;
        address _from;

        User storage user = userMapping[addr];
        DirectAwardData memory tempDatas = user.directAwardRecord[index];
        info[0] = tempDatas.time;//time
        info[1] = tempDatas.amount;//usdt Amount
        _from = tempDatas.fromUser;
		return (info,_from);
	}

    /**
     * @dev get the Global Award Record Data
     * @param addr user addressrd
     * @param index Buy Record index
     * @return  Buy Record data
     */
	function getGlobalAwardRecord(address addr, uint32 index)
        public
        view
        _checkUserPermission(addr)
        returns (uint[3] memory)
    {
        uint[3] memory info;

        User storage user = userMapping[addr];
        GlobalAwardData memory tempDatas = user.globalAwardRecord[index];
        info[0] = tempDatas.time;//time
        info[1] = tempDatas.amount;
        info[2] = tempDatas.ranking;
		return (info);
	}


    /**
     * @dev get Globle ranking before 15 user
     */
	function getGloleRanking()
        public
        view
        returns(
            address[15] memory,
            uint[5][15] memory,//15 nunber uint[5]
            uint8
        )
    {
        address[15] memory rankings_address;
        uint[5][15] memory rankings_info;
        uint8 state;

        GlobalRanking[] memory rankings = new GlobalRanking[](15);

        uint32 _day = getLoanRunDays()-1;
        state = IsSettleGlobleAwardInDay[_day] ? 1:0;
        if(_day > 0 ){
            uint awardAmount = GlobalTotalRewardPool.mul(paramsMapping[5001]).div(10000);
            uint awardAmount1_10 = awardAmount.mul(paramsMapping[5002]).div(10000);
            uint awardAmount11_15 = awardAmount.mul(paramsMapping[5003]).div(10000);
            GlobalRanking[30] memory _ranking = GlobalRankingDayMapping[0];
            for(uint i=0;i<15;i++){
                rankings[i] = _ranking[i];
                if(_ranking[i].addr !=address(0)&&_ranking[i].dir>0){
                    uint awardMoney;
                    if(i<10){ 
                        awardMoney  = awardAmount1_10.mul(paramsMapping[5100+i]).div(10000);
                    }
                    else{
                        awardMoney = awardAmount11_15.mul(paramsMapping[5100+i]).div(10000);
                    }
                    if(awardMoney > 0){
                        rankings[i].awards = awardMoney;
                    }
                }
            }
        }

        for(uint i=0;i<rankings.length;i++){
            rankings_address[i] = rankings[i].addr;
            rankings_info[i][0] = rankings[i].dir;
            rankings_info[i][1] = rankings[i].dirs;
            rankings_info[i][2] = rankings[i].loan;
            rankings_info[i][3] = rankings[i].loans;
            rankings_info[i][4] = rankings[i].awards;
        }

        return (rankings_address,rankings_info,state);
	}


}