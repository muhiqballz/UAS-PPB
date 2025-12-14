<?php
include 'koneksi.php';

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'User ID required']);
    exit;
}

$sqlCourses = "SELECT mk.id, mk.nama_mk, mk.kode_mk 
               FROM krs k
               JOIN mahasiswa m ON k.id_mahasiswa = m.id
               JOIN jadwal_kuliah j ON k.id_jadwal = j.id
               JOIN mata_kuliah mk ON j.id_mk = mk.id
               WHERE m.user_id = '$user_id' 
               AND k.status_persetujuan = 'Disetujui'
               AND k.semester_ambil = 5
               GROUP BY mk.id"; 

$resCourses = mysqli_query($connect, $sqlCourses);
$courseList = [];

while ($course = mysqli_fetch_assoc($resCourses)) {
    $mk_id = $course['id'];
    
    $sqlMat = "SELECT judul_materi, jenis_file, file_path FROM bahan_ajar WHERE id_mk = '$mk_id'";
    $resMat = mysqli_query($connect, $sqlMat);
    $materials = [];
    while($row = mysqli_fetch_assoc($resMat)) {
        $materials[] = $row;
    }

    $sqlVid = "SELECT judul_video, durasi, url_video FROM video_pembelajaran WHERE id_mk = '$mk_id'";
    $resVid = mysqli_query($connect, $sqlVid);
    $videos = [];
    while($row = mysqli_fetch_assoc($resVid)) {
        $videos[] = $row;
    }

    $sqlTugas = "SELECT judul_tugas, deadline, deskripsi FROM tugas WHERE id_mk = '$mk_id'";
    $resTugas = mysqli_query($connect, $sqlTugas);
    $assignments = [];
    while($row = mysqli_fetch_assoc($resTugas)) {
        $assignments[] = [
            'title' => $row['judul_tugas'],
            'dueDate' => 'Tenggat: ' . date('d M Y', strtotime($row['deadline'])),
            'status' => 'Belum Dikumpulkan'
        ];
    }

    $courseList[] = [
        'name' => $course['nama_mk'],
        'icon' => 'book',
        'color' => '0xFF3498DB',
        'materials' => $materials,
        'videos' => $videos,
        'assignments' => $assignments
    ];
}

echo json_encode(['success' => true, 'data' => $courseList]);
?>