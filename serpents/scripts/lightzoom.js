/* Real Zoom LightZoom with Correct Drawing Alignment */

(function () {

	// Simple debounce helper
	const debounce = (func, delay) => {
		let timeout;
		return (...args) => {
			clearTimeout(timeout);
			timeout = setTimeout(() => func(...args), delay);
		};
	};

	// Main initializer
	const lightzoom = (elements, options = {}) => {
		// console.log('Initializing lightzoom'); // Debugging

		// Default settings for reference and passthrough
		const settings = {
			zoomPower: 3,
			glassSize: 175,
			lineWidth: 3,
			lineColor: "red",
			...options,
		};

		// const zoomPower = settings.zoomPower;
		// const halfSize = settings.glassSize / 2;

		// Create Magnifying Glass and Zoom Wrapper
		const glass = document.createElement('div');
		glass.id = 'glass';

		const zoomWrapper = document.createElement('div');
		zoomWrapper.classList.add('lz-zoom-wrapper');

		const crosshair = document.createElement('div');
		crosshair.id = 'crosshair';

		glass.appendChild(zoomWrapper);
		glass.appendChild(crosshair);
		document.body.appendChild(glass);

		// Debounced hover handler
		const debouncedFaker = debounce((event, wrapper) => {
			faker(event, wrapper, glass, zoomWrapper, settings);
		}, 10);

		// ForEach image loop
		elements.forEach((img) => {
			// Constants
			const wrapper = img.parentElement;
			const baseCanvas = document.createElement('canvas');
			const rect = wrapper.getBoundingClientRect();
			const zoomCanvas = document.createElement('canvas');
			const resolvedSrc = img.currentSrc; // prevents incorrect fallback

			// Wrapper position
			wrapper.classList.add('lz-wrapper');
			wrapper.style.position = 'relative';
			wrapper.appendChild(baseCanvas);

			// Make base canvas visible over base image
			baseCanvas.classList.add('lz-draw-canvas');
			baseCanvas.width = rect.width;
			baseCanvas.height = rect.height;
			baseCanvas.style.position = 'absolute';
			baseCanvas.style.top = '0';
			baseCanvas.style.left = '0';
			baseCanvas.style.pointerEvents = 'none';
			baseCanvas.style.zIndex = 5;

			// Zoom canvas (only used inside magnifier)
			zoomCanvas.classList.add('lz-zoom-canvas');
			zoomCanvas.width = rect.width;
			zoomCanvas.height = rect.height;
			zoomCanvas.style.position = 'absolute';
			zoomCanvas.style.top = '0';
			zoomCanvas.style.left = '0';
			zoomCanvas.style.pointerEvents = 'none';
			zoomCanvas.style.zIndex = 5;

			// Create zoomed image using the resolved URL
			const zoomImg = new Image();
			zoomImg.src = resolvedSrc;
			zoomImg.classList.add('lz-zoom-image');
			zoomImg.style.position = 'absolute';
			zoomImg.style.top = '0';
			zoomImg.style.left = '0';
			zoomImg.style.width = '100%';
			zoomImg.style.height = '100%';
			zoomImg.style.objectFit = 'contain';

			// Store references on wrapper
			wrapper.baseCanvas = baseCanvas;
			wrapper.zoomCanvas = zoomCanvas;
			wrapper.zoomImg = zoomImg;

			// Setup events
			setupDrawing(baseCanvas, zoomCanvas, img, wrapper, settings);

			wrapper.addEventListener('mousemove', (event) => {
				// console.log('Mouse moved over img element', event); // Debugging
				debouncedFaker(event, wrapper);
			});

			wrapper.addEventListener('mousedown', (e) => {
				// console.log('Clicked on img element', event); // Debugging
				baseCanvas.style.pointerEvents = 'auto';
				baseCanvas.dispatchEvent(new MouseEvent('mousedown', e));
			});

			wrapper.addEventListener('mouseleave', () => {
				resetGlass(glass);
			});
		});

		// Store settings
		window._lightzoomSettings = settings;
	};

	// Core magnifier logic
	const faker = (event, wrapper, glass, zoomWrapper, settings) => {
		//Constants
		// glass.targ = obj;
		const zoomPower = settings.zoomPower;
		const glassSize = settings.glassSize;
		const halfSize = glassSize / 2;
		// const quarterSize = glassSize / 4;
		// const img = wrapper.querySelector('img.light-zoom');
		const baseCanvas = wrapper.baseCanvas;
		const zoomCanvas = wrapper.zoomCanvas;
		// const zoomImg = wrapper.zoomImg;
		const bounding = wrapper.getBoundingClientRect();
		const mx = event.clientX;
		const my = event.clientY;
		const left = bounding.left;
		const top = bounding.top;
		const right = left + bounding.width;
		const bottom = top + bounding.height;
		const glassTop = my + window.pageYOffset - halfSize;
		const glassLeft = mx + window.pageXOffset - halfSize;
		const relX = mx - left; // in [0, width]
		const relY = my - top;  // in [0, height]
		const scaledX = relX * zoomPower;
		const scaledY = relY * zoomPower;
		const offsetX = halfSize - scaledX;
		const offsetY = halfSize - scaledY;

		// cancelAnimationFrame(animationFrameId);

		// Failsafe if cursor is outside wrapper
		if (!(mx > left && mx < right && my > top && my < bottom)) {
			resetGlass(glass);
			return;
		}

		// Ensure zoomWrapper and canvas match
		if (zoomWrapper.currentWrapper !== wrapper) {
			zoomWrapper.innerHTML = ''; // clear previous content
			zoomWrapper.appendChild(wrapper.zoomImg);
			zoomWrapper.appendChild(wrapper.zoomCanvas);
			zoomWrapper.currentWrapper = wrapper;
		}

		if (zoomCanvas.width !== baseCanvas.width || zoomCanvas.height !== baseCanvas.height) {
			zoomCanvas.width = baseCanvas.width;
			zoomCanvas.height = baseCanvas.height;
		}

		zoomWrapper.style.width = `${bounding.width}px`;
		zoomWrapper.style.height = `${bounding.height}px`;
		zoomWrapper.style.transformOrigin = '0 0';
		zoomWrapper.style.transform = `scale(${zoomPower})`;
		zoomWrapper.style.left = `${offsetX}px`;
		zoomWrapper.style.top = `${offsetY}px`;

		// Position the glass around the cursor (page coords)
		glass.style.top = `${glassTop}px`;
		glass.style.left = `${glassLeft}px`;
		glass.style.display = 'block';
		document.body.style.cursor = 'none';
	};

	// Reset state
	function resetGlass(glass) {
		if (!glass) {
			glass = document.getElementById('glass');
			if (!glass) return;
		}
		glass.style.display = 'none';
		document.body.style.cursor = 'default';
	}

	// Drawing logic for both base and zoom
	function setupDrawing(baseCanvas, zoomCanvas, imgElement, wrapper, settings) {
		// constants
		const baseCtx = baseCanvas.getContext('2d');
		const zoomCtx = zoomCanvas.getContext('2d');

		let drawing = false;

		const getPos = (e) => {
			const rect = wrapper.getBoundingClientRect();
			return {
				x: e.clientX - rect.left,
				y: e.clientY - rect.top,
			};
		};

		const stopDrawing = () => {
			drawing = false;
			baseCanvas.style.pointerEvents = 'none'; // return control to zoom
			baseCtx.beginPath();
			zoomCtx.beginPath();
		};

		baseCanvas.addEventListener('mousedown', (e) => {
			baseCanvas.style.pointerEvents = 'auto';
			drawing = true;
			const pos = getPos(e);

			baseCtx.beginPath();
			baseCtx.moveTo(pos.x, pos.y);
			zoomCtx.beginPath();
			zoomCtx.moveTo(pos.x, pos.y);
		});

		baseCanvas.addEventListener('mousemove', (e) => {
			if (!drawing) return;
			const pos = getPos(e);

			baseCtx.lineTo(pos.x, pos.y);
			baseCtx.strokeStyle = settings.lineColor;
			baseCtx.lineWidth = settings.lineWidth;
			baseCtx.lineCap = 'round';
			baseCtx.stroke();

			zoomCtx.lineTo(pos.x, pos.y);
			zoomCtx.strokeStyle = settings.lineColor;
			zoomCtx.lineWidth = settings.lineWidth;
			zoomCtx.lineCap = 'round';
			zoomCtx.stroke();
		});

		baseCanvas.addEventListener('mouseup', stopDrawing);
		baseCanvas.addEventListener('mouseleave', stopDrawing);
	}

	// Keep canvases in sync with wrapper size on resize and move
	window.addEventListener('resize', () => {
		document.querySelectorAll('.lz-wrapper').forEach((wrapper) => {
			// constants
			const rect = wrapper.getBoundingClientRect();
			const baseCanvas = wrapper.baseCanvas;
			const zoomCanvas = wrapper.zoomCanvas;

			if (!baseCanvas || !zoomCanvas) return;

			baseCanvas.width = rect.width;
			baseCanvas.height = rect.height;
			zoomCanvas.width = rect.width;
			zoomCanvas.height = rect.height;
		});
	});

	// Expose globally
	window.lightzoom = lightzoom;
})();

