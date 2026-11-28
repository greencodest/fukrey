CREATE DATABASE IF NOT EXISTS codest_afya
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE codest_afya;

CREATE TABLE watumiaji (
    mtumiaji_id INT AUTO_INCREMENT PRIMARY KEY,
    jina_kamili VARCHAR(150) NOT NULL,
    jina_la_mtumiaji VARCHAR(80) NOT NULL UNIQUE,
    barua_pepe VARCHAR(150) UNIQUE,
    nenosiri_hash VARCHAR(255) NOT NULL,
    jukumu ENUM(
        'admin', 'daktari', 'muuguzi',
        'mapokezi', 'maabara', 'mfamasia', 'mhasibu'
    ) NOT NULL,
    hali ENUM('hai', 'imefungwa') NOT NULL DEFAULT 'hai',
    tarehe_kuundwa TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tarehe_kusasishwa TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE watoa_huduma (
    mtoa_huduma_id INT AUTO_INCREMENT PRIMARY KEY,
    mtumiaji_id INT UNIQUE,
    namba_leseni VARCHAR(80) UNIQUE,
    taaluma VARCHAR(120),
    simu VARCHAR(30),
    hali ENUM('hai', 'amesitishwa') NOT NULL DEFAULT 'hai',
    FOREIGN KEY (mtumiaji_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE wagonjwa (
    mgonjwa_id INT AUTO_INCREMENT PRIMARY KEY,
    namba_ya_mgonjwa VARCHAR(40) NOT NULL UNIQUE,
    jina_kamili VARCHAR(150) NOT NULL,
    jinsia ENUM('mwanaume', 'mwanamke', 'nyingine', 'haijatajwa')
        NOT NULL DEFAULT 'haijatajwa',
    tarehe_kuzaliwa DATE,
    namba_kitambulisho VARCHAR(80) UNIQUE,
    simu VARCHAR(30),
    barua_pepe VARCHAR(150),
    anwani VARCHAR(255),
    jina_mtu_wa_dharura VARCHAR(150),
    simu_mtu_wa_dharura VARCHAR(30),
    tarehe_usajili TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hali ENUM('hai', 'amefariki', 'amehamishwa') NOT NULL DEFAULT 'hai'
) ENGINE=InnoDB;

CREATE INDEX idx_wagonjwa_jina ON wagonjwa(jina_kamili);
CREATE INDEX idx_wagonjwa_simu ON wagonjwa(simu);

CREATE TABLE miadi (
    miadi_id INT AUTO_INCREMENT PRIMARY KEY,
    mgonjwa_id INT NOT NULL,
    mtoa_huduma_id INT,
    tarehe_muda DATETIME NOT NULL,
    sababu VARCHAR(255),
    hali ENUM(
        'imepangwa', 'imethibitishwa', 'imekamilika',
        'imefutwa', 'hakufika'
    ) NOT NULL DEFAULT 'imepangwa',
    maelezo TEXT,
    aliyeunda_id INT,
    tarehe_kuundwa TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mgonjwa_id) REFERENCES wagonjwa(mgonjwa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (mtoa_huduma_id) REFERENCES watoa_huduma(mtoa_huduma_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (aliyeunda_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_miadi_tarehe ON miadi(tarehe_muda);
CREATE INDEX idx_miadi_mgonjwa ON miadi(mgonjwa_id, tarehe_muda);

CREATE TABLE ziara (
    ziara_id INT AUTO_INCREMENT PRIMARY KEY,
    mgonjwa_id INT NOT NULL,
    miadi_id INT UNIQUE,
    mtoa_huduma_id INT,
    tarehe_ziara DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    malalamiko TEXT,
    historia_ya_ugonjwa TEXT,
    uchunguzi TEXT,
    utambuzi_wa_awali TEXT,
    mpango_matibabu TEXT,
    maelezo TEXT,
    hali ENUM('inaendelea', 'imekamilika', 'imefungwa')
        NOT NULL DEFAULT 'inaendelea',
    FOREIGN KEY (mgonjwa_id) REFERENCES wagonjwa(mgonjwa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (miadi_id) REFERENCES miadi(miadi_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (mtoa_huduma_id) REFERENCES watoa_huduma(mtoa_huduma_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_ziara_mgonjwa_tarehe
    ON ziara(mgonjwa_id, tarehe_ziara);

CREATE TABLE vipimo_vya_mwili (
    kipimo_id INT AUTO_INCREMENT PRIMARY KEY,
    ziara_id INT NOT NULL,
    uzito_kg DECIMAL(6,2),
    urefu_cm DECIMAL(6,2),
    joto_c DECIMAL(4,1),
    mapigo_kwa_dakika SMALLINT,
    shinikizo_systolic SMALLINT,
    shinikizo_diastolic SMALLINT,
    kiwango_cha_oksijeni DECIMAL(5,2),
    tarehe_kipimo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aliyeingiza_id INT,
    FOREIGN KEY (ziara_id) REFERENCES ziara(ziara_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (aliyeingiza_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE magonjwa (
    ugonjwa_id INT AUTO_INCREMENT PRIMARY KEY,
    msimbo VARCHAR(30) UNIQUE,
    jina_la_ugonjwa VARCHAR(180) NOT NULL,
    maelezo TEXT
) ENGINE=InnoDB;

CREATE TABLE utambuzi_wa_ziara (
    utambuzi_id INT AUTO_INCREMENT PRIMARY KEY,
    ziara_id INT NOT NULL,
    ugonjwa_id INT,
    maelezo_ya_utambuzi VARCHAR(255),
    aina ENUM('awali', 'ya_mwisho', 'ya_zamani')
        NOT NULL DEFAULT 'ya_mwisho',
    FOREIGN KEY (ziara_id) REFERENCES ziara(ziara_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ugonjwa_id) REFERENCES magonjwa(ugonjwa_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mizio (
    mzio_id INT AUTO_INCREMENT PRIMARY KEY,
    mgonjwa_id INT NOT NULL,
    kitu_kinachosababisha_mzio VARCHAR(180) NOT NULL,
    athari TEXT,
    ukali ENUM('mdogo', 'wa_kati', 'mkali', 'haujulikani')
        NOT NULL DEFAULT 'haujulikani',
    tarehe_kurekodi TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mgonjwa_id) REFERENCES wagonjwa(mgonjwa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE dawa (
    dawa_id INT AUTO_INCREMENT PRIMARY KEY,
    jina_la_dawa VARCHAR(180) NOT NULL,
    nguvu_ya_dawa VARCHAR(80),
    aina_ya_dawa VARCHAR(80),
    kipimo_cha_hisa VARCHAR(30),
    kiasi_hisa DECIMAL(10,2) NOT NULL DEFAULT 0,
    kiwango_cha_kuagiza_upya DECIMAL(10,2) NOT NULL DEFAULT 0,
    bei_kwa_kipimo DECIMAL(12,2) NOT NULL DEFAULT 0,
    tarehe_kuundwa TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hali ENUM('inapatikana', 'imesitishwa')
        NOT NULL DEFAULT 'inapatikana'
) ENGINE=InnoDB;

CREATE TABLE maagizo_dawa (
    agizo_dawa_id INT AUTO_INCREMENT PRIMARY KEY,
    ziara_id INT NOT NULL,
    mtoa_huduma_id INT,
    tarehe_agizo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    maelekezo_ya_jumla TEXT,
    FOREIGN KEY (ziara_id) REFERENCES ziara(ziara_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (mtoa_huduma_id) REFERENCES watoa_huduma(mtoa_huduma_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vipengele_vya_agizo_dawa (
    kipengele_id INT AUTO_INCREMENT PRIMARY KEY,
    agizo_dawa_id INT NOT NULL,
    dawa_id INT,
    jina_dawa TEXT NOT NULL,
    dozi VARCHAR(100),
    mara_ngapi VARCHAR(100),
    muda_matibabu VARCHAR(100),
    kiasi DECIMAL(10,2),
    maelekezo TEXT,
    FOREIGN KEY (agizo_dawa_id) REFERENCES maagizo_dawa(agizo_dawa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (dawa_id) REFERENCES dawa(dawa_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vipimo_maabara (
    kipimo_maabara_id INT AUTO_INCREMENT PRIMARY KEY,
    jina_kipimo VARCHAR(180) NOT NULL,
    maelezo TEXT,
    bei DECIMAL(12,2) NOT NULL DEFAULT 0,
    hali ENUM('kinapatikana', 'kimesitishwa')
        NOT NULL DEFAULT 'kinapatikana'
) ENGINE=InnoDB;

CREATE TABLE maagizo_maabara (
    agizo_maabara_id INT AUTO_INCREMENT PRIMARY KEY,
    ziara_id INT NOT NULL,
    aliyeagiza_id INT,
    tarehe_agizo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hali ENUM('limeagizwa', 'linaendelea', 'limekamilika', 'limefutwa')
        NOT NULL DEFAULT 'limeagizwa',
    maelezo TEXT,
    FOREIGN KEY (ziara_id) REFERENCES ziara(ziara_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (aliyeagiza_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vipengele_vya_maabara (
    kipengele_maabara_id INT AUTO_INCREMENT PRIMARY KEY,
    agizo_maabara_id INT NOT NULL,
    kipimo_maabara_id INT,
    jina_kipimo VARCHAR(180) NOT NULL,
    matokeo TEXT,
    kipimo_cha_matokeo VARCHAR(50),
    kiwango_rejea VARCHAR(100),
    hali ENUM('inasubiri', 'kinaendelea', 'kimekamilika', 'kimefutwa')
        NOT NULL DEFAULT 'inasubiri',
    tarehe_matokeo DATETIME,
    aliyeingiza_matokeo_id INT,
    FOREIGN KEY (agizo_maabara_id) REFERENCES maagizo_maabara(agizo_maabara_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (kipimo_maabara_id) REFERENCES vipimo_maabara(kipimo_maabara_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (aliyeingiza_matokeo_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE malipo (
    malipo_id INT AUTO_INCREMENT PRIMARY KEY,
    mgonjwa_id INT NOT NULL,
    ziara_id INT,
    kiasi DECIMAL(12,2) NOT NULL,
    njia ENUM('taslimu', 'simu', 'bima', 'kadi', 'benki', 'nyingine')
        NOT NULL DEFAULT 'taslimu',
    namba_ya_rejea VARCHAR(100),
    hali ENUM('inasubiri', 'imelipwa', 'imefutwa', 'imerejeshwa')
        NOT NULL DEFAULT 'imelipwa',
    tarehe_malipo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aliyepokea_id INT,
    maelezo TEXT,
    FOREIGN KEY (mgonjwa_id) REFERENCES wagonjwa(mgonjwa_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ziara_id) REFERENCES ziara(ziara_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (aliyepokea_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_malipo_mgonjwa_tarehe
    ON malipo(mgonjwa_id, tarehe_malipo);

CREATE TABLE kumbukumbu_shughuli (
    kumbukumbu_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mtumiaji_id INT,
    kitendo VARCHAR(100) NOT NULL,
    jedwali_lililoguswa VARCHAR(100),
    rekodi_id VARCHAR(80),
    maelezo JSON,
    anwani_ip VARCHAR(45),
    tarehe_shughuli TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mtumiaji_id) REFERENCES watumiaji(mtumiaji_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;