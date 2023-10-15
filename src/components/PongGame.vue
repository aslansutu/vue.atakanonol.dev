<template>
    <div class="container">
        <h2>Pong</h2>
        <div class="game-board" ref="gameBoard">
            <div v-if="gameStopped" class="overlay">
                <div class="message-box">
                    <b>Score: {{ score }}</b>
                    <button @click="startGame()"><b>Start</b></button>
                </div>
            </div>
            <div class="paddle left-paddle" ref="leftPaddle"></div>
            <div class="paddle right-paddle" ref="rightPaddle"></div>
            <div class="ball" ref="ball"></div>
        </div>
        Directions: Use arrow keys to move up and down
    </div>
</template>

<script>
import wall_bounce from '@/assets/sounds/wall_bounce.mp3'
import pong from '@/assets/sounds/pong.mp3'
import game_start from '@/assets/sounds/game_start.mp3'
import game_end from '@/assets/sounds/game_end.mp3'

const wall_sound = new Audio(wall_bounce)
const paddle_sound = new Audio(pong)

export default {
    name: 'PongGame',
    data() {
        return {
            leftPaddle: {'position': {'top': 0, 'left': 0}, 'size': {'width': 0, 'height': 0}, 'speed': 2},  // Initial Y position of the left paddle
            rightPaddle: {'position': {'top': 0, 'left': 0}, 'size': {'width': 0, 'height': 0}, 'speed': 10},
            board: {'width': null, 'height': null},
            ball: {'speed': {'x': 5, 'y': 0}, 'position': {'x': null, 'y': null}, 'size': {'width': 20, 'height': 20}},
            interval: null,
            playerMoving: null,
            cpu: null,
            score: 0,
            gameStopped: true
        };
    },
    mounted() {
        window.addEventListener("resize", this.updateBoardSize)
        this.init()
    },
    methods: {
        init() {
            this.board.width = this.$refs.gameBoard.offsetWidth - 10 // Subtract borders
            this.board.height = this.$refs.gameBoard.offsetHeight - 10  // Subtract borders

            // Init ball - set default starting values
            this.ball.position.x = this.board.width/2
            this.ball.position.y = this.board.height/2

            this.ball.speed.x = 5
            this.ball.speed.y = 0

            this.$refs.ball.style.top = this.ball.position.y + 'px'
            this.$refs.ball.style.left = this.ball.position.x + 'px'

            // Init left paddle
            this.leftPaddle.size.width = this.$refs.leftPaddle.offsetWidth
            this.leftPaddle.size.height = this.$refs.leftPaddle.offsetHeight
            this.leftPaddle.position.top = 20
            this.leftPaddle.position.left = 10

            // Init right paddle
            this.rightPaddle.size.width = this.$refs.rightPaddle.offsetWidth
            this.rightPaddle.size.height = this.$refs.rightPaddle.offsetHeight
            this.rightPaddle.position.top = 20
            this.rightPaddle.position.left = this.board.width - this.rightPaddle.size.width - this.leftPaddle.position.left

            this.updatePaddles()

            this.score = 0
        },
        movePaddle(paddle, direction) {
            if (paddle === 'right') {
                if (direction === 'up') {
                    this.rightPaddle.position.top -= this.rightPaddle.speed
                }
                else if (direction === 'down') {
                    this.rightPaddle.position.top += this.rightPaddle.speed
                }
            }

            if (paddle === 'left') {
                if (direction === 'up') {
                    this.leftPaddle.position.top -= this.leftPaddle.speed
                }
                else if (direction === 'down') {
                    this.leftPaddle.position.top += this.leftPaddle.speed
                }
            }

            this.updatePaddles()
        },
        followBall() {
            let cpuMove = (parseInt(Math.random() * 100) % 4) + 1
            if (this.leftPaddle.position.top + (this.leftPaddle.size.height/2.0) > this.ball.position.y + (this.ball.size.height/2.0)) {
                for (let i = 0; i < cpuMove; i++) {
                    this.movePaddle('left', 'up')
                }
            }
            else if (this.leftPaddle.position.top + (this.leftPaddle.size.height/2.0) < this.ball.position.y + (this.ball.size.height/2.0)) {
                for (let i = 0; i < cpuMove; i++) {
                    this.movePaddle('left', 'down')
                }
            }
        },
        updatePaddles()  {
            // Right
            if (this.rightPaddle.position.top <= 0) {
                this.rightPaddle.position.top = 0
            }
            else if (this.rightPaddle.position.top + this.rightPaddle.size.height >= this.board.height) {
                this.rightPaddle.position.top = this.board.height - this.rightPaddle.size.height
            }
            
            this.$refs.rightPaddle.style.top = this.rightPaddle.position.top + 'px'
            this.$refs.rightPaddle.style.left = this.rightPaddle.position.left + 'px'

            // Left
            if (this.leftPaddle.position.top <= 0) {
                this.leftPaddle.position.top = 0
            }
            else if (this.leftPaddle.position.top >= this.board.height - this.leftPaddle.size.height) {
                this.leftPaddle.position.top = this.board.height - this.leftPaddle.size.height
            }

            this.$refs.leftPaddle.style.top = this.leftPaddle.position.top + 'px'
            this.$refs.leftPaddle.style.left = this.leftPaddle.position.left + 'px'
        },
        updateBall() {
            this.ball.position.x += this.ball.speed.x 
            this.ball.position.y += this.ball.speed.y

            // Check Wall Collision
            if (this.ball.position.x < 0 || this.ball.position.x > this.board.width - this.ball.size.width) {
                if (this.ball.position.x < 0) {
                    this.$refs.ball.style.left = 0 + 'px'
                } else {
                    this.$refs.ball.style.left = (this.board.width - this.ball.size.width) + 'px'
                }
                return this.endGame()
            }
            if (this.ball.position.y < 0 || this.ball.position.y > this.board.height - this.ball.size.height) {
                if (this.ball.position.y < 0) {
                    this.ball.position.y = 0
                } else {
                    this.ball.position.y = this.board.height - this.ball.size.height
                }
                this.ball.speed.y *= -1
                // Chance of increasing speed on collision
                if (parseInt(Math.random() * 100) % 2 && Math.abs(this.ball.speed.x) < 32) {
                    if (this.ball.speed.x < 0) {
                        this.ball.speed.x -= 1
                    } else {
                        this.ball.speed.x += 1
                    }
                }
                wall_sound.play()
            }

            // Right Paddle Collision
            if (this.ball.position.x + this.ball.size.width >= this.rightPaddle.position.left) {
                if (this.ball.position.y + (this.ball.size.height/2.0) >= this.rightPaddle.position.top && 
                    this.ball.position.y + (this.ball.size.height/2.0) <= this.rightPaddle.position.top + this.rightPaddle.size.height) {
                    this.ball.position.x = this.rightPaddle.position.left - this.ball.size.width

                    // Max speed
                    if (Math.abs(this.ball.speed.x) < 32) {
                        this.ball.speed.x += 1
                    }
                    this.ball.speed.x *= -1

                    this.ball.speed.y = ((this.rightPaddle.position.top + (this.rightPaddle.size.height/2.0)) - this.ball.position.y) / (-10)
                    this.score++
                    paddle_sound.play()
                }
            }

            // Left Paddle Collision
            if (this.ball.position.x <= this.leftPaddle.position.left + this.leftPaddle.size.width) {
                if (this.ball.position.y + (this.ball.size.height/2.0) >= this.leftPaddle.position.top &&
                    this.ball.position.y + (this.ball.size.height/2.0) <= this.leftPaddle.position.top + this.leftPaddle.size.height) {
                        this.ball.position.x = this.leftPaddle.position.left + this.leftPaddle.size.width

                        // Max speed
                        if (Math.abs(this.ball.speed.x) < 32) {
                            this.ball.speed.x -= 1
                        }
                        this.ball.speed.x *= -1

                        this.ball.speed.y = ((this.leftPaddle.position.top + (this.leftPaddle.size.height/2.0)) - this.ball.position.y) / (-10)
                        paddle_sound.play()
                    }
            }

            this.$refs.ball.style.left = this.ball.position.x + 'px'
            this.$refs.ball.style.top = this.ball.position.y + 'px'

        },
        updateBoardSize() {
            this.board.width = this.$refs.gameBoard.offsetWidth - 10 // Subtract borders
            this.board.height = this.$refs.gameBoard.offsetHeight - 10  // Subtract borders

            this.rightPaddle.position.left = this.board.width - this.rightPaddle.size.width - this.leftPaddle.position.left
            
            this.updatePaddles()

            this.ball.position.x = this.board.width/2
            this.ball.position.y = this.board.height/2

            this.$refs.ball.style.top = this.ball.position.y + 'px'
            this.$refs.ball.style.left = this.ball.position.x + 'px'
        },
        handleKeyDown(event) {
            event.preventDefault() // Prevent scrolling window
            if (!this.playerMoving){
                if (event.key === 'ArrowUp') {
                    this.playerMoving = setInterval(() => this.movePaddle('right', 'up'), 24)
                } else if (event.key === 'ArrowDown') {
                    this.playerMoving = setInterval(() => this.movePaddle('right', 'down'), 24)
                }
            }
            
        },
        handleKeyUp(event) {
            if (event.key === 'ArrowUp' || event.key === 'ArrowDown'){
                clearInterval(this.playerMoving)
                this.playerMoving = null
            }
        },
        startGame() {
            new Audio(game_start).play()
            window.addEventListener('keydown', this.handleKeyDown)
            window.addEventListener('keyup', this.handleKeyUp)
            this.interval = setInterval(() => this.updateBall(), 24)
            this.cpu = setInterval(() => this.followBall(), 12)

            this.init()

            this.gameStopped = false
        },
        endGame() {
            new Audio(game_end).play()
            window.removeEventListener('keyup', this.handleKeyUp)
            window.removeEventListener('keydown', this.handleKeyDown)
            clearInterval(this.interval)
            clearInterval(this.cpu)
            clearInterval(this.playerMoving)
            this.playerMoving = null
            this.interval = null
            this.cpu = null
            this.gameStopped = true
        }
    },
}
</script>

