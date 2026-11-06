import sqlite3
from flask import Flask, jsonify, request

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

@app.route("/books/<int:book_id>")
def get_book(book_id):
    conn = get_db()
    row = conn.execute("SELECT * FROM books WHERE ID = ?", (book_id,)).fetchone()
    conn.close()
    if row is None:
        return jsonify({"error": "Book not found"}), 404
    return jsonify(dict(row))

@app.route("/books", methods=["POST"])
def add_book():
    data = request.get_json()
    if not data or "title" not in data or "author" not in data:
        return jsonify({"error": "title and author are required"}), 400
    conn = get_db()
    cur = conn.execute(
        "INSERT INTO books (Title, Author, Available) VALUES (?, ?, ?)",
        (data["title"], data["author"], 1),
    )
    conn.commit()
    new_id = cur.lastrowid
    conn.close()
    return jsonify({"ID": new_id, "Title": data["title"], "Author": data["author"]}), 201
@app.route("/books/<int:book_id>", methods=["PUT"])
def update_book(book_id):
    data = request.get_json()
    if not data:
        return jsonify({"error": "JSON body required"}), 400
    conn = get_db()
    row = conn.execute("SELECT * FROM books WHERE ID = ?", (book_id,)).fetchone()
    if row is None:
        conn.close()
        return jsonify({"error": "Book not found"}), 404
    title = data.get("title", row["Title"])
    author = data.get("author", row["Author"])
    available = data.get("available", row["Available"])
    conn.execute(
        "UPDATE books SET Title = ?, Author = ?, Available = ? WHERE ID = ?",
        (title, author, available, book_id),
    )
    conn.commit()
    conn.close()
    return jsonify({"ID": book_id, "Title": title, "Author": author, "Available": available})
@app.route("/books/<int:book_id>", methods=["DELETE"])
def delete_book(book_id):
    conn = get_db()
    row = conn.execute("SELECT * FROM books WHERE ID = ?", (book_id,)).fetchone()
    if row is None:
        conn.close()
        return jsonify({"error": "Book not found"}), 404
    conn.execute("DELETE FROM books WHERE ID = ?", (book_id,))
    conn.commit()
    conn.close()
    return jsonify({"message": "Book deleted"})
if __name__ == "__main__":
    app.run(debug=True)