// Place this in the HTML file to initialize lightzoom on all images with the class 'lightzoom'
/*
<script>
window.addEventListener("load", function () {
	const images = document.querySelectorAll('img.light-zoom');
	lightzoom(images, {
		zoomPower: 3,    // Default = 3
		glassSize: 270,  // Default = 270
			lineWidth: 3,        // Default 3
			lineColor: 'red' // Default = 'red'
	});
});
</script>
*/

// Place this in the CSS file to style the glass element

// /*----- Light-zoom classes -----*/
// 	.lz-wrapper {
// 		position: relative;
// 		overflow: hidden;
// 		display: inline-block;
// 		padding: 0;
// 		margin: 0;
// 		border: 0;
// 	}

// 	.light-zoom {
// 		display: block;
// 		max-width: 100%;
// 		height: auto;
// 		/* transform-origin: center center; */
// 		will-change: transform;
// 	}

// 	.lz-draw-canvas {
// 		position: absolute;
// 		top: 0;
// 		left: 0;
// 		width: 100%;
// 		height: 100%;
// 		background: transparent;
// 		pointer-events: none;
// 		z-index: 5;
// 	}

// 	.lz-zoom-canvas {
// 		position: absolute;
// 		top: 0;
// 		left: 0;
// 		width: 100%;
// 		height: 100%;
// 		pointer-events: none;
// 		z-index: 5;
// 	}

