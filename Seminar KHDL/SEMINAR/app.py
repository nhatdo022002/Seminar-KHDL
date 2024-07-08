import os

import pandas as pd
from flask import Flask, render_template

app = Flask(__name__)

df = pd.read_csv("upcoming_movie.csv")


@app.route("/")
def index():
    movies = []
    for index, row in df.iterrows():
        imdb_id = row["imdb_id"]
        title = row["title"]
        rating = row["predicted_averageRating"]
        # image_path = os.path.join(image_dir, f"{imdb_id}.jpg")
        # image=imdb_id+".jpg"
        image_path = "static/" + imdb_id + ".jpg"

        movies.append({"title": title, "rating": rating, "image_path": image_path})

    return render_template("index.html", movies=movies)


if __name__ == "__main__":
    app.run(debug=True)
