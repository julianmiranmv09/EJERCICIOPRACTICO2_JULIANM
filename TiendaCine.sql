CREATE DATABASE IF NOT EXISTS cinemark_db;
USE cinemark_db;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion TEXT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    email_verificado BOOLEAN DEFAULT FALSE,
    INDEX idx_email (email),
    INDEX idx_nombre_apellido (nombre, apellido)
);


CREATE TABLE peliculas (
    id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    titulo_original VARCHAR(200),
    sinopsis TEXT,
    duracion_minutos INT NOT NULL,
    clasificacion ENUM('G', 'PG', 'PG-13', 'R', 'NC-17') NOT NULL,
    director VARCHAR(150),
    reparto TEXT,
    poster_url TEXT,
    trailer_url TEXT,
    fecha_estreno DATE NOT NULL,
    fecha_fin_cartelera DATE,
    activo BOOLEAN DEFAULT TRUE,
    idioma_original VARCHAR(50) DEFAULT 'Inglés',
    pais_origen VARCHAR(100),
    calificacion_imdb DECIMAL(3,1),
    INDEX idx_titulo (titulo),
    INDEX idx_fecha_estreno (fecha_estreno),
    INDEX idx_activo (activo)
);

CREATE TABLE cines (
    id_cine INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    ciudad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_ciudad (ciudad),
    INDEX idx_activo (activo)
);

CREATE TABLE asientos (
    id_asiento INT AUTO_INCREMENT PRIMARY KEY,
    id_sala INT NOT NULL,
    fila CHAR(2) NOT NULL,
    numero INT NOT NULL,
    tipo_asiento ENUM('normal', 'vip', 'discapacitado') DEFAULT 'normal',
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_sala) REFERENCES salas(id_sala) ON DELETE CASCADE,
    UNIQUE KEY unique_asiento (id_sala, fila, numero),
    INDEX idx_sala (id_sala)
);

CREATE TABLE funciones (
    id_funcion INT AUTO_INCREMENT PRIMARY KEY,
    id_pelicula INT NOT NULL,
    id_sala INT NOT NULL,
    fecha_funcion DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    precio_base DECIMAL(8,2) NOT NULL,
    subtitulada BOOLEAN DEFAULT FALSE,
    doblada BOOLEAN DEFAULT TRUE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_pelicula) REFERENCES peliculas(id_pelicula) ON DELETE CASCADE,
    FOREIGN KEY (id_sala) REFERENCES salas(id_sala) ON DELETE CASCADE,
    INDEX idx_pelicula (id_pelicula),
    INDEX idx_sala (id_sala),
    INDEX idx_fecha_hora (fecha_funcion, hora_inicio),
    INDEX idx_activo (activo)
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_funcion INT NOT NULL,
    codigo_reserva VARCHAR(20) UNIQUE NOT NULL,
    cantidad_boletos INT NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'pagada', 'cancelada') DEFAULT 'pendiente',
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento TIMESTAMP NOT NULL,
    metodo_pago ENUM('tarjeta', 'transferencia', 'efectivo', 'paypal') NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_funcion) REFERENCES funciones(id_funcion) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario),
    INDEX idx_funcion (id_funcion),
    INDEX idx_codigo (codigo_reserva),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_reserva)
);

CREATE TABLE reserva_asientos (
    id_reserva INT,
    id_asiento INT,
    precio_asiento DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id_reserva, id_asiento),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE,
    FOREIGN KEY (id_asiento) REFERENCES asientos(id_asiento) ON DELETE CASCADE
);

CREATE TABLE carrito (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_funcion INT NOT NULL,
    id_asiento INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id VARCHAR(100), -- Para usuarios no registrados
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_funcion) REFERENCES funciones(id_funcion) ON DELETE CASCADE,
    FOREIGN KEY (id_asiento) REFERENCES asientos(id_asiento) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario),
    INDEX idx_session (session_id),
    INDEX idx_fecha (fecha_agregado)
);

INSERT INTO peliculas (titulo, titulo_original, sinopsis, duracion_minutos, clasificacion, director, reparto, poster_url, fecha_estreno, fecha_fin_cartelera, idioma_original, pais_origen) VALUES
('Los 4 Fantásticos First Steps', 'The Fantastic Four: First Steps', 'Los héroes más poderosos de Marvel regresan en una nueva aventura épica.', 125, 'PG-13', 'Matt Shakman', 'Pedro Pascal, Vanessa Kirby, Joseph Quinn', 'https://tse1.mm.bing.net/th/id/OIP.kcF-5qQd2R5Vr1IRJwjIhgHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-07-25', '2025-09-25', 'Inglés', 'Estados Unidos'),

