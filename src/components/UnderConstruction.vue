<template>
    <div class="under-construction">
        <h1>Under Construction</h1>
        <p>Until this site is ready, please check out the blog page.</p>
        <a href="https://blog.atakanonol.dev"><button>Blog Site</button></a>
        <div class="construction-images">
            <img
                src="https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXgwNnE0c3N5dGxuMmF2bXNxdWkzZjNwZzNkYmhhZ3RrOWNpa2czeCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/l1J9rzKZ2QFUpz1WU/giphy.gif"
                alt="Construction Worker 1"
                class="construction-worker"
            />
            <img
                src="@/assets/construction-cone.png"
                alt="Construction Cone"
                class="construction-cone"
            />
            <img
                src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMGVodW85aW9ydm1vbTUwc3R0NW5nZ2RrcDlxcDZjZTF6ZDR6a3FpMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/3ohhwv2zZVt5BYdFRe/giphy.gif"
                alt="Construction Worker 2"
                class="construction-worker"
            />
        </div>
    </div>
</template>

<script>
export default {
    name: 'UnderConstruction',
};
</script>

<style scoped>
.under-construction {
    text-align: center;
    padding: 5vh;
}

.construction-images {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.construction-worker {
    @media (max-width: 750px) {
        display: none;
    }
}

.construction-cone {
    max-width: 300px; /* Adjust the image size as needed */
    height: auto;
    object-fit: contain;
    margin: 0 10px;
    /* Add animation properties for a subtle animation effect */
    animation: bounce 1s ease infinite alternate; /* Example animation */
}

@keyframes bounce {
    0% {
        transform: translateY(0);
    }
    100% {
        transform: translateY(-10px);
    }
}

button {
    display: inline-block;
    padding: 10px 20px;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    text-transform: uppercase;
    border: none;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s, color 0.3s, transform 0.3s;
    color: #001f3f;
    background-color: #ff851b;
}

/* Hover effect */
button:hover {
    color: #ff851b;
    background-color: #001f3f;
    
}
</style>