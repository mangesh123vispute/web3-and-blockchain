// lottery project
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Lottrey{
    address public  manager;   // stores managers adders
    address payable[] public participents; // array which stores addr many participents
address payable public winner ;
// uint public woned_money;
 constructor(){
     manager=msg.sender; //global variabel

}

 receive() external payable {
     require(msg.value==1 ether);
     participents.push(payable(msg.sender));

   }
   function getbalance() public view returns(uint){
       require(msg.sender==manager);
       return address(this).balance;
       }
   //function to select participents randomly
   
   function random() public view returns(uint){
      return  uint (keccak256(abi.encodePacked(block.difficulty,block.timestamp,participents.length)));
   }
   
    // function to select winner randomly
  function selectWinner() public   {
  require(msg.sender==manager,"only manager can select winner");
    require(participents.length>=3);
    
    uint index=random()%participents.length; //any value(of any length)%a=remainder always < a

     winner=participents[index];
   
    winner.transfer(address(this).balance);
    participents=new address payable[](0);

} 


} 