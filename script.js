/**
 * Katana Auto — Site Scripts
 */

const STORAGE_KEY = 'katana_data';

function getSiteData() {
    try {
        const stored = localStorage.getItem(STORAGE_KEY);
        if (stored) return JSON.parse(stored);
    } catch (e) {}
    return typeof window.KATANA_DATA !== 'undefined' ? window.KATANA_DATA : { reviews: [], products: [], wheelShowcase: [] };
}

// Mobile menu toggle
document.addEventListener('DOMContentLoaded', () => {
    const data = getSiteData();
    const logoImg = document.getElementById('company-logo');
    const logoText = logoImg && logoImg.nextElementSibling;
    if (logoImg && data.logo) {
        logoImg.src = data.logo;
        logoImg.style.display = 'block';
        if (logoText) logoText.style.display = 'none';
    } else if (logoText) {
        logoText.style.display = 'flex';
    }
    const heroBg = document.querySelector('.hero__bg');
    if (heroBg && data.heroBackground) {
        heroBg.style.backgroundImage = "linear-gradient(to right, rgba(12, 18, 34, 0.85) 0%, rgba(12, 18, 34, 0.5) 70%, transparent 100%), url('" + data.heroBackground + "')";
        heroBg.style.backgroundSize = "cover";
        heroBg.style.backgroundPosition = "center";
    }
    const navToggle = document.querySelector('.nav__toggle');
    const navList = document.querySelector('.nav__list');

    if (navToggle && navList) {
        navToggle.addEventListener('click', () => {
            navList.classList.toggle('active');
            const expanded = navList.classList.contains('active');
            navToggle.setAttribute('aria-expanded', expanded);
        });

        // Close menu on link click (mobile)
        navList.querySelectorAll('.nav__link').forEach(link => {
            link.addEventListener('click', () => navList.classList.remove('active'));
        });
    }

    // Hash filter: #tires or #wheels sets catalog filter (before initCatalog runs)
    const hash = window.location.hash.slice(1);
    if (hash === 'tires' || hash === 'wheels') {
        const catFilter = document.getElementById('filter-category');
        if (catFilter) catFilter.value = hash;
    }

    // Stats counter animation
    animateCounters();

    // Load dynamic content
    renderReviews();
    renderWheelShowcase();

    // Catalog
    initCatalog();
});

function renderReviews() {
    const data = getSiteData();
    const container = document.getElementById('reviews-slider');
    if (!container) return;
    if (!data.reviews || data.reviews.length === 0) {
        container.innerHTML = '<div class="review-card"><p>Отзывы скоро появятся</p></div>';
        return;
    }
    container.innerHTML = data.reviews.map(r => `
        <div class="review-card">
            <div class="review-card__stars">${'★'.repeat(r.rating)}${'☆'.repeat(5 - (r.rating || 5))}</div>
            <p class="review-card__text">${r.text}</p>
            <p class="review-card__author">— ${r.author || 'Клиент'}</p>
        </div>
    `).join('');
}

function renderWheelShowcase() {
    const data = getSiteData();
    const container = document.getElementById('wheel-showcase');
    if (!container) return;
    const items = data.wheelShowcase || [];
    if (items.length === 0) {
        container.style.display = 'none';
        return;
    }
    container.style.display = 'flex';
    container.innerHTML = items.map(w => `
        <a href="https://baza.drom.ru/user/KatanaAuto38/wheel/" target="_blank" rel="noopener" class="wheel-showcase__item">
            <img src="${w.image}" alt="${w.title || 'Колесо'}">
        </a>
    `).join('');
}

// Animate number counters when in view
function animateCounters() {
    const counters = document.querySelectorAll('.stat__number[data-count]');

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const el = entry.target;
                const target = parseInt(el.dataset.count, 10);
                animateValue(el, 0, target, 1500);
                observer.unobserve(el);
            }
        });
    }, { threshold: 0.5 });

    counters.forEach(c => observer.observe(c));
}

