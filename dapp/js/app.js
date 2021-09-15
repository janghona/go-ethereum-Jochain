typeof web3 !== "undefined"
  ? (web3 = new Web3(web3.currentProvider))
  : (web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")));

if (web3.isConnected()) {
  console.log("connected");
} else {
  console.log("not connected");
  exit;
}

const contractAddress = "0x24db68325B91f28945DD73838d2aC8D590F46b64";
const smartContract = web3.eth.contract(abi).at(contractAddress);
var num = 0;

function init() {
    // 첫번째 계정으로 주소 설정
    $("#account").val(web3.eth.accounts[0]);
    moment.locale();
  }

  async function showList() {
     const table = document.getElementById("table1");
     const total = smartContract.getTotal().toString();

    i = $("#num").val()-1;
    num = i;
    alert("showList i" + i + "num" + num);

      const post = await smartContract.getPost(i);
      const toString = await post.toString();
      const strArray = toString.split(",");
  
      const time = strArray[4] * 1000;
      const row = table.insertRow();
      const cell1 = row.insertCell(0);
      const cell2 = row.insertCell(1);
      const cell3 = row.insertCell(2);
     const cell4 = row.insertCell(3);
     const cell5 = row.insertCell(4);
     const cell6 = row.insertCell(5);
      cell1.innerHTML = strArray[0];
      cell2.innerHTML = strArray[1];
      cell3.innerHTML = strArray[2];
     cell4.innerHTML = strArray[3];
     cell6.innerHTML = strArray[4];
     cell5.style.width = "60%";
     cell5.innerHTML = moment(time).format("YYYY-MM-DD hh:mm");
    
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

   async function PrintView(){

    num = smartContract.getTotal();

    const post = await smartContract.getPost(num-1);
     const toString = await post.toString();
    const strArray = toString.split(",");

    const time = strArray[4] * 1000;
    document.getElementById("num").innerText =strArray[0];
    // document.getElementById("name").innerText =strArray[0];
    document.getElementById("name").innerText ="testUser";
    document.getElementById("subject").innerText =strArray[1];
    document.getElementById("account").innerText =web3.eth.accounts[0];
    document.getElementById("date").innerText = moment(time).format("YYYY-MM-DD hh:mm");
    
    document.getElementById("content").innerText =strArray[3];

     alert("printSubject num" + num);
   }


   async function PrintList(){

    num = smartContract.getTotal();


    const post = await smartContract.getPost(num-1);
     const toString = await post.toString();
    const strArray = toString.split(",");

    const time = strArray[4] * 1000;
    document.getElementById("num").innerText =strArray[0];
    // document.getElementById("name").innerText =strArray[0];
    document.getElementById("name").innerText ="testUser";
    document.getElementById("subject").innerText =strArray[1];
    document.getElementById("account").innerText =web3.eth.accounts[0];
    document.getElementById("date").innerText = moment(time).format("YYYY-MM-DD");
    
    document.getElementById("content").innerText =strArray[3];
    
     alert("printSubject num" + num);
   }

  $(function() {
    init();
  });
  