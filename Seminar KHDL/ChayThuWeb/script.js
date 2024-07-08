const apiBaseUrl = "https://api.themoviedb.org/3";
const apiKey = "781d8b0f33163181d96d61fa21ea16a4";
const imageBaseUrl = "https://image.tmdb.org/t/p/w300";

const moviesGrid = document.getElementById("movies-grid");

async function fetchMoviesUpComing() {
    const response = await fetch(`${apiBaseUrl}/movie/upcoming?api_key=${apiKey}`);
    const jsonResponse = await response.json();
    const movies = await Promise.all(
        jsonResponse.results.map(async (result) => ({
            id: result.id,
            title: result.title,
            poster_path: result.poster_path,
        }))
    );
    displayMovies(movies);
}

const csvFilePath = 'result_predict.csv';

async function readCSVFile(csvFilePath) {
    const response = await fetch(csvFilePath);
    const data = await response.text();
    const csvArray = data.split("\n");
    const values = csvArray.slice(0, csvArray.length - 1);
    const result = values.map((value) => parseFloat(value));
    return result;
}


function handleSearchFormSubmit(event) {
    
}

async function getIMDbId(movieId) {
    // const response = await fetch(`${apiBaseUrl}/movie/${movieId}/external_ids?api_key=${apiKey}`);
    // const jsonResponse = await response.json();
    // const IMDbId = jsonResponse.imdb_id;
    return 0;//IMDbId;
}


async function displayMovies(movies) {
    const arr = await readCSVFile(csvFilePath);
    moviesGrid.innerHTML = movies
        .map(
            (movie, index) =>
                `<div class="movie-card">
                    <a href="https://www.imdb.com/title/${movie.IMDbId}/">
                        <img src="${imageBaseUrl}${movie.poster_path}"/>
                        <p>⭐ ${arr[index]}</p>
                        <h1>${movie.title}<h1/>
                        
                    </a>

                 </div>`
                 
        )
        .join("");
}

fetchMoviesUpComing();