function animateValue(el, start, end, duration) {
    const startTime = performance.now();

    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const easeOut = 1 - Math.pow(1 - progress, 3);
        const current = Math.round(start + (end - start) * easeOut);
        el.textContent = current.toLocaleString('ru-RU');

        if (progress < 1) {
            requestAnimationFrame(update);
        } else {
            el.textContent = end.toLocaleString('ru-RU');
        }
    }

    requestAnimationFrame(update);
}

// Catalog: merge default products with admin products
const defaultProducts = [
    { id: 1, category: 'tires', brand: 'bridgestone', title: 'Шины Bridgestone 205/55 R16', image: null },
    { id: 2, category: 'tires', brand: 'yokohama', title: 'Шины Yokohama 225/45 R17', image: null },
    { id: 3, category: 'tires', brand: 'toyota', title: 'Шины 215/60 R16 Toyota', image: null },
    { id: 4, category: 'wheels', brand: 'toyota', title: 'Диски Toyota Camry 17"', image: null },
    { id: 5, category: 'wheels', brand: 'honda', title: 'Диски Honda Accord 17"', image: null },
    { id: 6, category: 'wheels', brand: 'nissan', title: 'Диски Nissan X-Trail 18"', image: null },
    { id: 7, category: 'wheels', brand: 'mazda', title: 'Диски Mazda CX-5 19"', image: null },
    { id: 8, category: 'wheels', brand: 'mitsubishi', title: 'Диски Mitsubishi Outlander', image: null },
];

function getProducts() {
    const data = getSiteData();
    const adminProducts = (data.products || []).filter(p => p.category && p.category !== 'showcase')
        .map(p => ({ ...p, category: p.category, brand: 'custom', title: p.title, image: p.image }));
    return [...adminProducts, ...defaultProducts];
}

const brandLabels = {
    bridgestone: 'Bridgestone',
    yokohama: 'Yokohama',
    toyota: 'Toyota',
    honda: 'Honda',
    nissan: 'Nissan',
    mazda: 'Mazda',
    mitsubishi: 'Mitsubishi',
};

const categoryLabels = {
    tires: 'Шины',
    wheels: 'Диски',
};

function initCatalog() {
    const grid = document.getElementById('catalog-grid');
    const emptyMsg = document.getElementById('catalog-empty');
    const filterCategory = document.getElementById('filter-category');
    const filterBrand = document.getElementById('filter-brand');

    function renderProducts() {
        const products = getProducts();
        const category = filterCategory?.value || 'all';
        const brand = filterBrand?.value || 'all';

        const filtered = products.filter(p => {
            const matchCategory = category === 'all' || p.category === category;
            const matchBrand = brand === 'all' || p.brand === brand;
            return matchCategory && matchBrand;
        });

        if (!grid) return;

        if (filtered.length === 0) {
            grid.innerHTML = '';
            if (emptyMsg) emptyMsg.style.display = 'block';
            return;
        }

        if (emptyMsg) emptyMsg.style.display = 'none';

        const getProductImage = (p) => p.image
            ? `<img src="${p.image}" alt="${p.title}" onerror="this.parentElement.innerHTML='🛞'">`
            : '🛞';

        grid.innerHTML = filtered.map(p => `
            <article class="product-card" data-category="${p.category}" data-brand="${p.brand}">
                <div class="product-card__image">${getProductImage(p)}</div>
                <div class="product-card__content">
                    <span class="product-card__category">${categoryLabels[p.category] || p.category}</span>
                    <h3 class="product-card__title">${p.title}</h3>
                    <p class="product-card__brand">${p.price || brandLabels[p.brand] || ''}</p>
                </div>
            </article>
        `).join('');
    }

    filterCategory?.addEventListener('change', renderProducts);
    filterBrand?.addEventListener('change', renderProducts);

    renderProducts();
}
