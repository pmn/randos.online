import jester
import strutils
import db_sqlite
import ./db_schema

# Setup
let db = open("ring.db", "", "", "")
init_db(db)

proc recordView(username: string) =
    # First, get or create the user record
    if not db.tryExec(sql"INSERT INTO Users (username) VALUES (?) ON CONFLICT(username) DO UPDATE SET views=views+1;", username):
        dbError(db)
    #Then record a view for the user
    if not db.tryExec(sql"INSERT INTO Views (username) VALUES (?);", username):
        dbError(db)

proc getRandomUser(): string =
    let user = db.getValue(sql"SELECT username FROM Users WHERE is_active=1 ORDER BY RANDOM() LIMIT 1;")
    return user

proc clickNext(from_user: string): string =
    let next = getRandomUser()
    if not db.tryExec(sql"INSERT INTO Clicks (username, next_user) VALUES (?, ?);", from_user, next):
        dbError(db)
    return next

proc serveUserBadge(username: string): string =
    let tmpl = readfile("badge_small.svg.tmpl")
    let row = db.getRow(sql"SELECT username, views FROM Users WHERE username = ?;", username)
    var output = replace(tmpl, "$username", row[0])
    output  = replace(output, "$views", row[1])
    return output

routes:
    get "/":
        resp "Get a CodeRing!"
    get "/random":
        redirect("/u/" & getRandomUser())
    get "/u/@username":
        recordView(@"username")
        #resp serveUserBadge(@"username")
        resp(Http200, [("Content-Type", "image/svg+xml"), ("Cache-Control", "no-cache")], serveUserBadge(@"username"))
    get "/u/@username/next":
        redirect("/u/" & clickNext(@"username"))

runForever()
db.close()
