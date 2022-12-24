// Event management project ...



// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 < 0.9.0;


contract Event_management{

// Event structure
    struct Event{                             
        address payable organizer;
        string name;
        uint date;
        uint price ;
        uint ticketconut;
        uint ticketRemain;
        
    }
    
    mapping (uint=>Event) public events;                    // mapping for events created
    mapping(address=>mapping(uint=>uint))  public  tickets; // mapping for tickets(it holds quantity of tickets for given id and adress as a key)
    uint public nextId;                                     // id for event



// function to create event  

    function creatEvent(string memory name,uint date,uint price,uint ticketcount) external {
        require(date>block.timestamp,"You can organize your date( for event) for future ");  
        require(ticketcount>0,"To create an event ticketcount must be grater than 0");
        
        events[nextId]=Event(payable(msg.sender),name,date,price,ticketcount,ticketcount);
        nextId++;

    }
    

    // function to buy tickits as well as holding ether 

    function BuyTicket(uint id,uint quantity) external payable returns(address) {
        uint remaining; 
        address  buyer=msg.sender;                               // remaining ether(will be refunded) 
       require(events[id].date!=0,"This events dose not exist"); 
       require(events[id].date>block.timestamp,"This evet already occoured");
     
      Event storage _event =events[id];
    
      require(msg.value>=(_event.price*quantity),"Ether is not enough");
      require(_event.ticketRemain>=quantity,"Not enough tickets of this event");
   
       _event.ticketconut-=quantity;
       tickets[msg.sender][id]+=quantity;

   if(msg.value>(_event.price*quantity)){
     remaining=msg.value-_event.price*quantity;
     payable (msg.sender).transfer(remaining);

      (_event.organizer).transfer(_event.price*quantity);
   }
   return  buyer;
   }
   

   // funciton to transfer tickits form one account to another 

    function transferTickits(uint id,uint quantity,address  payable to) external {
         require(events[id].date!=0,"This events dose not exist"); 
         require(events[id].date>block.timestamp,"This evet already occoured");
         require(tickets[msg.sender][id]>=quantity,"You do not have enough tickits");
   
         tickets[msg.sender][id]-=quantity;
          tickets[to][id]+=quantity;



    }

}