('Cómo entrenar a tu dragón live action', 'How to Train Your Dragon', 'La adaptación en acción real de la querida historia de Hiccup y su dragón Desdentao.', 104, 'PG', 'Dean DeBlois', 'Mason Thames, Nico Parker', 'https://mlpnk72yciwc.i.optimole.com/cqhiHLc.IIZS~2ef73/w:auto/h:auto/q:75/https://bleedingcool.com/wp-content/uploads/2025/02/HTD_OnlineOOHTag17_RGB_4.jpg', '2025-06-13', '2025-08-13', 'Inglés', 'Estados Unidos'),

('Jurassic Park Renace', 'Jurassic World Rebirth', 'Los dinosaurios regresan en una nueva era de aventuras prehistóricas.', 147, 'PG-13', 'Gareth Edwards', 'Scarlett Johansson, Mahershala Ali, Jonathan Bailey', 'https://i0.wp.com/www.artofvfx.com/wp-content/uploads/2018/04/jurassic_world_fallen_kingdom_ver2_xlg.jpg?fit=790%2C1251&ssl=1', '2025-07-02', '2025-09-02', 'Inglés', 'Estados Unidos'),

('F1 La película', 'F1', 'Un piloto de Fórmula 1 veterano regresa para competir junto a un novato talentoso.', 150, 'PG-13', 'Joseph Kosinski', 'Brad Pitt, Damson Idris, Kerry Condon', 'https://pics.filmaffinity.com/f1_the_movie-603739796-large.jpg', '2025-06-27', '2025-08-27', 'Inglés', 'Estados Unidos'),

('Superman', 'Superman', 'El hombre de acero regresa en una nueva aventura heroica.', 140, 'PG-13', 'James Gunn', 'David Corenswet, Rachel Brosnahan', 'https://tse3.mm.bing.net/th/id/OIP.qlcCw5tldJ5m8F0Ld2l3LgHaJP?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-07-11', '2025-09-11', 'Inglés', 'Estados Unidos'),

('Tipos malos 2', 'The Bad Guys 2', 'Los criminales más adorables regresan para una nueva travesura.', 100, 'PG', 'Pierre Perifel', 'Sam Rockwell, Marc Maron, Awkwafina', 'https://tse2.mm.bing.net/th/id/OIP.aerPI7Br3ZfJkZHmMl98BwHaKy?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-08-01', '2025-10-01', 'Inglés', 'Estados Unidos'),

('La hora de la desaparición', 'The Vanishing Hour', 'Un thriller sobrenatural que mantendrá a los espectadores al borde de sus asientos.', 108, 'R', 'Mike Flanagan', 'Rebecca Ferguson, Oscar Isaac', 'https://tse1.mm.bing.net/th/id/OIP.p0b-kLk4MN9e_xMxDNN1vgHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-08-15', '2025-10-15', 'Inglés', 'Estados Unidos'),

('Exorcismo: El ritual', 'The Exorcism Ritual', 'Una experiencia terrorífica que pondrá a prueba los nervios más firmes.', 112, 'R', 'Mike Flanagan', 'Vera Farmiga, Patrick Wilson', 'https://tse2.mm.bing.net/th/id/OIP.q5f2sc5KuPE1Eu1W8-XCdAHaK9?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-09-05', '2025-11-05', 'Inglés', 'Estados Unidos'),

('Rosario: Herencia maldita', 'Rosario: Cursed Heritage', 'Una familia descubre secretos oscuros en su herencia ancestral.', 95, 'R', 'Guillermo del Toro', 'Jessica Chastain, Michael Shannon', 'https://tse1.mm.bing.net/th/id/OIP.4qWxJycr04PuoqENd7laUQHaNK?rs=1&pid=ImgDetMain&o=7&rm=3', '2025-09-20', '2025-11-20', 'Español', 'México');

INSERT INTO pelicula_generos (id_pelicula, id_genero) VALUES
(1, 9), (1, 1), (1, 3), -- Los 4 Fantásticos: Superhéroes, Acción, Ciencia Ficción
(2, 8), (2, 2), (2, 10), -- Cómo entrenar a tu dragón: Animación, Aventura, Familiar
(3, 1), (3, 2), (3, 3), -- Jurassic Park: Acción, Aventura, Ciencia Ficción
(4, 1), (4, 7), -- F1: Acción, Drama
(5, 9), (5, 1), (5, 3), -- Superman: Superhéroes, Acción, Ciencia Ficción
(6, 8), (6, 6), (6, 10), -- Tipos malos: Animación, Comedia, Familiar
(7, 5), (7, 7), -- La hora de la desaparición: Terror, Drama
(8, 5), (8, 7), -- Exorcismo: Terror, Drama
(9, 5), (9, 7); -- Rosario: Terror, Drama