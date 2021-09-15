pragma solidity >=0.4.22 < 0.7.0;

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

    myStruct[] public posts;

    function addPost(string memory _UserName, string memory _UserPW, string memory _Title, string memory _maintext) public{
        total++;
        posts.push(myStruct(total, _UserName, _UserPW, _Title, _maintext, block.timestamp));
        emit post(total, _UserName, _UserPW, _Title, _maintext, block.timestamp);
    }

        function getPost(uint _idx) public view returns (uint, string memory, string memory, string memory, uint){
        return (posts[_idx].Num, posts[_idx].UserName, posts[_idx].Title, posts[_idx].maintext, posts[_idx].timestamp);
    }

        function getTotal() public view returns (uint){
        return total;
    }

}