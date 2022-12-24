// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Crowdfunding{
     
     // contributer( variable ) hold how much amount is donated by respective account;
     //address-->ether(uint);
    mapping(address=> uint) public contributers; 
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public NoOfContributers;


    constructor(uint _target,uint _deadline){  // deadline in function argument is not in the form of date 
                                              //(it is in the form of time(sec) . i.e we have to gather 100 lakhs in 1hr(3600sec ).)
    target=_target;
    deadline=block.timestamp+_deadline;// current day + deadline= deadline day(it is in the form of day)
    minimumContribution=100 wei;       
    manager=msg.sender;
                                            }
    
    // struct  for request by manager to contributers (to witdraw money form smart contract) ; 
    struct Request{
        string discription;
        address payable recipient;
        uint value;
        bool complited;
        uint noOfvoters;
        mapping(address=>bool) voter;
    }


    // mapping to hold multiple request  by manager.
    mapping(uint=>Request) requests; 
    uint public numrequest;
  
    


// this function will store the ether donated by contributers.

 function sendEth() public payable{ 
     require(block.timestamp<deadline,"deadline has passed");
     require(msg.value>=minimumContribution,"Minimum donation must be 100 wei");
 
 // as bydefault value of uint is 0 in solidity 
 //, so if contributer variable holds 0 value then he is new contributer;
 if (contributers[msg.sender]==0) {
     NoOfContributers++;
 }            
 contributers[msg.sender]+=msg.value;
 raisedAmount+=msg.value; //  raisedAmount+=msg.value; is   raisedAmount= raisedAmount+msg.value;

 } 
 function getContractBalance() public view returns(uint){
     return address(this).balance;
 }

 // contributers can request for refund form this function 
function refund() public {
    require(block.timestamp >deadline && raisedAmount< target,"You can not witdraw your money at this time");
    require(contributers[msg.sender]>0);

    // refunding amount to the contributer.
    address payable user=payable (msg.sender);
    user.transfer(contributers[msg.sender]);
    contributers[msg.sender]=0;

}
modifier  onlyManager(){
    require(msg.sender==manager,"only manager can access this funciton ");
    _;

}
function createRequest(string memory _discription, address payable _recipient,uint _value) public onlyManager(){
   
    // both newrequest and requests[numrequest] pointing toward same memory loaction
     // it whatever change in one will reflect in other 

    Request storage newrequest=requests[numrequest];
    numrequest++;
    newrequest.discription=_discription;
    newrequest.recipient=_recipient;
    newrequest.value=_value;
    newrequest.complited=false;
    newrequest.noOfvoters=0;
}

//function to take votes form contributers.
 function voterequest(uint  requestNO) public {

 require(contributers[msg.sender]>0,"You must be a contributer");
 //again thisrequest and request[requestNO] poining to same memory location.
 // it whatever change in one will reflect in other 

 Request storage thisrequest=requests[requestNO];
 
 //bydefault value of bool is "false"
 require(thisrequest.voter[msg.sender]==false,"you have already voted");
 thisrequest.voter[msg.sender]=true;
 thisrequest.noOfvoters++;
}

function makePayments(uint _requestNo) public{
    require(raisedAmount>=target,"Target is not met");
    Request storage thisrequest=requests[_requestNo];
    require(thisrequest.complited==false,"this request is completed");
    //no of voters should be grater than half of contributers
    require(thisrequest.noOfvoters>NoOfContributers/2,"Mejority dose not supported");
thisrequest.recipient.transfer(thisrequest.value);
thisrequest.complited=true;
}



 

}