// 	.lz-zoom-wrapper {
// 		position: absolute;
// 		top: 0;
// 		left: 0;
// 	}

// 	.lz-zoom-image {
// 		position: absolute;
// 		top: 0;
// 		left: 0;
// 		width: 100%;
// 		height: 100%;
// 		object-fit: contain;
// 	}

// 	#glass {
// 		position: absolute;
// 		border-radius: 50%;
// 		box-shadow: 0 0 0 7px rgba(118, 118, 117, 0.35),
// 			0 0 7px 7px rgba(0, 0, 0, 0.25), inset 0 0 40px 2px rgba(0, 0, 0, 0.25);
// 		display: none;
// 		background-repeat: no-repeat;
// 		background-color: rgba(0, 0, 0, 0.6);
// 		overflow: hidden;
// 		pointer-events: none;
// 		width: 270px; /* Ensure the width and height are set */
// 		height: 270px; /* Ensure the width and height are set */
// 		max-width: 100vw; /* Prevent it from exceeding the viewport width */
// 		max-height: 100vh; /* Prevent it from exceeding the viewport height */
// 		z-index: 20;
// 	}

// 	#crosshair {
// 		position: absolute;
// 		width: 100%;
// 		height: 100%;
// 		background: url("/serpents/images/logo-target.png") center center no-repeat;
// 		/* background-repeat: no-repeat; */
// 		/* background-position: center; */
// 		opacity: 0.5;
// 		pointer-events: none;
// 		z-index: 10; /* Ensure the crosshair stays on top */
// 	}