typeof web3 !== "undefined"
  ? (web3 = new Web3(web3.currentProvider))
  : (web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")));

if (web3.isConnected()) {
  console.log("connected");
} else {
  console.log("not connected");
  exit;
}

const contractAddress = "0x70781D7B3e5E512894E6CEdaf9D739E757daaFd9";
const smartContract = web3.eth.contract(abi).at(contractAddress);
const num = 0;

function init() {
    // 첫번째 계정으로 주소 설정
    $("#account").val(web3.eth.accounts[0]);
    moment.locale();
  }


  function addPost()
  {
      smartContract.addPost(
        $("#subject").val(),
        $("#name").val(),
        $("#password").val(),
        $("#content").val(),
          { from: $("#account").val(), gas: 3000000 },
          (err, result) => {
            if (!err) alert("트랜잭션이 성공적으로 전송되었습니다.\n" + result);
          }
      );

     num = smartContract.getTotal();
  }


  function ShowContent(){

    //  const post = await smartContract.getPost($("#num").val());
    // const post = await smartContract.getPost(0);
    // const toString = await post.toString();
    // const strArray = toString.split(",");
  
    // const time = strArray[4] * 1000;
    // $("#name").val(strArray[1]);
    // $("#subject").val(strArray[2]);
    // $("#content").val(strArray[3]);
  
   }

  $(function() {
    init();
  });
  