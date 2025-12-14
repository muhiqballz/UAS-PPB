<?php
include 'koneksi.php';

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = mysqli_query($connect, $sql);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $user_id = $row['id'];
    $role = $row['role'];
    
    $userData = [
        'id' => $user_id,
        'username' => $row['username'],
        'role' => $role,
    ];

    if ($role == 'mahasiswa') {
        $sqlMhs = "SELECT * FROM mahasiswa WHERE user_id = '$user_id'";
        $resMhs = mysqli_query($connect, $sqlMhs);
        if ($mhs = mysqli_fetch_assoc($resMhs)) {
            $userData['nama_lengkap'] = $mhs['nama_lengkap'];
            $userData['nim'] = $mhs['nim'];
            $userData['foto_profil'] = $mhs['foto_profil'];
        }
    }
    else if ($role == 'dosen') {
        $sqlDosen = "SELECT * FROM dosen WHERE user_id = '$user_id'";
        $resDosen = mysqli_query($connect, $sqlDosen);
        if ($dsn = mysqli_fetch_assoc($resDosen)) {
            $userData['nama_lengkap'] = $dsn['nama_lengkap'];
            $userData['nidn'] = $dsn['nidn'];
        }
    }

    echo json_encode([
        'success' => true,
        'message' => 'Login Berhasil',
        'data'    => $userData
    ]);

} else {
    echo json_encode([
        'success' => false,
        'message' => 'NIM atau Password salah!'
    ]);
}
?>