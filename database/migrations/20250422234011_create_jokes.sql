-- drift:migrate
CREATE TABLE IF NOT EXISTS jokes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    setup TEXT NOT NULL,
    punchline TEXT NOT NULL,
    fruit TEXT NOT NULL,
    comedian_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comedian_id) REFERENCES comedians (id) ON DELETE SET NULL
);

-- drift:rollback
DROP TABLE IF EXISTS jokes;
