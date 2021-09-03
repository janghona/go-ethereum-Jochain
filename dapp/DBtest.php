<?php 
$conn = mysqli_connect('127.0.0.1','root','bitnami', 'jochain');
$sql = "SELECT * FROM customer";
mysqli_query($conn,$sql);
$query = "INSERT INTO customer VALUES ( 5, '박지성', '영국 맨체스터', '000-5000-0001')";
$result = mysqli_query($conn,$query);

mysqli_close($conn);
?>