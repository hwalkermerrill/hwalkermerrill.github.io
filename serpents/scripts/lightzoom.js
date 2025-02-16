/*
 Author: Original - Jafar Akhondali; Edited By - Harrison Merrill
 Release year: 2016; Modernized 2025
 Title:	Light-Zoom JQuery plugin that use pure css to zoom on images, this enables
 you to zoom without loading bigger image and zoom even on gif images!
 https://github.com/JafarAkhondali/lightzoom
 */
(function ($) {
	const debounce = (func, delay) => {
		let timeout;
		return (...args) => {
			clearTimeout(timeout);
			timeout = setTimeout(() => func(...args), delay);
		};
	};

	$.fn.lightzoom = function (options) {
		console.log('Initializing lightzoom'); // Added for debugging

		const settings = $.extend({
			zoomPower: 3,
			glassSize: 175,
		}, options);

		const halfSize = settings.glassSize / 2;
		const quarterSize = settings.glassSize / 4;
		const zoomPower = settings.zoomPower;

		$('body').append('<div id="glass"><div id="crosshair"></div></div>');

		let faker;
		const obj = this;

		const glass = document.getElementById('glass');
		let animationFrameId;

		const debouncedFaker = debounce((event, obj) => faker(event, obj), 10);

		glass.addEventListener('mousemove', event => {
			console.log('Mouse moved over glass element', event); // Added for debugging
			const targetObj = glass.targ;
			event.target = targetObj;
			debouncedFaker(event, targetObj);
		});

		obj.on('mousemove', event => {
			console.log('Mouse moved over img element', event); // Added for debugging
			debouncedFaker(event, obj[0]);
		});

		faker = (event, obj) => {
			console.log('Faker function called', event, obj); // Added for debugging
			glass.targ = obj;
			const mx = event.pageX;
			const my = event.pageY;
			const bounding = obj.getBoundingClientRect();
			const w = bounding.width;
			const h = bounding.height;
			const { left: ol, top: ot } = $(obj).offset();

			let src = obj.src;
			if (obj.parentElement.tagName.toLowerCase() === 'picture') {
				const sourceElement = obj.parentElement.querySelector('source');
				if (sourceElement && sourceElement.hasAttribute('srcset')) {
					src = sourceElement.getAttribute('srcset');
				}
			}

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

		return this;
	};
})(jQuery);
