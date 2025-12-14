<?php
include 'koneksi.php';

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'User ID required']);
    exit;
}

$sqlMhs = "SELECT m.*, u.username FROM mahasiswa m JOIN users u ON m.user_id = u.id WHERE m.user_id = '$user_id'";
$resMhs = mysqli_query($connect, $sqlMhs);
$biodata = mysqli_fetch_assoc($resMhs);

if (!$biodata) {
    echo json_encode(['success' => false, 'message' => 'Data tidak ditemukan']);
    exit;
}
$mhs_id = $biodata['id'];

$sqlPay = "SELECT * FROM pembayaran WHERE id_mahasiswa = '$mhs_id' ORDER BY semester DESC";
$resPay = mysqli_query($connect, $sqlPay);
$registrasi = [];
while($row = mysqli_fetch_assoc($resPay)) {
    $registrasi[] = $row;
}

$sqlKur = "SELECT * FROM mata_kuliah ORDER BY semester_paket ASC, nama_mk ASC";
$resKur = mysqli_query($connect, $sqlKur);
$kurikulum = [];
while($row = mysqli_fetch_assoc($resKur)) {
    $kurikulum[] = $row;
}

$sqlKrs = "SELECT mk.kode_mk, mk.nama_mk, mk.sks, j.hari, j.jam_mulai, j.ruangan, k.status_persetujuan, k.semester_ambil 
           FROM krs k 
           JOIN jadwal_kuliah j ON k.id_jadwal = j.id 
           JOIN mata_kuliah mk ON j.id_mk = mk.id 
           WHERE k.id_mahasiswa = '$mhs_id'
           ORDER BY k.semester_ambil ASC"; 

$resKrs = mysqli_query($connect, $sqlKrs);
$krs = [];
while($row = mysqli_fetch_assoc($resKrs)) {
    $krs[] = $row;
}

$sqlKhs = "SELECT mk.kode_mk, mk.nama_mk, mk.sks, n.grade_huruf, n.status_lulus, k.semester_ambil 
           FROM nilai n 
           JOIN krs k ON n.id_krs = k.id 
           JOIN jadwal_kuliah j ON k.id_jadwal = j.id 
           JOIN mata_kuliah mk ON j.id_mk = mk.id 
           WHERE k.id_mahasiswa = '$mhs_id'
           ORDER BY k.semester_ambil ASC, mk.nama_mk ASC";

$resKhs = mysqli_query($connect, $sqlKhs);
$akademik = [];
while($row = mysqli_fetch_assoc($resKhs)) {
    $akademik[] = $row;
}

echo json_encode([
    'success' => true,
    'data' => [
        'biodata' => $biodata,
        'registrasi' => $registrasi,
        'kurikulum' => $kurikulum,
        'krs' => $krs,
        'akademik' => $akademik
    ]
]);
?>