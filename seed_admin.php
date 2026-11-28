<?php
declare(strict_types=1);

// Endesha faili hili kwa command line, si kwa ukurasa wa tovuti.
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("Faili hili linaendeshwa kupitia command line pekee.\n");
}

$dbHost = getenv('DB_HOST') ?: '127.0.0.1';
$dbName = getenv('DB_NAME') ?: 'codest_afya';
$dbUser = getenv('DB_USER') ?: 'root';
$dbPass = getenv('DB_PASS') ?: '';

$adminName = getenv('ADMIN_NAME') ?: 'Msimamizi';
$adminUsername = getenv('ADMIN_USERNAME');
$adminEmail = getenv('ADMIN_EMAIL') ?: null;
$adminPassword = getenv('ADMIN_PASSWORD');

if (!$adminUsername || !$adminPassword) {
    exit("Weka ADMIN_USERNAME na ADMIN_PASSWORD kisha ujaribu tena.\n");
}

if (strlen($adminPassword) < 12) {
    exit("Nenosiri la admin liwe na angalau herufi 12.\n");
}

try {
    $pdo = new PDO(
        "mysql:host={$dbHost};dbname={$dbName};charset=utf8mb4",
        $dbUser,
        $dbPass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );

    $check = $pdo->prepare(
        'SELECT mtumiaji_id
         FROM watumiaji
         WHERE jina_la_mtumiaji = :username'
    );
    $check->execute(['username' => $adminUsername]);

    if ($check->fetch()) {
        exit("Akaunti hiyo ya mtumiaji tayari ipo; hakuna kilichobadilishwa.\n");
    }

    $passwordHash = password_hash($adminPassword, PASSWORD_DEFAULT);

    $insert = $pdo->prepare(
        'INSERT INTO watumiaji
            (jina_kamili, jina_la_mtumiaji, barua_pepe, nenosiri_hash, jukumu, hali)
         VALUES
            (:name, :username, :email, :password_hash, :role, :status)'
    );

    $insert->execute([
        'name'          => $adminName,
        'username'      => $adminUsername,
        'email'         => $adminEmail,
        'password_hash' => $passwordHash,
        'role'          => 'admin',
        'status'        => 'hai',
    ]);

    echo "Akaunti ya admin imehifadhiwa kwenye database.\n";
} catch (PDOException $e) {
    // Usionyeshe taarifa za siri za database kwa mtumiaji.
    fwrite(STDERR, "Imeshindikana kuunganisha au kuhifadhi taarifa kwenye database.\n");
    exit(1);
}