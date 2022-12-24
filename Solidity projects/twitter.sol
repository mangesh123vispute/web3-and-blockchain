// program fo twitter

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Twitter{


//Each object within Twitter - a Tweet, Direct Message, User, List, and so on - has a unique ID
// so every tweet has an unique id;
struct Tweet{
uint id;
address author;
uint createdat;
string content;
}


struct Message{
uint id;
address form;
address to;
string content;
uint createdat;
}

// id-->Tweet (every tweet have its own unique id)
mapping(uint=>Tweet)  tweets;

// messages are multiple ,
// so we are using array of messages
mapping(address=>Message[]) internal conversation;

// member followed by address 
mapping(address=>address[]) follower;

// mapping to transfer autority form one persone to other 
mapping(address=>mapping(address=>bool)) internal operators;

//this mapping store tweets ids made by perticular user address
mapping(address=>uint[]) internal tweetsof;


uint nextId;
uint nextmessageId;

//operator[owener_acco][new ownner of account ];
//_from is accout form where tweet is generating

function tweet(address _from,string memory _content) internal {

    require(msg.sender==_from || operators[_from][msg.sender]==true,"You are not authorized");

tweets[nextId]=Tweet(nextId,_from,block.timestamp,_content);
tweetsof[_from].push(nextId);
nextId++;

}
//  operators[_from][msg.sender]==true

// = _from allowed to msg.sender to tween on behalf of _from(2d mapping) 

function _sendMessage(address _from,address _to,string memory _message) internal{
require(_from==msg.sender|| operators[_from][msg.sender]==true,"You are not authorized");

conversation[_from].push(Message(nextmessageId,_from,_to,_message,block.timestamp));
nextmessageId++;

}



function tweet(string memory _content) public {

tweet(msg.sender,_content);

}
// We are authorizing other persone to tweet on behalf of ourself

function tweetform(address _from,string memory _content) public{
    tweet(_from,_content);
}


function _sendMessage(string memory _content,address _to) public{
    _sendMessage(msg.sender,_to,_content);
}


function _sendMessageform(address _from,address _to,string memory _content)public{
    _sendMessage(_from,_to,_content);
}

// function to follow other member

function follow(address _followed) public {

    follower[msg.sender].push(  _followed);
}
// function to give authority of our account to other accout 

// operator[owener_acco][new ownner of account ];

function allow(address _operator)public{
operators[msg.sender][_operator]=true;

}
// function to disallow

function disallow(address _operator) public {

    operators[msg.sender][_operator]=false;
}


function getLatestTweet(uint count) public view returns(Tweet[] memory){
      require(count>0 && count<=nextId,"Not found");
      Tweet[] memory memTweets = new Tweet[](count); //initialize an empty array of size count
      uint j;
      for(uint i=nextId-count;i<nextId;i++){//i=5;i<10;i++
          Tweet storage _tweets=tweets[i];
          memTweets[j]=Tweet(_tweets.id,_tweets.author,_tweets.createdat,_tweets.content);
          j++;
      }
      return memTweets;
  }
  

function getTweetsof(address user,uint count) view public returns(Tweet[] memory){
uint[] storage tweetsId= tweetsof[user];

require(count>0&& count<= tweetsof[user].length,"tweets not found");

Tweet[] memory _tweets=new Tweet[](count);
uint j;

for(uint i=tweetsId.length-count;i<tweetsId.length;i++){

 Tweet storage _tweet=tweets[tweetsId[i]];
 _tweets[j]=Tweet(_tweet.id,_tweet.author,_tweet.createdat,_tweet.content);
 j++;


}
return _tweets;

}







}