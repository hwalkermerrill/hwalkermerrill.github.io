/*
 Author: Original - Jafar Akhondali; Refactored By - Harrison Merrill
 Release year: 2016; Refactored 2025
 Explanation: Light-zoom was a JQuery plugin that used pure CSS to zoom in on images.
 This enabled you to zoom without loading a bigger image and zoom even on gif images.
 The original code was refactored to use requestAnimationFrame for smoother updates and
 to improve performance. The code was also updated to use modern JavaScript features such
 as arrow functions and template literals and to remove jQuery dependency. These
 improvements dramatically improved the code's usability and compatability, as well as
 reduced its library overhead. Despite being  essentially completely re-written, the
 code retains the original author's name in the header for attribution purposes.
 Link to original script: https://github.com/JafarAkhondali/lightzoom
 */

(function () {
	const debounce = (func, delay) => {
		let timeout;
		return (...args) => {
			clearTimeout(timeout);
			timeout = setTimeout(() => func(...args), delay);
		};
	};

	const lightzoom = (elements, options = {}) => {
		console.log('Initializing lightzoom'); // Debugging

		const settings = {
			zoomPower: 3,
			glassSize: 175,
			...options, // Merge default settings with passed options
		};

		const halfSize = settings.glassSize / 2;
		const quarterSize = settings.glassSize / 4;
		const zoomPower = settings.zoomPower;

		// Create the glass element
		const glass = document.createElement('div');
		glass.id = 'glass';
		glass.innerHTML = '<div id="crosshair"></div>';
		document.body.appendChild(glass);

		let animationFrameId;

		// Debounced faker function
		const debouncedFaker = debounce((event, targetObj) => {
			faker(event, targetObj);
		}, 10);

		// Apply lightzoom functionality to all target elements
		elements.forEach((element) => {
			element.addEventListener('mousemove', (event) => {
				console.log('Mouse moved over img element', event); // Debugging
				debouncedFaker(event, element);
			});
		});

		glass.addEventListener('mousemove', (event) => {
			const targetObj = glass.targ;
			event.target = targetObj;
			console.log('Mouse moved over glass element', event); // Debugging
			debouncedFaker(event, targetObj);
		});

		const faker = (event, obj) => {
			console.log('Faker function called', event, obj); // Debugging
			glass.targ = obj;
			const mx = event.pageX;
			const my = event.pageY;
			const bounding = obj.getBoundingClientRect();
			const w = bounding.width;
			const h = bounding.height;

			// Offset position of the image relative to the document, accounting for scroll
			const ol = bounding.left + window.pageXOffset;
			const ot = bounding.top + window.pageYOffset;

			// Extract src, considering <picture> tag
			let src = obj.src;
			if (obj.parentElement.tagName.toLowerCase() === 'picture') {
				const sourceElement = obj.parentElement.querySelector('source');
				if (sourceElement && sourceElement.hasAttribute('srcset')) {
					src = sourceElement.getAttribute('srcset');
				}
			}

			// Calculate and update zoom effect
			if (mx > ol && mx < ol + w && ot < my && ot + h > my) {
				const offsetXfixer = ((mx - ol - w / 2) / (w / 2)) * quarterSize;
				const offsetYfixer = ((my - ot - h / 2) / (h / 2)) * quarterSize;
				const cx = (((mx - ol + offsetXfixer) / w)) * 100;
				const cy = (((my - ot + offsetYfixer) / h)) * 100;
				const newMy = my - halfSize;
				const newMx = mx - halfSize;

				// Use requestAnimationFrame for smoother updates
				cancelAnimationFrame(animationFrameId);
				animationFrameId = requestAnimationFrame(() => {
					glass.style.top = `${newMy}px`;
					glass.style.left = `${newMx}px`;
					glass.style.backgroundImage = `url('${src}')`;
					glass.style.backgroundSize = `${w * zoomPower}px ${h * zoomPower}px`;
					glass.style.backgroundPosition = `${cx}% ${cy}%`;
					glass.style.display = 'inline-block';
					document.body.style.cursor = 'none';
				});
			} else {
				glass.style.display = 'none';
				document.body.style.cursor = 'default';
			}
		};
	};

	// Attach lightzoom to the global window object for use
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
	});
});
</script>
*/

// Place this in the CSS file to style the glass element

/*----- Light-zoom classes -----*/
// #glass {
// 	position: absolute;
// 	border - radius: 50 %;
// 	box - shadow: 0 0 0 7px rgba(118, 118, 117, 0.35),
// 		0 0 7px 7px rgba(0, 0, 0, 0.25), inset 0 0 40px 2px rgba(0, 0, 0, 0.25);
// 	display: none;
// 	background - repeat: no - repeat;
// 	background - color: rgba(0, 0, 0, 0.6);
// 	overflow: hidden;
// 	width: 270px; /* Ensure the width and height are set */
// 	height: 270px; /* Ensure the width and height are set */
// 	max - width: 100vw; /* Prevent it from exceeding the viewport width */
// 	max - height: 100vh; /* Prevent it from exceeding the viewport height */
// }
// #crosshair {
// 	position: absolute;
// 	width: 100 %;
// 	height: 100 %;
// 	background: url("/serpents/images/logo-target.png") center center no - repeat;
// 	background - repeat: no - repeat;
// 	background - position: center;
// 	opacity: 0.5;
// 	pointer - events: none;
// 	z - index: 10; /* Ensure the crosshair stays on top */
// }