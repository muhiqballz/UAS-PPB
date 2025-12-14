<?php
include 'koneksi.php';

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'User ID required']);
    exit;
}

$sql = "SELECT 
            j.hari, 
            mk.nama_mk, 
            j.jam_mulai, 
            j.jam_selesai, 
            j.ruangan, 
            d.nama_lengkap as nama_dosen
        FROM jadwal_kuliah j
        JOIN krs k ON k.id_jadwal = j.id
        JOIN mahasiswa m ON k.id_mahasiswa = m.id
        JOIN mata_kuliah mk ON j.id_mk = mk.id
        JOIN dosen d ON j.id_dosen = d.id
        WHERE m.user_id = '$user_id' 
        AND k.status_persetujuan = 'Disetujui'
        AND k.semester_ambil = 5
        ORDER BY FIELD(j.hari, 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'), j.jam_mulai";

$result = mysqli_query($connect, $sql);
$schedules = [];

while ($row = mysqli_fetch_assoc($result)) {
    $jam = substr($row['jam_mulai'], 0, 5) . ' - ' . substr($row['jam_selesai'], 0, 5);
    
    $schedules[] = [
        'day'      => $row['hari'],
        'subject'  => $row['nama_mk'],
        'time'     => $jam,
        'room'     => $row['ruangan'],
        'lecturer' => $row['nama_dosen']
    ];
}

echo json_encode([
    'success' => true,
    'data'    => $schedules
]);
?>