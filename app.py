import sqlite3
from flask import Flask, jsonify

app = Flask(__name__)

def get_db():
    conn = sqlite3.connect("mydb.db")
    conn.row_factory = sqlite3.Row
    return conn

@app.route("/")
def home():
    return jsonify({"message": "Library system is running"})

@app.route("/books")
def list_books():
    conn = get_db()
    rows = conn.execute("SELECT * FROM books").fetchall()
    conn.close()
    return jsonify([dict(row) for row in rows])

if __name__ == "__main__":
    app.run(debug=True)