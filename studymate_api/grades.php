<?php
include 'koneksi.php';

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'User ID required']);
    exit;
}

$sql = "SELECT 
            mk.nama_mk, 
            mk.sks,
            n.nilai_tugas, 
            n.nilai_uts, 
            n.nilai_uas, 
            n.grade_huruf,
            n.status_lulus
        FROM nilai n
        JOIN krs k ON n.id_krs = k.id
        JOIN mahasiswa m ON k.id_mahasiswa = m.id
        JOIN jadwal_kuliah j ON k.id_jadwal = j.id
        JOIN mata_kuliah mk ON j.id_mk = mk.id
        WHERE m.user_id = '$user_id' 
        AND k.status_persetujuan = 'Disetujui'";

$result = mysqli_query($connect, $sql);
$grades = [];

while ($row = mysqli_fetch_assoc($result)) {
    $grades[] = [
        'subject' => $row['nama_mk'],
        'sks' => (int)$row['sks'],
        'taskScore' => (float)$row['nilai_tugas'],
        'midScore' => (float)$row['nilai_uts'],
        'finalScore' => (float)$row['nilai_uas'],
        'grade' => $row['grade_huruf'] ?? '-',
        'isPassed' => $row['status_lulus'] == 1
    ];
}

echo json_encode(['success' => true, 'data' => $grades]);
?>