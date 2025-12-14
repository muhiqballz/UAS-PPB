<?php
$host = "localhost";
$user = "root";
$pass = "";
$db 	= "studymate";

$connect = mysqli_connect($host, $user, $pass, $db);

if (!$connect) {
	echo json_encode([
		"success" => false, 
		"message" => "Gagal terhubung ke database: " . mysqli_connect_error()
	]);
	exit();
}
?>