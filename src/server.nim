import jester
import db_sqlite
import ./site_setup

# Setup
let db = open("ring.db", "", "", "")
init_db(db)

proc recordView(username: string) =
    # First, get or create the user record
    debugEcho("Attempting to insert a user")
    debugEcho(username)
    if not db.tryExec(sql"INSERT INTO Users (username) VALUES (?) ON CONFLICT(username) DO UPDATE SET views=views+1;", username):
        dbError(db)
    #Then record a view for the user
    if not db.tryExec(sql"INSERT INTO Views (username) VALUES (?);", username):
        dbError(db)
    echo "recorded a view for " & username

proc getRandomUser(): string =
    let user = db.getValue(sql"SELECT username FROM Users WHERE is_active=1 ORDER BY RANDOM() LIMIT 1;")
    return user

proc serveUserBadge(username: string): string =
    let row = db.getRow(sql"SELECT username, views FROM Users WHERE username = ?;", username)
    let badge = "This is " & username & "'s badge. <br> They have " & row[1] & " views. How cool!" &
                "<br><a href='/u/" & username & "/next'>See another!</a>"
    return badge 

routes:
    get "/":
        resp "hello"
    get "/u/@username":
        recordView(@"username")
        resp serveUserBadge(@"username")
    get "/u/@username/next":
        redirect("/u/" & getRandomUser())

runForever()
db.close()
