import db_sqlite

proc init_db*(db: DbConn) = 
    db.exec(sql"""create table if not exists 
                        Users (
                            username VARCHAR(50) PRIMARY KEY UNIQUE COLLATE NOCASE, 
                            is_active INTEGER(1) default 1, 
                            views INTEGER(10) default 1,
                            created_at INTEGER(4) not null default (strftime('%s', 'now'))
                        )""")

    db.exec(sql"""create table if not exists 
                        Views (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            username VARCHAR(50) not null,
                            viewed_at INTEGER(4) not null default (strftime('%s', 'now')),
                            FOREIGN KEY(username) REFERENCES Users(username)
                        )""")
    
    db.exec(sql"""create table if not exists
                        Clicks (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            username VARCHAR(50) not null,
                            next_user VARCHAR(50) not null,
                            clicked_at INTEGER(4) not null default (strftime('%s', 'now')),
                            FOREIGN KEY(username) REFERENCES Users(username)
                        )""")