<style>
    .container {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .game-board {
        background-color: blanchedalmond;
        width: 80dvw;
        height: 70dvh;
        min-width: 500px;
        position: relative;
        border: 5px solid black;
        margin: 20px;
    }

    .overlay {
        width: 100%;
        height: 100%;
        z-index: 99;
        background-color: rgba(0, 0, 0, 0.6);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .message-box {
        height: 25%;
        width: 60%;
        max-width: 600px;
        font-size: 2em;
        color: white;
        background-color: #16324f;
        z-index: 99;
        border-radius: 25px;
        display: flex;
        flex-direction: column; /* Added to stack score and buttons */
        justify-content: space-between; /* Added to space score and buttons */
        align-items: center;
        padding-top: 10%;
        padding-bottom: 5%;
    }

    .message-box button {
        background-color: #ff851e; /* Green background color */
        color: white; /* White text color */
        padding: 10px 20px; /* Padding for the button text */
        border: none; /* Remove border */
        border-radius: 5px; /* Rounded corners */
        cursor: pointer; /* Add a pointer cursor on hover */
        font-size: 16px; /* Font size */
    }

    .message-box button:hover {
        background-color: #45a049; /* Darker green on hover */
    }

    .ball {
        width: 20px;
        height: 20px;
        background-color: rgb(48, 45, 157);
        position: absolute;
        border-radius: 50%;
        z-index: 10;
    }

    .paddle {
        max-width: 20px;
        width: 5dvw;
        height: 200px;
        background-color: black;
        z-index: 10;
        border-radius: 5px;
    }

    .left-paddle {
        position: absolute;
        top: 20px;
        left: 10px;
    }

    .right-paddle {
        position: absolute;
        top: 20px;
        right: 10px;
    }
</style>