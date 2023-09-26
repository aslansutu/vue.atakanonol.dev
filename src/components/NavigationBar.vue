<template>
    <header :class="{ 'scrolled-nav': scrolledNav }">
        <nav>
            <div class="branding">
                <img src="@/assets/logo.png" alt="" />
            </div>
            <ul v-show="!mobile" class="navigation">
                <div class="dropdown-menu">
                    <li><router-link class="link" :to="{ name: 'Home' }">Home</router-link></li>
                    <div class="dropdown-contents">
                        
                    </div>
                </div>
                <li><router-link class="link" :to="{ name: 'About' }">About</router-link></li>
                <li><router-link class="link" :to="{ name: 'Contact' }">Contact</router-link></li>
            </ul>
            <div class="icon" @click="toggleMobileNav" v-show="mobile" :class="{ 'icon-active': mobileNav }">
                <font-awesome-icon :icon="['fas', 'bars']" />
            </div>
            <transition name="mobile-nav">
                <ul v-show="mobileNav" class="dropdown-nav">
                <li><router-link class="link" :to="{ name: 'Home' }">Home</router-link></li>
                <li><router-link class="link" :to="{ name: 'About' }">About</router-link></li>
                <li><router-link class="link" :to="{ name: 'Contact' }">Contact</router-link></li>
            </ul>
            </transition>
        </nav>
    </header>
</template>

<script>
export default {
    name: "NavigationBar",
    data() {
        return {
            scrolledNav: null,
            mobile: null,
            mobileNav: null,
            windowWidth: null
        }
    },
    created() {
        window.addEventListener("resize", this.checkScreen)
        this.checkScreen()
    },
    mounted() {
        window.addEventListener("scroll", this.updateScroll)
    },
    methods: {
        toggleMobileNav () {
            this.mobileNav = !this.mobileNav
        },
        checkScreen () {
            this.windowWidth = window.innerWidth
            if (this.windowWidth <= 750) {
                this.mobile = true
                return
            }
            this.mobile = false
            this.mobileNav = false
        },
        updateScroll () {
            const scrollPosition = window.scrollY
            if (scrollPosition > 50) {
                this.scrollNav = true
                return
            }
            this.scrollNav = false
        }
    }
}
</script>

<style lang="scss" scoped>
header {
    background-color: rgba(255, 255, 255);
    z-index: 99;
    width: 100%;
    position: fixed;
    top: 0px;
    left: 0px;
    transition: .5s ease all;
    color: #fff;
    box-shadow: 0px 2px #ff851b6c;

    nav {
        position: relative;
        display: flex;
        flex-direction: row;
        padding: 0;
        transition: .5s ease all;
        height: 5vh;
        min-height: 50px;
        width: 90%;
        margin: 0 auto;
        @media (min-width: 1140px) {
            max-width: 1140px;
        }

        ul,
        .link {
            font-weight: 500;
            color: #001f3f;
            list-style: none;
            text-decoration: none;
        }

        li {
            text-transform: uppercase;
            padding: 16px;
            margin-left: 16px;
        }

        .link {
            font-size: 14px;
            transition: .5s ease all;
            padding-bottom: 4px;
            border-bottom: 1px solid transparent;

            &:hover {
                color: #ff851b;
                border-color: #ff851b;
            }
        }

        .branding {
            display: flex;
            align-items: center;

            img {
                max-height: 50px;
                transition: .5s ease all;
            }
        }

        .navigation {
            display: flex;
            align-items: center;
            flex: 1;
            justify-content: flex-end;
        }

        .icon {
            display: flex;
            align-items: center;
            position: absolute;
            top: 0px;
            right: 24px;
            height: 100%;
            cursor: pointer;
            font-size: 24px;
            transition: .8s ease all;
            color: #001f3f;
        }

        .icon-active {
            transform: rotate(180deg);
        }

        .dropdown-nav {
            display: flex;
            flex-direction: column;
            position: fixed;
            width: 100%;
            max-width: 250px;
            height: 100%;
            background-color: #fff;
            top: 0px;
            left: 0px;
            margin-top: 0px;
            padding-top: 20px;
            padding-left: 0px;

            li {
                margin-left: 0px;
                text-align: left;
                .link {
                    color: #000;
                }
            }
        }

        .mobile-nav-enter-active,
        .mobile-nav-leave-active {
            transition: .8s ease all;
        }

        .mobile-nav-enter-from,
        .mobile-nav-leave-to {
            transform: translateX(-250px);
        }

        .mobile-nav-enter-to {
            transform: translateX(0);
        }
    }
}

.scrolled-nav {
    background-color: #000;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);

    nav {
        padding: 8px 0;

        .branding {
            img {
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            }
        }
    }
}
</style>