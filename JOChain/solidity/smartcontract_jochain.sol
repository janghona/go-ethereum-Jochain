// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Schnorr.sol";

contract PostContract{
    uint total;
    struct myStruct{
        uint Num;
        string UserName;
        string UserPW;
        string Title;
        string maintext;
        uint timestamp;
    }

    event post(
        uint Num,
        string UserName,
        string UserPW,
        string Title,
        string maintext,
        uint timestamp
    );

        uint256 pubkey1;
        uint256 pubkey2;
        uint256 out_s;
        uint256 out_e;
    
  
    myStruct[] public posts;


function verify() public returns (bool){
        //schnorr
uint256 secret = 19977808579986318922850133509558564821349392755821541651519240729619349670944;
uint256 message = 19996069338995852671689530047675557654938145690856663988250996769054266469975;
(pubkey1,pubkey2,out_s,out_e) = Schnorr.CreateProof(secret, message);

return Schnorr.VerifyProof(pubkey1, pubkey2, message, out_s, out_e);
}

    function addPost(string memory _UserName, string memory _UserPW, string memory _Title, string memory _maintext) public{
        total++;
        posts.push(myStruct(total, _UserName, _UserPW, _Title, _maintext, block.timestamp));
        require(verify()== true);
        emit post(total, _UserName, _UserPW, _Title, _maintext, block.timestamp);
    }

        function getPost(uint _idx) public view returns (uint, string memory, string memory, string memory, uint){
        return (posts[_idx].Num, posts[_idx].UserName, posts[_idx].Title, posts[_idx].maintext, posts[_idx].timestamp);
    }

        function getTotal() public view returns (uint){
        return total;
    }

}