// ===== DOM Elements =====
const loadingScreen = document.getElementById('loadingScreen');
const gameFrame = document.getElementById('gameFrame');
const gameContainer = document.getElementById('gameContainer');
const fullscreenBtn = document.getElementById('fullscreenBtn');
const controlsBtn = document.getElementById('controlsBtn');
const controlsOverlay = document.getElementById('controlsOverlay');
const closeControlsBtn = document.getElementById('closeControlsBtn');

// ===== Loading Screen =====
gameFrame.addEventListener('load', () => {
    setTimeout(() => {
        loadingScreen.classList.add('hidden');
    }, 1000);
});

// Hide loading screen after 10 seconds even if iframe doesn't load
setTimeout(() => {
    loadingScreen.classList.add('hidden');
}, 10000);

// ===== Fullscreen Functionality =====
let isFullscreen = false;

function toggleFullscreen() {
    if (!isFullscreen) {
        enterFullscreen();
    } else {
        exitFullscreen();
    }
}

function enterFullscreen() {
    const elem = gameContainer;
    
    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    } else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen();
    } else if (elem.mozRequestFullScreen) {
        elem.mozRequestFullScreen();
    } else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen();
    }
}

function exitFullscreen() {
    if (document.exitFullscreen) {
        document.exitFullscreen();
    } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
    } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
    } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
    }
}

// Listen for fullscreen changes
document.addEventListener('fullscreenchange', handleFullscreenChange);
document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
document.addEventListener('mozfullscreenchange', handleFullscreenChange);
document.addEventListener('MSFullscreenChange', handleFullscreenChange);

function handleFullscreenChange() {
    isFullscreen = !!(document.fullscreenElement || 
                      document.webkitFullscreenElement || 
                      document.mozFullScreenElement || 
                      document.msFullscreenElement);
    
    if (isFullscreen) {
        gameContainer.classList.add('fullscreen');
        updateFullscreenIcon(true);
    } else {
        gameContainer.classList.remove('fullscreen');
        updateFullscreenIcon(false);
    }
}

function updateFullscreenIcon(isFullscreen) {
    const icon = document.getElementById('fullscreenIcon');
    if (isFullscreen) {
        // Exit fullscreen icon
        icon.innerHTML = '<path d="M8 3v3a2 2 0 0 1-2 2H3m18 0h-3a2 2 0 0 1-2-2V3m0 18v-3a2 2 0 0 1 2-2h3M3 16h3a2 2 0 0 1 2 2v3"/>';
    } else {
        // Enter fullscreen icon
        icon.innerHTML = '<path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>';
    }
}

// Fullscreen button click
fullscreenBtn.addEventListener('click', toggleFullscreen);

// ===== Controls Overlay =====
function showControls() {
    controlsOverlay.classList.add('active');
    document.body.style.overflow = 'hidden';
}

function hideControls() {
    controlsOverlay.classList.remove('active');
    document.body.style.overflow = '';
}

controlsBtn.addEventListener('click', showControls);
closeControlsBtn.addEventListener('click', hideControls);

// Close controls when clicking outside
controlsOverlay.addEventListener('click', (e) => {
    if (e.target === controlsOverlay) {
        hideControls();
    }
});

// ===== Keyboard Shortcuts =====
document.addEventListener('keydown', (e) => {
    // F11 for fullscreen (prevent default browser behavior)
    if (e.key === 'F11') {
        e.preventDefault();
        toggleFullscreen();
    }
    
    // ESC to exit fullscreen or close controls
    if (e.key === 'Escape') {
        if (controlsOverlay.classList.contains('active')) {
            hideControls();
        } else if (isFullscreen) {
            exitFullscreen();
        }
    }
    
    // C to toggle controls (when not in fullscreen)
    if (e.key === 'c' || e.key === 'C') {
        if (!isFullscreen && !controlsOverlay.classList.contains('active')) {
            showControls();
        }
    }
});

// ===== Button Hover Effects =====
const buttons = document.querySelectorAll('.control-btn, .back-btn');

buttons.forEach(button => {
    button.addEventListener('mouseenter', () => {
        button.style.transform = button.classList.contains('back-btn') 
            ? 'translateX(-3px)' 
            : 'translateY(-2px)';
    });
    
    button.addEventListener('mouseleave', () => {
        button.style.transform = '';
    });
});

// ===== Ripple Effect =====
buttons.forEach(button => {
    button.addEventListener('click', function(e) {
        const ripple = document.createElement('span');
        ripple.style.cssText = `
            position: absolute;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: translate(-50%, -50%);
            animation: ripple 0.6s ease-out;
            pointer-events: none;
        `;
        
        const rect = button.getBoundingClientRect();
        ripple.style.left = (e.clientX - rect.left) + 'px';
        ripple.style.top = (e.clientY - rect.top) + 'px';
        
        button.style.position = 'relative';
        button.appendChild(ripple);
        
        setTimeout(() => ripple.remove(), 600);
    });
});

// Add ripple animation
const style = document.createElement('style');
style.textContent = `
    @keyframes ripple {
        to {
            width: 200px;
            height: 200px;
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// ===== Auto-show controls on first visit =====
const hasVisited = localStorage.getItem('eaglercraft-visited');
if (!hasVisited) {
    setTimeout(() => {
        showControls();
        localStorage.setItem('eaglercraft-visited', 'true');
    }, 3000);
}

// ===== Console Easter Egg =====
console.log('%c🎮 Eaglercraft Game View 🎮', 'font-size: 20px; color: #4ade80; font-weight: bold;');
console.log('%cKeyboard Shortcuts:', 'font-size: 14px; color: #7cbd3a; font-weight: bold;');
console.log('%c  F11 - Toggle Fullscreen', 'font-size: 12px; color: #9ca3af;');
console.log('%c  C   - Show Controls', 'font-size: 12px; color: #9ca3af;');
console.log('%c  ESC - Exit Fullscreen/Close Controls', 'font-size: 12px; color: #9ca3af;');
