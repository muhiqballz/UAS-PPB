<?php
include 'koneksi.php';

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';

if(empty($user_id)) {
    $user_id = 1;
}

$englishDay = date('l');
$days = [
    'Monday'    => 'Senin',
    'Tuesday'   => 'Selasa',
    'Wednesday' => 'Rabu',
    'Thursday'  => 'Kamis',
    'Friday'    => 'Jumat',
    'Saturday'  => 'Sabtu',
    'Sunday'    => 'Minggu'
];
$hariIni = $days[$englishDay];


$sqlInfo = "SELECT * FROM pengumuman ORDER BY tanggal_posting DESC LIMIT 3";
$resInfo = mysqli_query($connect, $sqlInfo);
$listInfo = [];
while($row = mysqli_fetch_assoc($resInfo)) {
    $listInfo[] = [
        'title'   => $row['judul'],
        'message' => $row['pesan'],
        'icon'    => $row['icon_string'],
        'color'   => $row['warna_hex']
    ];
}


$sqlJadwal = "SELECT 
    mk.nama_mk, 
    j.jam_mulai, 
    j.jam_selesai, 
    j.ruangan, 
    d.nama_lengkap as nama_dosen
FROM jadwal_kuliah j
JOIN mata_kuliah mk ON j.id_mk = mk.id
JOIN dosen d ON j.id_dosen = d.id
JOIN krs k ON k.id_jadwal = j.id
JOIN mahasiswa m ON k.id_mahasiswa = m.id
WHERE m.user_id = '$user_id' 
AND j.hari = '$hariIni'
AND k.status_persetujuan = 'Disetujui'
ORDER BY j.jam_mulai ASC";

$resJadwal = mysqli_query($connect, $sqlJadwal);
$listJadwal = [];
while($row = mysqli_fetch_assoc($resJadwal)) {
    $jam = substr($row['jam_mulai'], 0, 5) . ' - ' . substr($row['jam_selesai'], 0, 5);
    
    $listJadwal[] = [
        'subject'  => $row['nama_mk'],
        'time'     => $jam,
        'room'     => $row['ruangan'],
        'lecturer' => $row['nama_dosen']
    ];
}

echo json_encode([
    'success' => true,
    'hari_ini' => $hariIni,
    'data_user' => ['id' => $user_id],
    'schedule' => $listJadwal,
    'info'     => $listInfo
]);
?>